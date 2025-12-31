FROM nginx:alpine

# Install Certbot and OpenSSL
RUN apk add --no-cache certbot certbot-nginx openssl

# Copy Site
COPY ./src /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy Entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Fix line endings (CRLF -> LF) using sed (more robust)
RUN sed -i 's/\r$//' /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Debug: Check shebang
RUN head -n 1 /docker-entrypoint.sh

# Expose HTTP and HTTPS
EXPOSE 80 443

# Persist Certificates (so you don't hit limits on rebuild)
VOLUME /etc/letsencrypt

ENTRYPOINT ["/docker-entrypoint.sh"]
