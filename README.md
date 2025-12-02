# 🚀 br - Interactive Script Picker

A zsh function that provides a beautiful, interactive way to browse and run npm/bun scripts in monorepos.

![Demo](https://img.shields.io/badge/shell-zsh-green) ![License](https://img.shields.io/badge/license-MIT-blue)

<p align="center">
  <img src="br-demo.gif" alt="br demo gif" width="600">
</p>

## ✨ Features

- 📦 **Monorepo-aware** - Discovers all `package.json` files in your project
- 🔍 **Fuzzy search** - Find packages and scripts instantly with fzf
- ✏️ **Edit before run** - Press `Tab` to modify the command before executing
- 📜 **History integration** - Commands are added to shell history for easy recall
- 🔙 **Navigate back** - Return to package selection in multi-package repos
- ⚡ **Bun-first** - Uses `bun run` for blazing-fast script execution

## 📋 Prerequisites

Install the required dependencies:

```bash
brew install fd jq fzf
```

| Tool                                   | Purpose          |
| -------------------------------------- | ---------------- |
| [fd](https://github.com/sharkdp/fd)    | Fast file finder |
| [jq](https://github.com/stedolan/jq)   | JSON processor   |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder     |

## 📥 Installation

### One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/pitops/br/main/br.zsh >> ~/.zshrc && source ~/.zshrc
```

### Manual installation

1. Download the script:

```bash
curl -fsSL https://raw.githubusercontent.com/pitops/br/main/br.zsh -o ~/.br.zsh
```

2. Add to your `~/.zshrc`:

```bash
echo 'source ~/.br.zsh' >> ~/.zshrc
```

3. Reload your shell:

```bash
source ~/.zshrc
```

### Using a plugin manager

<details>
<summary>zinit</summary>

```bash
zinit light pitops/br
```

</details>

<details>
<summary>antigen</summary>

```bash
antigen bundle pitops/br
```

</details>

<details>
<summary>oh-my-zsh</summary>

Clone to custom plugins:

```bash
git clone https://github.com/pitops/br.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/br
```

Add to plugins in `~/.zshrc`:

```bash
plugins=(... br)
```

</details>

## 🎮 Usage

Navigate to any JavaScript/TypeScript project and run:

```bash
br
```

### Controls

| Key              | Action                      |
| ---------------- | --------------------------- |
| `↑` `↓`          | Navigate scripts            |
| `Enter`          | Run selected script         |
| `Tab`            | Edit command before running |
| `Esc` / `Ctrl+C` | Cancel                      |

### Example workflow

```
$ cd my-monorepo
$ br

# 1. Select package (if multiple)
Select package › apps/web/package.json

# 2. Pick a script
Select script (Enter=run, Tab=edit) › dev

# 3. Script runs!
📦 Project: apps/web
🚀 Running: bun run dev
```

## ⚙️ Configuration

### Use npm/yarn/pnpm instead of bun

Edit the `cmd` variable in the function:

```bash
# Change this line:
local cmd="bun run $script_name"

# To:
local cmd="npm run $script_name"
# or
local cmd="yarn $script_name"
# or
local cmd="pnpm run $script_name"
```

### Exclude additional directories

Add more `--exclude` flags to the `fd` command:

```bash
packages=$(fd package.json --type f \
  --exclude node_modules --exclude dist --exclude build \
  --exclude .git --exclude coverage --exclude .turbo --exclude out \
  --exclude your-custom-folder)
```

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit PRs.

## 📄 License

MIT © [pitops](https://github.com/pitops)
