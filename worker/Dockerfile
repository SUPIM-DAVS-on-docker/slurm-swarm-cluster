#
FROM slurm-swarm-base:19.05.4

#
COPY connect_to_NFS.sh /connect_to_NFS.sh

#
#CMD ["/bin/bash", "/connect_to_NFS.sh"]
#CMD ["/bin/bash", "/connect_to_NFS.sh", "&&", "/usr/sbin/sshd", "-D"]
CMD ["/usr/sbin/sshd", "-D"]
