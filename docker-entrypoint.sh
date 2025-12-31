#!/bin/sh

# If certificates don't exist, request them
if [ ! -f /etc/letsencrypt/live/voltixio.com/fullchain.pem ]; then
    echo "Requesting new SSL certificate..."
    # Start Nginx in background for validation
    nginx
    
    # Request Cert (Mode: webroot)
    certbot certonly --webroot --webroot-path=/usr/share/nginx/html \
      --email voltixioai@gmail.com --agree-tos --no-eff-email \
      -d voltixio.com -d www.voltixio.com
      
    # Stop Nginx so we can restart it with full config
    nginx -s stop
fi

# Auto-renew in background
crond
echo "0 0,12 * * * certbot renew --quiet --deploy-hook 'nginx -s reload'" | crontab -

# Start NGINX in foreground
echo "Starting NGINX..."
exec nginx -g "daemon off;"
