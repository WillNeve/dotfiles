#!/bin/bash
#
# Restore Zen Browser pinned tabs from the "Pinned Tabs Backup" bookmarks folder
# This recreates pins in the zen_pins table from bookmarks
#
# Usage: ~/.local/bin/zen-restore-pins-from-bookmarks.sh
#
# NOTE: Run this with Zen Browser CLOSED
#

set -e

PROFILE_DIR="$HOME/Library/Application Support/zen/Profiles/txdl5t74.Default (release)"
DB_PATH="$PROFILE_DIR/places.sqlite"

echo "Restoring pinned tabs from bookmarks..."

# Check if Zen is running
if pgrep -x "zen" > /dev/null || pgrep -f "Zen Browser" > /dev/null; then
    echo "ERROR: Zen Browser appears to be running. Please close it first."
    exit 1
fi

python3 << 'PYTHON_SCRIPT'
import sqlite3
import os
import time
import uuid

profile_dir = os.path.expanduser("~/Library/Application Support/zen/Profiles/txdl5t74.Default (release)")
db_path = os.path.join(profile_dir, "places.sqlite")

conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Find the "Pinned Tabs Backup" folder
cursor.execute("""
    SELECT id FROM moz_bookmarks 
    WHERE title = 'Pinned Tabs Backup' AND type = 2
""")
result = cursor.fetchone()

if not result:
    print("ERROR: 'Pinned Tabs Backup' folder not found in bookmarks")
    print("Run zen-export-pins-to-bookmarks.sh first to create it")
    exit(1)

backup_folder_id = result[0]

# Get workspace mapping (folder name -> workspace uuid)
cursor.execute("SELECT uuid, name FROM zen_workspaces")
workspace_map = {row[1]: row[0] for row in cursor.fetchall()}
workspace_containers = {}
cursor.execute("SELECT uuid, container_id FROM zen_workspaces")
for row in cursor.fetchall():
    workspace_containers[row[0]] = row[1]

print(f"Found workspaces: {list(workspace_map.keys())}")

# Clear existing pins (optional - ask user)
cursor.execute("SELECT COUNT(*) FROM zen_pins")
existing_count = cursor.fetchone()[0]

if existing_count > 0:
    print(f"\nWARNING: There are {existing_count} existing pins in the database.")
    response = input("Do you want to DELETE existing pins before restore? (yes/no): ")
    if response.lower() == 'yes':
        cursor.execute("DELETE FROM zen_pins")
        cursor.execute("DELETE FROM zen_pins_changes")
        print("Cleared existing pins")
    else:
        print("Keeping existing pins, will add restored pins")

# Get workspace subfolders from backup
cursor.execute("""
    SELECT id, title FROM moz_bookmarks 
    WHERE parent = ? AND type = 2
    ORDER BY position
""", (backup_folder_id,))
workspace_folders = cursor.fetchall()

now = int(time.time() * 1000)
pin_count = 0
folder_count = 0

for ws_folder_id, ws_name in workspace_folders:
    workspace_uuid = workspace_map.get(ws_name)
    if not workspace_uuid:
        print(f"  Warning: Workspace '{ws_name}' not found, skipping")
        continue
    
    container_id = workspace_containers.get(workspace_uuid, 1)
    print(f"\nRestoring workspace: {ws_name}")
    
    # Get all items in this workspace folder
    cursor.execute("""
        SELECT b.id, b.title, b.type, p.url, b.position
        FROM moz_bookmarks b
        LEFT JOIN moz_places p ON b.fk = p.id
        WHERE b.parent = ?
        ORDER BY b.position
    """, (ws_folder_id,))
    
    items = cursor.fetchall()
    position = 0
    
    for item_id, title, item_type, url, _ in items:
        if item_type == 2:  # Folder (pin folder)
            folder_title = title.strip('[]')  # Remove brackets we added
            folder_uuid = '{' + str(uuid.uuid4()) + '}'
            
            cursor.execute("""
                INSERT INTO zen_pins (uuid, title, url, container_id, workspace_uuid, position, 
                                      is_essential, is_group, created_at, updated_at)
                VALUES (?, ?, NULL, ?, ?, ?, 0, 1, ?, ?)
            """, (folder_uuid, folder_title, container_id, workspace_uuid, position, now, now))
            
            folder_count += 1
            position += 1
            print(f"    [Folder] {folder_title}")
            
            # Get pins inside this folder
            cursor.execute("""
                SELECT b.title, p.url, b.position
                FROM moz_bookmarks b
                JOIN moz_places p ON b.fk = p.id
                WHERE b.parent = ? AND b.type = 1
                ORDER BY b.position
            """, (item_id,))
            
            folder_pins = cursor.fetchall()
            folder_position = 0
            
            for pin_title, pin_url, _ in folder_pins:
                pin_uuid = '{' + str(uuid.uuid4()) + '}'
                cursor.execute("""
                    INSERT INTO zen_pins (uuid, title, url, container_id, workspace_uuid, position,
                                          is_essential, is_group, created_at, updated_at, folder_parent_uuid)
                    VALUES (?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?)
                """, (pin_uuid, pin_title, pin_url, container_id, workspace_uuid, folder_position, now, now, folder_uuid))
                pin_count += 1
                folder_position += 1
            
            print(f"      ({len(folder_pins)} pins)")
            
        elif item_type == 1 and url:  # Regular bookmark (root-level pin)
            pin_uuid = '{' + str(uuid.uuid4()) + '}'
            cursor.execute("""
                INSERT INTO zen_pins (uuid, title, url, container_id, workspace_uuid, position,
                                      is_essential, is_group, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, 0, 0, ?, ?)
            """, (pin_uuid, title, url, container_id, workspace_uuid, position, now, now))
            pin_count += 1
            position += 1
            print(f"    {title}")

conn.commit()
conn.close()

print(f"\n{'='*50}")
print(f"Restored {pin_count} pins and {folder_count} folders")
print("Open Zen Browser to see your restored pins!")
PYTHON_SCRIPT

echo ""
echo "Done! Open Zen Browser to verify the restore."
