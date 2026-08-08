#!/usr/bin/env bash
# macOS defaults — kept to settings that still matter on recent macOS (Apple Silicon).
# Run standalone or from bootstrap.sh: optional/legacy knobs are omitted or guarded.
set -euo pipefail

# Computer name (Sharing / hostname / NetBIOS)
_default_name="$(scutil --get ComputerName 2>/dev/null || true)"
_default_name="${_default_name:-$(scutil --get LocalHostName 2>/dev/null || true)}"
_default_name="${_default_name:-$(hostname -s 2>/dev/null || echo MacBook)}"

if [[ -n "${COMPUTER_NAME:-}" ]]; then
  _name="$COMPUTER_NAME"
else
  printf "Computer name [%s]: " "$_default_name"
  read -r _input
  _name="${_input:-$_default_name}"
fi

_host="$(printf '%s' "$_name" | tr -cs 'A-Za-z0-9-' '-' | sed 's/^-//;s/-$//')"
_host="${_host:-MacBook}"

echo "Setting computer name to: $_name (host: $_host)"
sudo scutil --set ComputerName "$_name"
sudo scutil --set HostName "$_host"
sudo scutil --set LocalHostName "$_host"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$_host"
unset _default_name _input _name _host

# Keyboard / input
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 12
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Trackpad / mouse
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write -g com.apple.trackpad.scaling 2
defaults write -g com.apple.mouse.scaling 2.5

# Screenshots
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture type -string "png"

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder WarnOnEmptyTrash -bool false
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder QuitMenuItem -bool true
chflags nohidden "$HOME/Library" || true

# Panels / docs
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Dock / Mission Control / Spaces
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock mru-spaces -bool false

# Hide desktop / Stage Manager widgets (System Settings → Desktop & Dock → Widgets)
defaults write com.apple.WindowManager StandardHideWidgets -bool true
defaults write com.apple.WindowManager StageManagerHideWidgets -bool true

# Activity Monitor
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Mail
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Time Machine
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Chrome (installed via Brewfile)
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

# Software Update check cadence
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Startup chime mute (Apple Silicon–friendly; ignore failures)
sudo nvram StartupMute=%01 2>/dev/null || true

killall Finder Dock SystemUIServer 2>/dev/null || true

echo "macOS defaults applied (log out/in or reboot if some UI settings look stale)."
