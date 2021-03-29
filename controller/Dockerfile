#
FROM slurm-swarm-base:19.05.4
#
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY start_NFS_server.sh /start_NFS_server.sh
#
#CMD ["/bin/bash", "/start_NFS_server.sh", "&&","/bin/bash", "/docker-entrypoint.sh"]
CMD ["/bin/bash", "/docker-entrypoint.sh"]
