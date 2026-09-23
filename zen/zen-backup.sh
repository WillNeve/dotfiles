#!/bin/bash
#
# Zen Browser Backup Script
# Backs up critical profile files and exports pinned tabs
#
# Usage: ~/.local/bin/zen-backup.sh
#

set -e

# Configuration
PROFILE_DIR="$HOME/Library/Application Support/zen/Profiles/r71jffxr.Default (release)"
BACKUP_BASE="$HOME/.zen-backups"
LOG_FILE="$BACKUP_BASE/backup.log"
DAYS_TO_KEEP=7

# Create backup directory with timestamp
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="$BACKUP_BASE/$TIMESTAMP"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Ensure backup base directory exists
mkdir -p "$BACKUP_BASE"

log "Starting Zen Browser backup..."

# Check if profile exists
if [ ! -d "$PROFILE_DIR" ]; then
    log "ERROR: Profile directory not found: $PROFILE_DIR"
    exit 1
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup critical files
log "Backing up critical files..."

# For SQLite databases, copy the db + WAL + SHM files for consistency
# Then use sqlite3 to create a clean consolidated backup
for db in "places.sqlite" "key4.db" "cert9.db"; do
    if [ -f "$PROFILE_DIR/$db" ]; then
        # Copy all related files (db, wal, shm)
        cp "$PROFILE_DIR/$db" "$BACKUP_DIR/" 2>/dev/null
        [ -f "$PROFILE_DIR/$db-wal" ] && cp "$PROFILE_DIR/$db-wal" "$BACKUP_DIR/" 2>/dev/null
        [ -f "$PROFILE_DIR/$db-shm" ] && cp "$PROFILE_DIR/$db-shm" "$BACKUP_DIR/" 2>/dev/null
        
        # Now consolidate the WAL into the main db file (makes it self-contained)
        sqlite3 "$BACKUP_DIR/$db" "VACUUM;" 2>/dev/null
        
        # Remove WAL/SHM files from backup (now consolidated)
        rm -f "$BACKUP_DIR/$db-wal" "$BACKUP_DIR/$db-shm" 2>/dev/null
        
        log "  Backed up (sqlite+wal): $db"
    fi
done

# Copy non-database files normally
for file in "zen-sessions.jsonlz4" "prefs.js" "logins.json" "containers.json"; do
    if [ -f "$PROFILE_DIR/$file" ]; then
        cp "$PROFILE_DIR/$file" "$BACKUP_DIR/"
        log "  Copied: $file"
    fi
done

# Backup extensions list (not full extensions to save space)
if [ -f "$PROFILE_DIR/extensions.json" ]; then
    cp "$PROFILE_DIR/extensions.json" "$BACKUP_DIR/"
    log "  Copied: extensions.json"
fi

# Export pinned tabs and folders to JSON using Python
log "Exporting pinned tabs and folders..."
export BACKUP_DIR="$BACKUP_DIR"
python3 << 'PYTHON_SCRIPT'
import sqlite3
import json
import os
from datetime import datetime

backup_dir = os.environ.get('BACKUP_DIR', '/tmp')

# Use the backup copy we just made (guaranteed consistent)
db_path = os.path.join(backup_dir, "places.sqlite")

if not os.path.exists(db_path):
    print("Warning: No places.sqlite backup found, skipping JSON export")
    exit(0)

