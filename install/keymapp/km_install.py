import subprocess

def install_keymapp():
    subprocess.run(["sudo", "mkdir", "/usr/share/applications/keymapp/"])
    subprocess.run(["sudo", "curl", "https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.tar.gz", "-o", "/usr/share/applications/keymapp/keymapp.tar.gz"])
    subprocess.run(["sudo", "tar", "-xvzf", "/usr/share/applications/keymapp/keymapp.tar.gz"])
    subprocess.run(["sudo", "chmod", "+x", "/usr/share/applications/keymapp/keymapp"])
    subprocess.run(["sudo", "mv", "/usr/share/applications/keymapp/keymapp", "/usr/local/bin/"])
    subprocess.run(["sudo", "rm", "/usr/share/applications/keymapp/keymapp.tar.gz"])
    subprocess.run(["sudo", "cp", "./keymapp/50-zsa.rules", "/etc/udev/rules.d/50-zsa.rules"])
    subprocess.run(["sudo", "cp", "./keymapp/keymapp.desktop", "/usr/share/applications/keymapp/keymapp.desktop"])
    subprocess.run(["sudo", "groupadd", "plugdev"])
    subprocess.run(["sudo", "usermod", "-aG", "plugdev", "$USER"])
