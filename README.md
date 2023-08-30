### Devops'd void dotfiles using Ansible

### Install

- Clone me
```
git clone https://github.com/bu6hunt3r
```
- Run ansible playbook and enjoy

```bash
ansible-playbook deploy.yaml --ask-become-pass
```

### Post-Installation

#### Set console font

- Check for available fonts
```
# ls /usr/share/kbd/consolefonts/ | grep 32
latarcyrheb-sun32.psfu.gz
```
- And afterthat you can set it via:
```
# setfont latarcyrheb-sun32
```
- Ensure, that normal user is member of the following groups
```
wheel floppy audio video cdrom optical kvm xbuilder dbus _seatd
```
### Initial setup via ansible

- At first you'd have to install ansible & git and clone this repo
```
# xbps-install -Su && xbps-install git ansible
# git clone https://github.com/bu6hunt3r/void-dotfiles
```

- After that, you may add the following script to `/etc/profile`:
```bash
if [ "$(tty)" = "/dev/tty1" ]; then
   while true; do
         echo -e 'start sway [y/n]: '
         read yn
         case $yn in
              [Yy]*) exec dbus-run-session sway ;;
              [Nn]*) echo "Opting out ouf sway" ; break ;;
         esac
   done
fi
```
