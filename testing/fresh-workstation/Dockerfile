FROM fedora:36

RUN dnf install -y openssh-server
RUN useradd ansible -Nrm -G wheel -c "Ansible"
