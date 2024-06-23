# Use the official Arch Linux base image
FROM archlinux:latest

# Set the correct permissions and initialize the pacman key
RUN chmod 755 /usr/share/polkit-1/rules.d && \
    pacman-key --init && \
    pacman-key --populate archlinux

# Set permissions for /srv/ftp
RUN mkdir -p /srv/ftp && chmod 555 /srv/ftp

# System update and installation of necessary packages
RUN pacman -Syu --noconfirm

RUN pacman -S --noconfirm \
    base-devel \
    git \
    wget \
    sudo

# Create a new user named builder and add it to the sudoers file
RUN useradd -m builder && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to the new user and set the working directory to their home directory
USER builder
WORKDIR /home/builder

# Use build.sh as CMD
CMD ["/home/builder/build.sh"]
