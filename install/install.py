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
 
# install_keymapp()
# install_zen()
