FROM ubuntu:14.04
MAINTAINER Sean Van Osselaer <svo@qual.is>

ADD dpkg_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc
ADD dpkg_nolocales /etc/dpkg/dpkg.cfg.d/01_nolocales
ADD apt_nocache /etc/apt/apt.conf.d/02_nocache
ADD remove_doc /usr/local/bin/remove_doc

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d && \
    apt-get update && \
    apt-get install supervisor -y && \
    apt-get install software-properties-common -y && \
    apt-add-repository ppa:ansible/ansible -y && \
    apt-get update && \
    apt-get install ansible -y && \
    echo "localhost ansible_connection=local" | tee /etc/ansible/hosts && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    apt-get clean -y && \
    /usr/local/bin/remove_doc && \
    rm /usr/local/bin/remove_doc

ADD supervisor.conf /etc/supervisor.conf

CMD ["supervisord", "-n", "-c", "/etc/supervisor.conf"]
