- Fix emoji display

  ```bash
  sudo cp 75-noto-color-emoji.conf /usr/share/fontconfig/conf.avail && \
  sudo ln -s /usr/share/fontconfig/conf.avail/75-noto-color-emoji.conf /etc/fonts/conf.d/75-noto-color-emoji.conf
  ```

- Install zsh

  ```bash
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
  git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
  git clone https://github.com/romkatv/powerlevel10k ~/.oh-my-zsh/custom/themes/powerlevel10k && \
  cp .oh-my-zsh/zsh-syntax-highlighting.zsh ~/.oh-my-zsh/
  ```
