brew install --cask nikitabobko/tap/aerospace
brew install --cask font-jetbrains-mono-nerd-font
brew install starship neovim fzf fd zsh-autosuggestions zsh-syntax-highlighting lua-language-server
#brew install --cask miniconda;

# Copy iterm2 dynamic profile to the destination folder
sudo mkdir -p "/Library/Application Support/iTerm2/DynamicProfiles/"
cp ./iterm2/default-profile.json "/Library/Application Support/iTerm2/DynamicProfiles/default-profile.json"
