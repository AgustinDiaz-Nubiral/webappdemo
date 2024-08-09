#FROM nginx:latest

# Usa una imagen base que contenga nginx
FROM nginx:alpine

# Instala git para clonar el repositorio
RUN apk add --no-cache git

# Verifica los permisos del directorio de destino
RUN ls -ld /usr/share/nginx/html

# Ajusta los permisos si es necesario
RUN chmod -R 755 /usr/share/nginx/html

# Clona el repositorio
RUN git clone https://github.com/AgustinDiaz-Nubiral/webappdemo.git

COPY ./webappdemo/src/coffee-shop-html-template /usr/share/nginx/html/my-static-app

# Comando para iniciar nginx
CMD ["nginx", "-g", "daemon off;"]
