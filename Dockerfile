FROM nginx:alpine

# Copy Site
COPY ./src /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose HTTP port
EXPOSE 80

# Run NGINX
CMD ["nginx", "-g", "daemon off;"]
