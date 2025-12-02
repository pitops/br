#!/usr/bin/env zsh
# --------------------------------------------------------
# 🚀 br - Interactive script picker for monorepos
# https://github.com/pitops/br
# --------------------------------------------------------

br() {
  # ---- Dependencies ----
  for cmd in fd jq fzf; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "⚠️ Missing dependency: $cmd (install with 'brew install $cmd')"
      return 1
    fi
  done

  # ---- Main Loop ----
  while true; do
    # 1️⃣ Find all package.json files in current folder/repo
    local packages
    packages=$(fd package.json --type f \
      --exclude node_modules --exclude dist --exclude build \
      --exclude .git --exclude coverage --exclude .turbo --exclude out)

    if [[ -z "$packages" ]]; then
      echo "❌ No package.json files found in this repo."
      return 1
    fi

    local chosen_pkg
    # 2️⃣ Optimization: if only one package.json, skip folder selection
    if [[ $(echo "$packages" | wc -l) -eq 1 ]]; then
      chosen_pkg="$packages"
    else
      chosen_pkg=$(echo "$packages" | fzf \
        --prompt="Select package › " \
        --height=40% --reverse --border \
        --preview="jq -r '.name // \"(no name)\"' {}" \
        --preview-window=up:1:wrap) || return
    fi

    local folder
    folder=$(dirname "$chosen_pkg")

    # 3️⃣ Parse scripts
    local scripts
    scripts=$(jq -r '.scripts | to_entries[] | "\(.key)\t\(.value)"' "$chosen_pkg" 2>/dev/null)
    [[ -z "$scripts" ]] && continue

    # 4️⃣ Add Back option only if multiple packages
    if [[ $(echo "$packages" | wc -l) -gt 1 ]]; then
      scripts="🔙 Back\tReturn to folder selection\n$scripts"
    fi

    # 5️⃣ Script picker (Tab to edit, Enter to run)
    local selected
    selected=$(echo "$scripts" | column -t -s $'\t' | fzf \
      --prompt="Select script (Enter=run, Tab=edit) › " \
      --height=40% --reverse --border --ansi \
      --expect=tab) || return

    # Parse fzf output: first line is the key pressed, second is the selection
    local key_pressed selection
    key_pressed=$(echo "$selected" | head -1)
    selection=$(echo "$selected" | tail -1)

    local script_name
    script_name=$(echo "$selection" | awk '{print $1}')

    # 6️⃣ Handle back navigation
    if [[ "$script_name" == "🔙" || "$script_name" == "Back" ]]; then
      continue
    fi

    # 7️⃣ Build command
    local cmd="bun run $script_name"
    echo "📦 Project: $folder"

    # If Tab was pressed, allow editing
    if [[ "$key_pressed" == "tab" ]]; then
      echo "✏️  Edit command (Enter to run, Ctrl+C to cancel):"
      vared -p "🚀 " cmd || return
    else
      echo "🚀 Running: $cmd"
    fi

    # 8️⃣ Add to history so UP arrow shows this command
    if [[ "$folder" == "." ]]; then
      print -s "$cmd"
    else
      print -s "cd $folder && $cmd"
    fi

    echo "----------------------------------------"
    (cd "$folder" && eval "$cmd")
    return
  done
}

