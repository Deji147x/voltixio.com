FROM nginx:alpine

# Copy static site into NGINX default public directory
COPY ./src /usr/share/nginx/html

# Expose HTTP port
EXPOSE 80

# Run NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]
