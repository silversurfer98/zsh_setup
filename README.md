# zsh_setup

This contains all my zsh-starship-plugins setup files

- install zsh
```bash
sudo apt install zsh
# exa is a modern ls
sudo apt install exa
```

- change to zsh shell
```bash
chsh -s $(which zsh)
```

- Now we are ready to go for starship but _we need any nerd font_
	- download a nerd font from [link](https://www.nerdfonts.com/) (I chose fira code fonts)
	- extract the font to `~/.fonts`
	- then run `fc-cache -fv` to rebuild all fonts

```bash
# install starship
curl -sS https://starship.rs/install.sh | sh
```
- The installation will ask to add lines `eval "$(starship init zsh)"`  to .zshrc **BUT do't need to do that as we have the files we want build up**
- copy the `starship.toml` file to `~/.config` folder, this file is the settings for starship
- copy `.zsh` folder and `.zshrc` file to `~/` i.e `$HOME` folder, **over write if needed**
- Now `source ~/.zshrc` and terminal restart will magically transform your terminal

## List of installed plugins

1. [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting#installation)
2. [zsh-auto-suggestions](https://github.com/zsh-users/zsh-autosuggestions)
3. [zsh-abbr](https://github.com/olets/zsh-abbr) --> [documentation](https://zsh-abbr.olets.dev/)
4. [zsh-z](https://github.com/agkozak/zsh-z)
5. [fzf](https://github.com/junegunn/fzf)