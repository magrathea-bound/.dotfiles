import subprocess

def install_zen():
    subprocess.run(["sudo", "curl", "-L", "https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz", "-o", "/opt/zen.linux-x86_64.tar.xz"])
    subprocess.run(["sudo", "tar", "-xvf", "/opt/zen.linux-x86_64.tar.xz"])
    subprocess.run(["sudo", "ln", "-s", "/opt/zen/zen-bin", "/usr/local/bin/zen"])
    subprocess.run(["sudo", "rm", "/opt/zen.linux-x86_64.tar.xz"])
