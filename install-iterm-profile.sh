echo "Creating a folder for iTerm2 dynamic profiles: /Library/Application Support/iTerm2/DynamicProfiles"
echo "This requires sudo priviliges, you'll be prompted for a password"
# Copy iterm2 dynamic profile to the destination folder
[ -d "/Library/Application Support/iTerm2/DynamicProfiles/" ] || sudo mkdir -p "/Library/Application Support/iTerm2/DynamicProfiles/"
sudo cp ./iterm2/default-profile.json "/Library/Application Support/iTerm2/DynamicProfiles/default-profile.json"
