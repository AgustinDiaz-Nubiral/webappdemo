#FROM nginx:latest

#COPY ./coffee-shop-html-template /usr/share/nginx/html/webappdemo

# Usa una imagen base que contenga nginx
FROM nginx:alpine

# Instala git para clonar el repositorio
RUN apk add --no-cache git

# Clona el repositorio
RUN git clone https://github.com/AgustinDiaz-Nubiral/webappdemo.git /usr/share/nginx/html

# Copia la configuración de nginx (si es necesario)
# COPY nginx.conf /etc/nginx/nginx.conf

# Comando para iniciar nginx
CMD ["nginx", "-g", "daemon off;"]
