# ~/.local/share/chezmoi/scripts/install_programs.sh
#!/bin/bash
set -euo pipefail  # Exit on error, undefined variables, and pipe failures

echo "Starting program installation script..."
exec &> >(tee -a ~/.local/share/chezmoi/scripts/installation.log)

# Function to update the system
update_system() {
    echo "Updating system packages..."
    sudo pacman -Syu --noconfirm
}

# Function to install yay (AUR helper)
install_yay() {
    if ! command -v yay &>/dev/null; then
        echo "yay not found. Installing yay-bin..."
        sudo pacman -S --needed --noconfirm git base-devel
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
        (cd /tmp/yay-bin && makepkg -si --noconfirm)
        rm -rf /tmp/yay-bin
    else
        echo "yay is already installed."
    fi
}

# Function to install zsh and set it as the default shell
install_zsh() {
    if ! pacman -Qq "zsh" &>/dev/null; then
        echo "Installing zsh..."
        sudo pacman -S --needed --noconfirm zsh
    else
        echo "zsh is already installed."
    fi

    # Set zsh as the default shell
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        echo "Setting zsh as the default shell..."
        chsh -s "$(which zsh)"
        echo "You will need to log out and log back in for the change to take effect."
    else
        echo "zsh is already set as the default shell."
    fi
}

# Function to install pacman packages only if not already installed
install_pacman_packages() {
    declare -a pacman_packages=(
        "bat"
        "bluez"
        "bluez-utils"
        "brightnessctl"
        "btop"
        "clang"
        "cmake"
        "cmatrix"
        "dart-sass"
        "dkms"
        "dosfstools"
        "dunst"
        "efibootmgr"
        "eog"
        "fastfetch"
        "fd"
        "firefox"
        "flatpak"
        "fuse2"
        "fzf"
        "gimp"
        "gnome-clocks"
        "grim"
        "gst-plugin-pipewire"
        "htop"
        "hyprpaper"
        "intel-ucode"
        "iwd"
        "jdk-openjdk"
        "kdeconnect"
        "kitty"
        "lazygit"
        "libpulse"
        "libreoffice-still"
        "lsd"
        "megatools"
        "mpd"
        "mtools"
        "mupdf"
        "ncdu"
        "ncmpcpp"
        "neofetch"
        "neovim"
        "network-manager-applet"
        "networkmanager"
        "ntp"
        "nvidia"
        "nwg-displays"
        "obs-studio"
        "os-prober"
        "pacman-contrib"
        "pavucontrol"
        "pipewire"
        "pipewire-alsa"
        "pipewire-jack"
        "pipewire-pulse"
        "polkit-gnome"
        "power-profiles-daemon"
        "python-pip"
        "python-pywal"
        "qalculate-gtk"
        "qt5-wayland"
        "qt6-wayland"
        "ripgrep"
        "rust"
        "sddm"
        "slurp"
        "smartmontools"
        "sof-firmware"
        "spotify-launcher"
        "swappy"
        "swaybg"
        "swayidle"
        "thunar"
        "tldr"
        "tmux"
        "ttf-jetbrains-mono-nerd"
        "ttf-monaspace-variable"
        "unzip"
        "vala"
        "vulkan-intel"
        "waybar"
        "wget"
        "wireless-tools"
        "wireplumber"
        "xautolock"
        "xf86-video-nouveau"
        "zathura"
        "zathura-pdf-mupdf"
        "zram-generator"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
    )

    for pkg in "${pacman_packages[@]}"; do
        if ! pacman -Qq "$pkg" &>/dev/null; then
            echo "Installing pacman package: $pkg"
            sudo pacman -S --needed --noconfirm "$pkg"
        else
            echo "Pacman package already installed: $pkg"
        fi
    done
}

# Function to install AUR packages with yay only if not already installed
install_aur_packages() {
    declare -a aur_packages=(
        "ani-cli"
        "brave-bin"
        "catppuccin-gtk-theme-mocha"
        "cava"
        "cava-debug"
        "cbonsai-git"
        "cbonsai-git-debug"
        "gnome-shell-pomodoro"
        "gnome-shell-pomodoro-debug"
        "gruvbox-dark-gtk"
        "hyprpicker-git"
        "hyprpicker-git-debug"
        "hyprshot"
        "nbfc-linux-debug"
        "nvm"
        "nwg-look-bin"
        "nwg-look-bin-debug"
        "paru"
        "paru-debug"
        "pfetch"
        "rose-pine-gtk-theme-full"
        "sddm-theme-sugar-candy-git"
        "spicetify-cli"
        "spicetify-cli-debug"
        "spotify-tui-debug"
        "swaylock-effects"
        "swaylock-effects-debug"
        "swww-git-debug"
        "themix-export-spotify-git"
        "themix-gui-git"
        "themix-icons-archdroid-git"
        "themix-icons-gnome-colors-git"
        "themix-icons-numix-git"
        "themix-icons-suru-plus-aspromauros-git"
        "themix-icons-suru-plus-git"
        "themix-import-images-git"
        "themix-plugin-base16-git"
        "themix-theme-oomox-git"
        "tofi"
        "tofi-debug"
        "tty-clock"
        "tty-clock-debug"
        "visual-studio-code-bin"
        "visual-studio-code-bin-debug"
        "warp-terminal"
        "waypaper"
        "wl-clip-persist-debug"
        "visual-studio-code-bin"
    )

    for pkg in "${aur_packages[@]}"; do
        if ! yay -Qq "$pkg" &>/dev/null; then
            echo "Installing AUR package: $pkg"
            yay -S --needed --noconfirm "$pkg"
        else
            echo "AUR package already installed: $pkg"
        fi
    done
}

# Main execution flow
echo "Starting the installation process..."

update_system
install_yay
install_zsh  # Install zsh and set as default shell
install_pacman_packages
install_aur_packages

echo "Installation complete!"
