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

- Ensure, that normal user is member of the following groups
```
wheel floppy audio video cdrom optical kvm xbuilder dbus _seatd
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