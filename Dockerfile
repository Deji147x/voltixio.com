FROM nginx:alpine

# Install Certbot, OpenSSL, and dos2unix (to fix line endings)
RUN apk add --no-cache certbot certbot-nginx openssl dos2unix

# Copy Site
COPY ./src /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy Entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
# Fix line endings (CRLF -> LF)
RUN dos2unix /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose HTTP and HTTPS
EXPOSE 80 443

# Persist Certificates (so you don't hit limits on rebuild)
VOLUME /etc/letsencrypt

ENTRYPOINT ["/docker-entrypoint.sh"]
