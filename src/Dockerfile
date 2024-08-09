#FROM nginx:latest

#COPY ./coffee-shop-html-template /usr/share/nginx/html/webappdemo


# Usa la imagen base oficial de Nginx
FROM nginx:latest

# Instala git para clonar el repositorio
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Establece el directorio de trabajo en /app
WORKDIR /src

# Clona el repositorio de GitHub
RUN git clone https://github.com/AgustinDiaz-Nubiral/webappdemo

# Copia los archivos de la aplicación al directorio donde Nginx los servirá
# En este caso, el directorio por defecto de Nginx es /usr/share/nginx/html
RUN cp -r /coffee-shop-html-template/* /usr/share/nginx/html/

