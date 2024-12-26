FROM debian
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y && apt install -y && apt install net-tools -y \
    ssh wget unzip vim curl python3
RUN wget -q https://s3.ap-south-1.amazonaws.com/public.pinggy.binaries/cli/v0.1.4/linux/amd64/pinggy -O /pinggy\
    && cd / \
    && chmod +x pinggy
RUN mkdir /run/sshd \
    && echo "/pinggy -p 443 -R0:localhost:22 -o StrictHostKeyChecking=no -o ServerAliveInterval=30 qCHQ2OkFmMp+tcp@ap.a.pinggy.io" >>/openssh.sh \
    && echo "netstat -tlop | grep LISTEN | python3 -c \"import sys, json; print(sys.stdin)\"" >> /openssh.sh \
    && echo '/usr/sbin/sshd -D' >>/openssh.sh \
    && echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config  \
    && echo root:gonxid|chpasswd \
    && chmod 755 /openssh.sh
EXPOSE 80 443 3306 4040 5432 5700 5701 5010 6800 6900 8080 8888 9000
CMD /openssh.sh
