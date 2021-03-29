#
FROM centos:7

# Enable systemd on Centos: needed by nfs
#ENV container docker
#RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
#systemd-tmpfiles-setup.service ] || rm -f $i; done); \
#rm -f /lib/systemd/system/multi-user.target.wants/*;\
#rm -f /etc/systemd/system/*.wants/*;\
#rm -f /lib/systemd/system/local-fs.target.wants/*; \
#rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
#rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
#rm -f /lib/systemd/system/basic.target.wants/*;\
#rm -f /lib/systemd/system/anaconda.target.wants/*;
#VOLUME [ "/sys/fs/cgroup" ]
#CMD ["/usr/sbin/init"]

#
WORKDIR /root

#
ENV SLURM_VERSION=19.05.4 \
	MUNGE_UID=981 \
	SLURM_UID=982

#
RUN yum update -y \
	&& yum install -y openssh openssh-server openssh-clients wget sudo bind-utils

# Criação do user supim-davs
RUN useradd -m -d /home/supim-davs supim-davs

# Copy SSH keys
COPY ssh/* /root/.ssh/
COPY ssh/* /home/supim-davs/.ssh/

# Passwordless SSH
RUN mkdir -p /var/run/sshd \
	&& ssh-keygen -A \
#	&& ssh-keygen -f /root/.ssh/id_rsa -t rsa -N '' \
#	&& cp .ssh/id_rsa.pub .ssh/authorized_keys \
#	&& chmod 600 .ssh/authorized_keys \
	&& sed -i '/StrictHostKeyChecking/s/ask/no/' /etc/ssh/ssh_config \
	&& sed -i '/StrictHostKeyChecking/s/#   //' /etc/ssh/ssh_config

# Criação de usuários
RUN export MUNGE_UID=991 && groupadd -g $MUNGE_UID munge \
	&& useradd -m -c "MUNGE Uid N Gid Emporium" -d /var/lib/munge -u $MUNGE_UID -g munge -s /sbin/nologin munge \
	&& export SLURM_UID=992 && groupadd -g $SLURM_UID slurm \
	&& useradd -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURM_UID -g slurm -s /bin/bash slurm

# Instalação do EPEL
RUN yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y

# Instalação do MUNGE
RUN yum install munge munge-libs munge-devel -y

# Instalação do NFS
RUN yum install nfs4-acl-tools.x86_64 nfs-utils-lib.x86_64 nfs-utils.x86_64 -y

# Instalação de componentes para o SLURM
RUN yum install openssl openssl-devel pam-devel numactl numactl-devel hwloc hwloc-devel lua lua-devel gcc g++ readline-devel rrdtool-devel ncurses-devel man2html libibmad libibumad perl-ExtUtils-MakeMaker perl-Switch -y

# Instalação do banco de dados
RUN yum install mariadb-server mariadb-devel -y

# Instalação do SLURM
RUN wget https://download.schedmd.com/slurm/slurm-$SLURM_VERSION.tar.bz2 \
	&& yum install rpm-build -y \
	&& rpmbuild -ta slurm-$SLURM_VERSION.tar.bz2 \
	&& tar -jxvf slurm-$SLURM_VERSION.tar.bz2 \
	&& cd slurm-$SLURM_VERSION \
	&& ./configure && make && make check && make install && make installcheck

# Instalação dos RPMs
RUN cd /root/rpmbuild/RPMS/x86_64 \
	&& rpm --install slurm-*

#
EXPOSE 22 6817 6818

#
COPY slurm_test.job /root

# Remoção de arquivos
RUN rm -rf rpmbuild slurm-19.05.4 slurm-19.05.4.tar.bz2

# Criação dos diretorios necessarios para rodar o SUPIM-DAVS
#SUPIM-DAVS
#	|
#	|- install
#	|  	|- AssimilationData
#	|	|- Compiler
#	|	|- DAVS
#	|	|- email
#	|	|- GenerateDAVSInput
#	|	|- GenerateSUPIMInput
#	|	|- GrADS
#	|	|- SOLAR2K
#	|	|- SUPIM_CE_WO7
#	|
#	|- runs
#	|	|- Globe
#	|	|- SouthAmerica

#RUN mkdir /home/supim-davs/SUPIM-DAVS

#RUN mkdir /home/supim-davs/SUPIM-DAVS/install
#RUN mkdir /home/supim-davs/SUPIM-DAVS/install/AssimilationData
#RUN mkdir /home/supim-davs/SUPIM-DAVS/install/Compiler
#RUN mkdir /home/supim-davs/SUPIM-DAVS/install/DAVS
#RUN mkdir /home/supim-davs/SUPIM-DAVS/install/email
#RUN mkdir /home/supim-davs/SUPIM-DAVS/install/GenerateDAVSInput
#RUN mkdir /home/supim-davs/SUPIM-DAVS/install/GenerateSUPIMInput
#RUN mkdir /home/supim-davs/SUPIM-DAVS/install/GrADS
#RUN mkdir /home/supim-davs/SUPIM-DAVS/install/SOLAR2K
#RUN mkdir /home/supim-davs/SUPIM-DAVS/install/SUPIM_CE_WO7
#
#RUN mkdir /home/supim-davs/SUPIM-DAVS/runs
#RUN mkdir /home/supim-davs/SUPIM-DAVS/runs/Globe
#RUN mkdir /home/supim-davs/SUPIM-DAVS/runs/SouthAmerica
#
# Pacote NFS 
#RUN yum install nfs4-acl-tools.x86_64 nfs-utils-lib.x86_64 nfs-utils.x86_64 -y

# Intalação de Programas para suporte

#G++, C++ e gFortran  (todos os nodes)
RUN yum groupinstall "Development Tools" -y

#JAVA (todos nodes)
RUN yum install java-devel -y

#Nmap (todos os nodes)
RUN yum install nmap -y

# Install grads
RUN yum install grads -y

# Install wget to download libcurl
RUN yum install wget -y

# Install tar to descompact libcurl 
RUN yum install tar -y

# Install libcurl
RUN wget https://curl.se/download/archeology/curl-7.22.0.tar.gz
RUN tar -xzf curl-7.22.0.tar.gz
WORKDIR /root/curl-7.22.0
RUN make
RUN make install
WORKDIR /root

# Install NFS
#RUN yum install nfs4-acl-tools.x86_64  nfs-utils-lib.x86_64 nfs-utils  -y
#RUN yum install portmap -y
