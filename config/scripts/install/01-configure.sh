#!/usr/bin/env bash

set -e

exec &> >(tee "configure.log")

print () {
    echo -e "\n\033[1m> $1\033[0m\n"
}

ask () {
    read -p "> $1 " -r
    echo
}

menu () {
    PS3="> Choose a number: "
    select i in "$@"
    do
        echo "$i"
        break
    done
}

tests () {
    ls /sys/firmware/efi/efivars > /dev/null && \
        ping voidlinux.org -c 1 > /dev/null &&  \
        modprobe zfs &&
        print "Tests ok"
}
