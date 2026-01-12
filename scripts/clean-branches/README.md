- Interactively mark and delete local git branches in bulk (w/ confirmation).

## Features

- Lists only branches that are:
  - Not protected (main, staging)
  - Not the current branch
- Interactive checkbox selection with arrow key navigation
- Type "delete" to confirm before deletion
- Shows success/failure status for each branch
- Automatically cleans zsh autocomplete history to remove deleted branches from `git co`/`git checkout` suggestions

## Usage

```bash
npm run scripts:prepare && ./scripts/public/clean-branches/main.sh
```
