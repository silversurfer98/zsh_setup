# zsh_setup

This contains all my zsh-starship-plugins setup files

- install zsh
```bash
sudo apt install zsh
# exa is a modern ls
sudo apt install exa
# to update fonts
sudo apt install fontconfig
```

- change to zsh shell
```bash
chsh -s $(which zsh)
```

- Now we are ready to go for starship but _we need any nerd font_
	- download a nerd font from [link](https://www.nerdfonts.com/) (I chose fira code nerd fonts)
	- I have uploaded the fonts zip files to my cloud [fonts](https://nextcloud.silver1618.fun/s/Ls4ipSk35frgm8J)
	- extract the font to `~/.fonts`
	- then run `fc-cache -fv` to rebuild all fonts (fontconfig should be installed)

```bash
# install starship
curl -sS -k https://starship.rs/install.sh | sh
```
- if the curl is not running download from [link](https://sourceforge.net/projects/starship.mirror/files/v1.16.0/) and place it inside `/usr/local/bin`
- if working with WSL the above is not possible, we need to download musl version of starship, but why worry I have that too [download](https://nextcloud.silver1618.fun/s/Yg4rdpJyN8iPDar)
- The installation will ask to add lines `eval "$(starship init zsh)"`  to .zshrc **BUT do't need to do that as we have the files we want build up**
- copy the `starship.toml` file to `~/.config` folder, this file is the settings for starship
- copy `.zsh` folder and `.zshrc` file to `~/` i.e `$HOME` folder, **over write if needed**
- **IMPORTANT** Specify the sops age key file properly and mask the ytd settings in zsh and **change shell to zsh then source**
- Now `source ~/.zshrc` and terminal restart will magically transform your terminal

## List of installed plugins

1. [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting#installation)
2. [zsh-auto-suggestions](https://github.com/zsh-users/zsh-autosuggestions)
3. [zsh-abbr](https://github.com/olets/zsh-abbr) --> [documentation](https://zsh-abbr.olets.dev/)
4. [zsh-z](https://github.com/agkozak/zsh-z)
5. [fzf](https://github.com/junegunn/fzf)