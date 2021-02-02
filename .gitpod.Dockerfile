FROM gitpod/workspace-full

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/
# Update all packages per normal
RUN sudo apt update && \
    sudo apt upgrade -y

# Install prereqs
RUN sudo apt install -y git dnsmasq hostapd bc build-essential dkms

# DKMS as above
RUN VER=$(sed -n 's/\PACKAGE_VERSION="\(.*\)"/\1/p' dkms.conf)
RUN sudo rsync -rvhP ./ /usr/src/rtl88x2bu-${VER}
RUN sudo dkms add -m rtl88x2bu -v ${VER}
RUN sudo dkms build -m rtl88x2bu -v ${VER} # Takes ~3-minutes on a 3B+
RUN sudo dkms install -m rtl88x2bu -v ${VER}
