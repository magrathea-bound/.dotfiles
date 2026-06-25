import subprocess
from packages import packages
from grub import grub_config
from keymapp.km_install import install_keymapp
from zen import install_zen

# Packages
pkgs = ""
for pkg in packages:
    pkgs += pkg + " "

subprocess.run(["sudo", "pacman", "-Syu", pkgs])

# Home directories
dirs = "~/Documents ~/Downloads ~/Pictures ~/Projects ~/Tools"
subprocess.run(["mkdir", dirs])


subprocess.run(["ssh-keygen", "-t", "ed25519", "-C", '"dg.burns@outlook.com"'])

subprocess.run(["ssh-keygen", "-t", "ed25519", "-C", '"dg.burns@outlook.com"'])

# Link my stuff
apps = ["alacritty", "bash", "hypr", "mako", "nvim", "rofi", "tmux", "waybar"]
for app in apps:
    subprocess.run(["ln", "-s", f"~/.dotfiles/{app}", f"~/.config/{app}"])
subprocess.run(["ln", "-s", "~/.dotfiles/bash/bashrc", "~/.bashrc"])
subprocess.run(["ln", "-s", "~/.dotfiles/bash/inputrc", "~/.inputrc"])
 
install_keymapp()
install_zen()
