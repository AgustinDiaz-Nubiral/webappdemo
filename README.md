# webappdemo

## Título y Resumen

**Título**: Despliegue de Infraestructura en Azure con Terraform y Aplicación en Web App mediante Github Actions.

**Resumen**: Este repositorio cuenta con una aplicacion estatica la cual es utilizada mediante una imagen de Docker. La imagen es pusheada a un Azure container registry para ser utilizada por App Service de Azure. El despliegue de la infraestructura en Azure se realiza mediante terraform, y la aplicacion es desplegada y aprovisionada mediante el despliegue continuo de Github Actions.

## Prerequisitos

### *Herramientas necesarias*:

**Terraform**: Para instalar terraform puede seguir los pasos en la siguiente documentación: 
[Terraform Instal](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
**Azure CLI**: Para instalar Azure CLI puede seguir los pasos en la siguiente documentación: [Azure CLI Instal](https://learn.microsoft.com/es-es/cli/azure/install-azure-cli)
**Git**: Para este proyecto se utiliza el control de versiones otorgado por Github Actions (workflows).
**Autenticación en Azure**: Para la autenticación en Azure se creo un Service Principal. La razón principal para crear un Service Principal es permitir que estas aplicaciones o servicios se autentiquen y autoricen de manera segura para realizar acciones en Azure, sin requerir la intervención directa de un usuario. 
A continuación se adjunta el link de la documentación que se utilizo para generar el Service Principal: [Service Principal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)
**Disponer de una Storage Account**: Para poder almacenar y resguardar el estado de terraform se debe contar con un storage account y un container ya desplegados.

    

## Estructura del Repositorio

El repositorio cuenta con 3 carpetas. 

 1. Infra: Contiene los archivos terraform para el despliegue de la infraestructura en Azure.
 2. Src: Contiene el Dockerfile para construir la imagen que va a ser pusheada al Azure Container Registry (ACR) y la carpeta que contiene los archivos correspondientes a la aplicacion (html, css, js, scss, etc)
 3. .github/workflows: Contiene los archivos .yml correspondientes al deploy, tanto de la app como de la infraestructura.

                /infra
                ├── main.tf
                ├── variables.tf
                ├── terraform.tfvars
                ├── providers.tf
                ├── backend.tf
                
                /app
                ├── src
	                └── coffee-shop-html-template
		                └── html
		                └── css
		                └── js
                ├── Dockerfile
                
                /.github
                └── workflows
	                └── build&deployapp.yml
	                └── deployinfra.yml
  

**maintf**: Define los recursos de Azure como la Web App, el Azure Container Registry (ACR), y cualquier otro recurso necesario.
**terraformtfvars**: Declara las variables utilizadas en la configuración de Terraform
**variabletf**: Describe cada variable utilizada en la configuracion de Terraform (terraform.tfvars).
**Dockerfile**: Configuración de Docker para construir la imagen de la aplicación.
**build&deployapp.yml/deployinfra.yml**: Workflows de GitHub Actions para automatizar el despliegue.

## Configuración de Terraform

Inicialización del Proyecto:

    terraform init

Este comando se encarga de varias tareas fundamentales para preparar tu entorno de trabajo:

1.  **Descarga de Proveedores:** `terraform init` descarga los proveedores (providers) que se necesitan para interactuar con las infraestructuras que vas a gestionar. Estos proveedores son los que Terraform utiliza para comunicarse con las diferentes plataformas de nube (como Azure, AWS, GCP, etc.).
    
2.  **Configuración del Backend:** Si estás usando un backend para almacenar el estado de Terraform (por ejemplo, en un bucket de S3 o en un storage account de Azure), `terraform init` lo configura para que el estado se almacene y gestione adecuadamente.
    
3.  **Inicialización de Módulos:** Si tu configuración de Terraform incluye módulos (códigos reutilizables que encapsulan un grupo de recursos relacionados), `terraform init` se encargará de descargarlos o de asegurarse de que están correctamente preparados para su uso.
    
4.  **Validación del Workspace:** `terraform init` verifica que el workspace (entorno de trabajo) esté correctamente configurado y listo para usar.

    

Planificación: terraform plan para revisar los cambios que se aplicarán.

    terraform plan


Aplicación: terraform apply para desplegar la infraestructura.

Incluye capturas de pantalla o ejemplos de salida de estos comandos.

Variables y Parámetros:

  

Explica las Variables: Detalla cómo se configuran las variables en terraform.tfvars y cómo pueden ser ajustadas según el entorno (desarrollo, producción).



## Despliegue de la Aplicación en Azure Web App

Construcción de la Imagen Docker:

Explica cómo construir y subir la imagen Docker a ACR:

bash

Copiar código

docker build -t <acr-name>.azurecr.io/webapp:latest .

docker push <acr-name>.azurecr.io/webapp:latest

Despliegue en Azure Web App:

Explica cómo configurar la Web App para usar la imagen Docker desde ACR.

Incluye los comandos Azure CLI o la configuración YAML de GitHub Actions para automatizar este proceso.

bash

Copiar código

az webapp create --resource-group <resource-group> --plan <app-service-plan> --name <webapp-name> --deployment-container-image-name <acr-name>.azurecr.io/webapp:latest

## Automatización con GitHub Actions

Configurar GitHub Actions:

Explica cómo el archivo deploy.yml está configurado para ejecutar automáticamente los pasos de despliegue.

Incluye un ejemplo del archivo deploy.yml y describe cada paso:

yaml

Copiar código

name: Deploy to Azure

  

on:

push:

branches:

- main

  

jobs:

build-and-deploy:

runs-on: ubuntu-latest

  

steps:

- name: Checkout code

uses: actions/checkout@v3

  

- name: Log in to Azure Container Registry

uses: azure/docker-login@v1

with:

login-server: ${{ secrets.ACR_NAME }}.azurecr.io

username: ${{ secrets.ACR_USERNAME }}

password: ${{ secrets.ACR_PASSWORD }}

  

- name: Build and push Docker image

run: |

docker buildx build --platform linux/amd64 --push \

-t ${{ secrets.ACR_NAME }}.azurecr.io/webapp:${{ github.sha }} \

-t ${{ secrets.ACR_NAME }}.azurecr.io/webapp:latest \

-f ./app/Dockerfile \

.

  

- name: Deploy to Azure Web App

uses: azure/webapps-deploy@v2

with:

app-name: ${{ secrets.AZURE_WEBAPP_NAME }}

images: ${{ secrets.ACR_NAME }}.azurecr.io/webapp:latest

## Pruebas y Verificación

Verificar el Despliegue:

Explica cómo acceder a la aplicación en la Web App una vez desplegada.

Incluye pasos para verificar que la infraestructura se haya desplegado correctamente.

Pruebas Post-Despliegue:

Realiza pruebas básicas para asegurar que la aplicación funcione correctamente después del despliegue.

Menciona cualquier herramienta de monitoreo o logs que se podrían utilizar para asegurar la salud de la aplicación.

## Mantenimiento y Actualización

Actualización de la Infraestructura:

Explica cómo realizar cambios a la infraestructura existente utilizando terraform plan y terraform apply.

Actualización de la Aplicación:

Detalla cómo actualizar la aplicación y desplegar nuevos cambios.

## Resolución de Problemas

Errores Comunes:

Enumera algunos errores comunes que podrían surgir durante el despliegue y cómo solucionarlos.

Enlaces a Recursos Adicionales:

Proporciona enlaces a la documentación de Terraform, Azure, y cualquier otra fuente relevante.

##  Conclusión

Resumen del proceso de despliegue y cualquier recomendación final para futuros despliegues.

## Apéndice

Enlaces Útiles: Proporciona enlaces a la documentación oficial, foros, y otros recursos útiles.
