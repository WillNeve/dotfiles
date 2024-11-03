# ⏺️ WSL2/Ubuntu Dotfiles Setup

## 1. **Clone the repo into home directory**

```bash
git clone git@github.com:willneve/dotfiles.git ~/dotfiles
```

## 2. **Run setup script**

```bash
chmod +x ~/dotfiles/setup/setup.sh
zsh ~/dotfiles/setup/setup.sh
```

<details>
  <summary>
    If you are not me feel free to instead download the script and inspect it 👀
  </summary>
  
  <br>
  
  ```bash
  wget -O the-dotfiles-setup-script.sh https://raw.githubusercontent.com/WillNeve/dotfiles/refs/heads/main/setup/setup.sh
  echo " - - - - - -  v DOTFILES SETUP SCRIPT v - - - - - -"
  cat the-setup-script.sh
  echo " - - - - - -  ^ DOTFILES SETUP SCRIPT ^ - - - - - -"
  rm the-setup-script.sh
  ```
</details>
