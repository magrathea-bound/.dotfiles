from pathlib import Path
import subprocess

def grub_config():
    grub_file = Path("/etc/default/grub")

    text = grub_file.read_text()

    new_text = "\n".join(
        (
            "GRUB_TIMEOUT=15" if line.startswith("GRUB_TIMEOUT=")
            else "GRUB_DISABLE_OS_PROBER=false" if line.startswith("GRUB_DISABLE_OS_PROBER=")
            else line
        )
        for line in text.splitlines()
    )

# write via sudo using tee (no need to run whole Python as root)
    subprocess.run(
        ["sudo", "tee", "/etc/default/grub"],
        input=new_text + "\n",
        text=True,
        check=True
    )

# regenerate grub config (also needs sudo)
    subprocess.run(
        ["sudo", "grub-mkconfig", "-o", "/boot/grub/grub.cfg"],
        check=True
    )