try:
    # Connect to our backup copy (no locking issues)
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Get workspaces
    cursor.execute("SELECT uuid, name, icon, container_id, position FROM zen_workspaces")
    workspaces = {}
    for row in cursor.fetchall():
        uuid, name, icon, container_id, position = row
        workspaces[uuid] = {
            'name': name,
            'icon': icon,
            'container_id': container_id,
            'position': position
        }
    
    # Get all pins including folder metadata
    cursor.execute("""
        SELECT uuid, title, url, container_id, workspace_uuid, position, 
               is_essential, is_group, folder_parent_uuid, folder_icon, is_folder_collapsed
        FROM zen_pins 
        ORDER BY workspace_uuid, position
    """)
    
    folders = []
    pins = []
    
    for row in cursor.fetchall():
        uuid, title, url, container_id, workspace_uuid, position, is_essential, is_group, folder_parent, folder_icon, folder_collapsed = row
        
        item = {
            'uuid': uuid,
            'title': title,
            'url': url,
            'container_id': container_id,
            'workspace_name': workspaces.get(workspace_uuid, {}).get('name', 'Unknown'),
            'workspace_uuid': workspace_uuid,
            'position': position,
            'is_essential': bool(is_essential),
            'folder_parent_uuid': folder_parent
        }
        
        if is_group:
            # This is a folder
            item['folder_icon'] = folder_icon
            item['is_collapsed'] = bool(folder_collapsed)
            folders.append(item)
        else:
            pins.append(item)
    
    conn.close()
    
    # Organize pins by folder for readable export
    organized = {
        'by_workspace': {}
    }
    
    for ws_uuid, ws_info in workspaces.items():
        ws_name = ws_info['name']
        ws_folders = [f for f in folders if f['workspace_uuid'] == ws_uuid]
        ws_pins = [p for p in pins if p['workspace_uuid'] == ws_uuid]
        
        organized['by_workspace'][ws_name] = {
            'workspace_uuid': ws_uuid,
            'folders': [],
            'root_pins': []  # pins not in any folder
        }
        
        # Add folders with their children
        for folder in ws_folders:
            folder_pins = [p for p in ws_pins if p['folder_parent_uuid'] == folder['uuid']]
            organized['by_workspace'][ws_name]['folders'].append({
                'name': folder['title'],
                'uuid': folder['uuid'],
                'icon': folder['folder_icon'],
                'collapsed': folder.get('is_collapsed', False),
                'pins': [{'title': p['title'], 'url': p['url']} for p in folder_pins]
            })
        
        # Add root-level pins (not in any folder)
        folder_uuids = [f['uuid'] for f in ws_folders]
        root_pins = [p for p in ws_pins if p['folder_parent_uuid'] not in folder_uuids and not p['folder_parent_uuid']]
        organized['by_workspace'][ws_name]['root_pins'] = [
            {'title': p['title'], 'url': p['url'], 'is_essential': p['is_essential']} 
            for p in root_pins
        ]
    
    # Write detailed export
    export_path = os.path.join(backup_dir, "pinned-tabs-export.json")
    with open(export_path, 'w') as f:
        json.dump({
            'exported_at': datetime.now().isoformat(),
            'summary': {
                'total_pins': len(pins),
                'total_folders': len(folders),
                'workspaces': list(workspaces.keys())
            },
            'organized': organized,
            'raw_data': {
                'workspaces': workspaces,
                'folders': folders,
                'pins': pins
            }
        }, f, indent=2)
    
    print(f"Exported {len(pins)} pins and {len(folders)} folders")
    
    # Also create a simple readable text version
    txt_path = os.path.join(backup_dir, "pinned-tabs-readable.txt")
    with open(txt_path, 'w') as f:
        f.write(f"Zen Browser Pinned Tabs Backup\n")
        f.write(f"Exported: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"{'='*60}\n\n")
        
        for ws_name, ws_data in organized['by_workspace'].items():
            f.write(f"\n## {ws_name}\n")
            f.write(f"{'-'*40}\n")
            
            # Root pins first
            if ws_data['root_pins']:
                for p in ws_data['root_pins']:
                    essential = " [Essential]" if p.get('is_essential') else ""
                    f.write(f"  {p['title']}{essential}\n")
                    f.write(f"    {p['url']}\n")
            
            # Then folders
            for folder in ws_data['folders']:
                f.write(f"\n  [{folder['name']}] ({len(folder['pins'])} pins)\n")
                for p in folder['pins']:
                    f.write(f"    - {p['title']}\n")
                    f.write(f"      {p['url']}\n")
        
        f.write(f"\n{'='*60}\n")
        f.write(f"Total: {len(pins)} pins in {len(folders)} folders\n")
    
    print(f"Created readable backup at {txt_path}")

except sqlite3.OperationalError as e:
    print(f"Warning: Could not export pins (database may be locked): {e}")
except Exception as e:
    import traceback
    print(f"Error exporting pins: {e}")
    traceback.print_exc()
PYTHON_SCRIPT

log "Pinned tabs and folders exported"

# Create a "latest" symlink
rm -f "$BACKUP_BASE/latest"
ln -s "$BACKUP_DIR" "$BACKUP_BASE/latest"
log "Updated 'latest' symlink"

# Cleanup old backups
log "Cleaning up backups older than $DAYS_TO_KEEP days..."
find "$BACKUP_BASE" -maxdepth 1 -type d -name "20*" -mtime +$DAYS_TO_KEEP -exec rm -rf {} \; 2>/dev/null || true

# Count remaining backups
BACKUP_COUNT=$(find "$BACKUP_BASE" -maxdepth 1 -type d -name "20*" | wc -l | tr -d ' ')
log "Backup complete. Total backups: $BACKUP_COUNT"

log "Backup saved to: $BACKUP_DIR"
log "---"
