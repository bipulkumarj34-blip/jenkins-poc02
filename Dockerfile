# Use the stable Nginx Alpine image for a small footprint
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80