# Tools

| Tool | Description |
|------|-------------|
| [rename-recursive](#rename-recursive) | Recursively rename files and folders by replacing text in their names |

## Setup

Example with `rename-recursive` (same steps for any tool):

```zsh
mkdir -p ~/.local/bin
install -m 755 rename-recursive.sh ~/.local/bin/rename-recursive
```

Add to `~/.zshrc` (if not already there), then reload:

```zsh
export PATH="$HOME/.local/bin:$PATH"
```

```zsh
source ~/.zshrc
```

Run it from anywhere. For example:
 
```zsh
rename-recursive output attack defend
```

---

## rename-recursive

```zsh
rename-recursive [-n] <directory> <from> <to>
```

```zsh
rename-recursive output attack defend      # rename
rename-recursive -n output attack defend   # dry run (preview only)
```

- Case-sensitive.
- Replaces every occurrence in a name.
- Skips an item if the new name already exists.
