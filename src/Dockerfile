########FROM nginx:latest

# Usa una imagen base de Nginx
FROM nginx:latest

# Copia los archivos del repositorio al contenedor
# El directorio /usr/share/nginx/html/ es el directorio por defecto para los archivos estáticos en Nginx
COPY ./coffee-shop-html-template /usr/share/nginx/html/sitio

# Expone el puerto 80
EXPOSE 80
EXPOSE 8080

# Comando por defecto para ejecutar Nginx en el contenedor
CMD ["nginx", "-g", "daemon off;"]

