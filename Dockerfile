FROM ubuntu:20.04

RUN apt update && \
    apt upgrade -y && \
    apt install wget unzip -y && \
    mkdir -p /usr/bin/watcom

COPY docker/owsetenv.sh /usr/bin/watcom/owsetenv.sh

RUN chmod 755 -R /usr/bin/watcom && \
    useradd -m div && \
    chown div /usr/bin/watcom

USER div
WORKDIR /home/div
VOLUME ["/home/div/DIV"]

RUN wget 'https://downloads.sourceforge.net/project/openwatcom/open-watcom-1.9/open-watcom-c-linux-1.9' -O 'open-watcom-1.9' && \
    unzip -o 'open-watcom-1.9' -d /usr/bin/watcom && \
    rm 'open-watcom-1.9' && \
    chmod +x /usr/bin/watcom/binl/* 

# Register Open Watcom Environment
RUN echo 'source /usr/bin/watcom/owsetenv.sh' >> /home/div/.bashrc && . /usr/bin/watcom/owsetenv.sh

CMD /bin/bash -c 'source /usr/bin/watcom/owsetenv.sh && cd DIV && wmake' 
