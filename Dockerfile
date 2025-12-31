FROM nginx:alpine

# Install Certbot and OpenSSL
RUN apk add --no-cache certbot certbot-nginx openssl

# Copy Site
COPY ./src /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy Entrypoint directly into the image to avoid CRLF issues
RUN cat <<EOF > /docker-entrypoint.sh
#!/bin/sh

# Function to generate self-signed certs
generate_self_signed() {
    echo "Generating self-signed certificate for fallback..."
    mkdir -p /etc/letsencrypt/live/voltixio.com
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \\
        -keyout /etc/letsencrypt/live/voltixio.com/privkey.pem \\
        -out /etc/letsencrypt/live/voltixio.com/fullchain.pem \\
        -subj "/C=US/ST=State/L=City/O=VoltixIO/CN=voltixio.com"
}

# Check if certificates exist
if [ ! -f /etc/letsencrypt/live/voltixio.com/fullchain.pem ]; then
    echo "No certificates found. Attempting to request from Let's Encrypt..."
    
    # Start Nginx in background for validation
    nginx
    
    # Request Certs
    if certbot certonly --webroot --webroot-path=/usr/share/nginx/html \\
      --email voltixioai@gmail.com --agree-tos --no-eff-email \\
      -d voltixio.com -d www.voltixio.com; then
        echo "Certificates successfully obtained."
    else
        echo "Certbot failed (DNS problem or running on localhost)."
        generate_self_signed
    fi
      
    # Stop temp Nginx
    nginx -s stop
fi

# Ensure files exist before starting main NGINX (double check)
if [ ! -f /etc/letsencrypt/live/voltixio.com/fullchain.pem ]; then
    generate_self_signed
fi

# Auto-renew in background
crond
echo "0 0,12 * * * certbot renew --quiet --deploy-hook 'nginx -s reload'" | crontab -

# Start NGINX in foreground
echo "Starting NGINX..."
exec nginx -g "daemon off;"
EOF

RUN chmod +x /docker-entrypoint.sh

# Debug: Check shebang
RUN head -n 1 /docker-entrypoint.sh

# Expose HTTP and HTTPS
EXPOSE 80 443

# Persist Certificates (so you don't hit limits on rebuild)
VOLUME /etc/letsencrypt

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
