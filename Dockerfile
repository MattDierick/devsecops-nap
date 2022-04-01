# syntax=docker/dockerfile:1
# For CentOS 7:
FROM centos:7.4.1708

# Install prerequisite packages:
RUN yum -y install wget ca-certificates epel-release

# Add NGINX Plus repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo

# Add NGINX App-protect repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/app-protect-7.repo

# Install NGINX App Protect WAF:
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    yum -y install app-protect \
    && yum clean all \
    && rm -rf /var/cache/yum

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files:
COPY etc/nginx/nginx.conf /etc/nginx/
COPY etc/nginx/upstream.d/ /etc/nginx/upstream.d/
COPY etc/nginx/vhosts.d/ /etc/nginx/vhosts.d/
COPY etc/nginx/nap-files/logs/custom_log_format.json /etc/nginx/nap-files/logs/
COPY etc/nginx/nap-files/policies/ /etc/nginx/nap-files/policies/

COPY entrypoint.sh /root/

CMD ["sh", "/root/entrypoint.sh"]
