#!/bin/bash
#
# Export Zen Browser pinned tabs to bookmarks folder
# Creates/updates a "Pinned Tabs Backup" folder in bookmarks
#
# Usage: ~/.local/bin/zen-export-pins-to-bookmarks.sh
#
# NOTE: Run this with Zen Browser CLOSED
#

set -e

PROFILE_DIR="$HOME/Library/Application Support/zen/Profiles/txdl5t74.Default (release)"
DB_PATH="$PROFILE_DIR/places.sqlite"

echo "Exporting pinned tabs to bookmarks..."

# Check if Zen is running
if pgrep -x "zen" > /dev/null || pgrep -f "Zen Browser" > /dev/null; then
    echo "ERROR: Zen Browser appears to be running. Please close it first."
    exit 1
fi

python3 << 'PYTHON_SCRIPT'
import sqlite3
import os
import time

profile_dir = os.path.expanduser("~/Library/Application Support/zen/Profiles/txdl5t74.Default (release)")
db_path = os.path.join(profile_dir, "places.sqlite")

conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Get the bookmarks menu folder ID
cursor.execute("SELECT id FROM moz_bookmarks WHERE guid = 'menu________'")
menu_id = cursor.fetchone()[0]

# Check if "Pinned Tabs Backup" folder exists
cursor.execute("""
    SELECT id FROM moz_bookmarks 
    WHERE parent = ? AND title = 'Pinned Tabs Backup' AND type = 2
""", (menu_id,))
result = cursor.fetchone()

if result:
    backup_folder_id = result[0]
    # Clear existing contents
    cursor.execute("DELETE FROM moz_bookmarks WHERE parent = ?", (backup_folder_id,))
    print("Cleared existing Pinned Tabs Backup folder")
else:
    # Create the folder
    cursor.execute("SELECT MAX(position) FROM moz_bookmarks WHERE parent = ?", (menu_id,))
    max_pos = cursor.fetchone()[0] or 0
    
    cursor.execute("SELECT MAX(id) FROM moz_bookmarks")
    new_id = cursor.fetchone()[0] + 1
    
    now = int(time.time() * 1000000)
    
    cursor.execute("""
        INSERT INTO moz_bookmarks (id, type, parent, position, title, dateAdded, lastModified, guid)
        VALUES (?, 2, ?, ?, 'Pinned Tabs Backup', ?, ?, ?)
    """, (new_id, menu_id, max_pos + 1, now, now, f'pinnedbackup_{int(time.time())}'))
    
    backup_folder_id = new_id
    print("Created Pinned Tabs Backup folder")

# Get workspaces
cursor.execute("SELECT uuid, name FROM zen_workspaces ORDER BY position")
workspaces = cursor.fetchall()

# Get all pins
cursor.execute("""
    SELECT uuid, title, url, workspace_uuid, is_group, folder_parent_uuid, position
    FROM zen_pins 
    ORDER BY workspace_uuid, position
""")
all_pins = cursor.fetchall()

bookmark_position = 0
now = int(time.time() * 1000000)

for ws_uuid, ws_name in workspaces:
    # Create workspace subfolder
    cursor.execute("SELECT MAX(id) FROM moz_bookmarks")
    ws_folder_id = cursor.fetchone()[0] + 1
    
    cursor.execute("""
        INSERT INTO moz_bookmarks (id, type, parent, position, title, dateAdded, lastModified, guid)
        VALUES (?, 2, ?, ?, ?, ?, ?, ?)
    """, (ws_folder_id, backup_folder_id, bookmark_position, ws_name, now, now, f'ws_{ws_uuid[:8]}_{int(time.time())}'))
    bookmark_position += 1
    
    # Get folders for this workspace
    ws_folders = [(p[0], p[1], p[5], p[6]) for p in all_pins if p[3] == ws_uuid and p[4] == 1]
    ws_pins = [(p[0], p[1], p[2], p[5], p[6]) for p in all_pins if p[3] == ws_uuid and p[4] == 0 and p[2]]
    
    folder_position = 0
    folder_id_map = {}
    
    # Create bookmark folders for pin folders
    for folder_uuid, folder_title, _, _ in ws_folders:
        cursor.execute("SELECT MAX(id) FROM moz_bookmarks")
        bm_folder_id = cursor.fetchone()[0] + 1
        
        cursor.execute("""
            INSERT INTO moz_bookmarks (id, type, parent, position, title, dateAdded, lastModified, guid)
            VALUES (?, 2, ?, ?, ?, ?, ?, ?)
        """, (bm_folder_id, ws_folder_id, folder_position, f"[{folder_title}]", now, now, f'fold_{folder_uuid[:8]}_{int(time.time())}'))
        
        folder_id_map[folder_uuid] = bm_folder_id
        folder_position += 1
    
    # Add pins
    pin_positions = {folder_id: 0 for folder_id in folder_id_map.values()}
    pin_positions[ws_folder_id] = folder_position  # For root-level pins
    
    for pin_uuid, title, url, folder_parent, _ in ws_pins:
        # Get or create place entry
        cursor.execute("SELECT id FROM moz_places WHERE url = ?", (url,))
        place_result = cursor.fetchone()
        
        if place_result:
            place_id = place_result[0]
        else:
            cursor.execute("SELECT MAX(id) FROM moz_places")
            place_id = (cursor.fetchone()[0] or 0) + 1
            cursor.execute("""
                INSERT INTO moz_places (id, url, title, rev_host, visit_count, hidden, typed, frecency, last_visit_date, guid)
                VALUES (?, ?, ?, ?, 0, 0, 0, -1, NULL, ?)
            """, (place_id, url, title, '', f'place_{pin_uuid[:8]}'))
        
        # Determine parent folder
        if folder_parent and folder_parent in folder_id_map:
            parent_id = folder_id_map[folder_parent]
        else:
            parent_id = ws_folder_id
        
        # Create bookmark
        cursor.execute("SELECT MAX(id) FROM moz_bookmarks")
        bm_id = cursor.fetchone()[0] + 1
        
        cursor.execute("""
            INSERT INTO moz_bookmarks (id, type, fk, parent, position, title, dateAdded, lastModified, guid)
            VALUES (?, 1, ?, ?, ?, ?, ?, ?, ?)
        """, (bm_id, place_id, parent_id, pin_positions[parent_id], title, now, now, f'pin_{pin_uuid[:8]}_{int(time.time())}'))
        
        pin_positions[parent_id] += 1

conn.commit()
conn.close()

total_pins = len([p for p in all_pins if p[4] == 0 and p[2]])
total_folders = len([p for p in all_pins if p[4] == 1])
print(f"Exported {total_pins} pins and {total_folders} folders to bookmarks")
print("Look for 'Pinned Tabs Backup' in your Bookmarks menu")
PYTHON_SCRIPT

echo "Done! Open Zen Browser and check Bookmarks > Pinned Tabs Backup"
