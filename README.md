## Título y Resumen

[](https://github.com/AgustinDiaz-Nubiral/webappdemo#t%C3%ADtulo-y-resumen)

**Título**: Despliegue de Infraestructura en Azure con Terraform y Aplicación en Web App mediante Github Actions.

**Resumen**: Este repositorio cuenta con una aplicacion estatica la cual es utilizada mediante una imagen de Docker. La imagen es pusheada a un Azure container registry para ser utilizada por App Service de Azure. El despliegue de la infraestructura en Azure se realiza mediante terraform, y la aplicacion es desplegada y aprovisionada mediante el despliegue continuo de Github Actions.

## Prerequisitos

[](https://github.com/AgustinDiaz-Nubiral/webappdemo#prerequisitos)

### _Herramientas necesarias_:

[](https://github.com/AgustinDiaz-Nubiral/webappdemo#herramientas-necesarias)

**Terraform**: Para instalar terraform puede seguir los pasos en la siguiente documentación:  [Terraform Instal](https://developer.hashicorp.com/terraform/install?product_intent=terraform)  **Azure CLI**: Para instalar Azure CLI puede seguir los pasos en la siguiente documentación:  [Azure CLI Instal](https://learn.microsoft.com/es-es/cli/azure/install-azure-cli)  **Git**: Para este proyecto se utiliza el control de versiones otorgado por Github Actions (workflows).  **Autenticación en Azure**: Para la autenticación en Azure se creo un Service Principal. La razón principal para crear un Service Principal es permitir que estas aplicaciones o servicios se autentiquen y autoricen de manera segura para realizar acciones en Azure, sin requerir la intervención directa de un usuario. A continuación se adjunta el link de la documentación que se utilizo para generar el Service Principal:  [Service Principal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)  **Disponer de una Storage Account**: Para poder almacenar y resguardar el estado de terraform se debe contar con un storage account y un container ya desplegados.

## Estructura del Repositorio

[](https://github.com/AgustinDiaz-Nubiral/webappdemo#estructura-del-repositorio)

El repositorio cuenta con 3 carpetas.

1.  Infra: Contiene los archivos terraform para el despliegue de la infraestructura en Azure.
    
2.  Src: Contiene el Dockerfile para construir la imagen que va a ser pusheada al Azure Container Registry (ACR) y la carpeta que contiene los archivos correspondientes a la aplicacion (html, css, js, scss, etc)
    
3.  .github/workflows: Contiene los archivos .yml correspondientes al deploy, tanto de la app como de la infraestructura.
    
    ```
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
    
    ```
    

**maintf**: Define los recursos de Azure como la Web App, el Azure Container Registry (ACR), y cualquier otro recurso necesario. 
 **terraformtfvars**: Declara las variables utilizadas en la configuración de Terraform  
 **variabletf**: Define cada variable utilizada en la configuracion de Terraform (terraform.tfvars).  
 **Dockerfile**: Configuración de Docker para construir la imagen de la aplicación.  **build&deployapp.yml/deployinfra.yml**: Workflows de GitHub Actions para automatizar el despliegue.

## Configuración de Terraform

* Inicialización del Proyecto:
```
terraform init
```
Este comando se encarga de varias tareas fundamentales para preparar tu entorno de trabajo:

1.  **Descarga de Proveedores:**  `terraform init`  descarga los proveedores (providers) que se necesitan para interactuar con las infraestructuras que vas a gestionar. Estos proveedores son los que Terraform utiliza para comunicarse con las diferentes plataformas de nube (como Azure, AWS, GCP, etc.).
    
2.  **Configuración del Backend:**  Si estás usando un backend para almacenar el estado de Terraform (por ejemplo, en un bucket de S3 o en un storage account de Azure),  `terraform init`  lo configura para que el estado se almacene y gestione adecuadamente.
    
3.  **Inicialización de Módulos:**  Si tu configuración de Terraform incluye módulos (códigos reutilizables que encapsulan un grupo de recursos relacionados),  `terraform init`  se encargará de descargarlos o de asegurarse de que están correctamente preparados para su uso.
    
4.  **Validación del Workspace:**  `terraform init`  verifica que el workspace (entorno de trabajo) esté correctamente configurado y listo para usar.
    

 * Planificación: terraform plan para revisar los cambios que se aplicarán.

```
terraform plan
```
Cuando ejecutas `terraform plan`, Terraform lee tus archivos de configuración y compara el estado actual de tu infraestructura con el estado deseado que has definido en esos archivos. Luego, muestra un resumen de las acciones que tomará, como crear, actualizar o eliminar recursos.

* Aplicación: terraform apply para desplegar la infraestructura.

```
terraform apply
```

Cuando ejecutas `terraform apply`, Terraform hace lo siguiente:

1.  **Planificación de los cambios**: Si no has ejecutado un `terraform plan` previamente, Terraform generará un plan de cambios, similar a lo que verías con `terraform plan`.
    
2.  **Aplicación de los cambios**: Terraform te pedirá confirmación (a menos que uses la opción `-auto-approve`) y luego procederá a aplicar esos cambios. Esto incluye crear, actualizar o eliminar recursos en la infraestructura para que coincidan con la configuración deseada.
    
3.  **Actualización del estado**: Después de aplicar los cambios, Terraform actualiza el archivo de estado (`terraform.tfstate`) para reflejar el estado actual de la infraestructura.
Incluye capturas de pantalla o ejemplos de salida de estos comandos.

Variables y Parámetros:

Las variables en Terraform se configuran en un archivo llamado `terraform.tfvars`, que se utiliza para asignar valores a las variables definidas en tu archivo `variables.tf` o directamente en el archivo de configuración principal.
1. Definir Variables en `variables.tf`
2. Asignar Valores en `terraform.tfvars`

Para gestionar diferentes entornos (por ejemplo, `dev`, `staging`, `prod`), puedes crear archivos `tfvars` específicos para cada uno.


## Despliegue de la Aplicación en Azure Web App y automatizacion con Github Actions.
[](https://github.com/AgustinDiaz-Nubiral/webappdemo#automatizaci%C3%B3n-con-github-actions)

Configurar GitHub Actions:

1. ***Encabezado del Workflow***
* **name**: Este es el nombre del workflow. En la interfaz de GitHub Actions, verás este nombre asociado con las ejecuciones del workflow.
```
name: Build and Deploy Docker Image
```

2. ***Eventos que Desencadenan el Workflow***
- **on**: Define los eventos que desencadenan el workflow.
-   **push**: Este workflow se ejecutará cuando se realice un push a la rama `"main"`.
-   **branches**: Especifica que el workflow solo se ejecutará cuando se haga push a la rama `"main"`.
-   **paths**: Solo se ejecutará si el push afecta archivos en la carpeta `src/**`.
```
on: 
  push: 
	  branches: [ "main" ] 
	  paths: 
	  - 'src/**'
```

3. ***Definición de Jobs***
-   **jobs**: Define uno o más trabajos que se ejecutarán en el workflow. Aquí, solo hay un job llamado `build-and-deploy`.
-   **runs-on**: Especifica el sistema operativo del runner. En este caso, es `ubuntu-latest`.
-   **env**: Establece variables de entorno globales para el job. Estas variables se rellenan con valores almacenados en los secretos de GitHub, las cuales se obtienen del Service Principal.
-   **defaults**: Define valores por defecto para los pasos del job. Aquí se define el directorio de trabajo como `./src`.
```
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    env:
      AZURE_AD_CLIENT_ID: ${{ secrets.AZURE_AD_CLIENT_ID }}
      AZURE_AD_CLIENT_SECRET: ${{ secrets.AZURE_AD_CLIENT_SECRET }}
      AZURE_SUBCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
      AZURE_AD_TENANT_ID: ${{ secrets.AZURE_AD_TENANT_ID }}
    defaults:
       run:
        working-directory: ./src` 
```

4. ***Inicio de sesión en Azure***
-   **uses**: Utiliza la acción `azure/login@v1` para autenticarte en Azure usando las credenciales almacenadas en `AZURE_CREDENTIALS`.
```
- name: Login to Azure
  uses: azure/login@v1
  with:
    creds: ${{ secrets.AZURE_CREDENTIALS }}` 
```

5. ***Inicio de sesión en Azure Container Registry (ACR)***
-   **run**: Ejecuta un script para iniciar sesión en ACR utilizando el comando de Azure CLI.
```
- name: Log in to ACR
  run: |
    echo ${{ secrets.ACR_NAME }}.azurecr.io \
    && az acr login --name ${{ secrets.ACR_NAME }}` 
```

6. ***Obtener el Token de Acceso a ACR***
-   **id**: Asigna un ID al paso para referenciarlo más adelante.
-   **run**: Ejecuta un script que obtiene un token de acceso a ACR y lo guarda en una variable de entorno `TOKEN`.
```
- name: Get ACR Access Token
  id: get-token
  run: |
    TOKEN=$(az acr login --name ${{ secrets.ACR_NAME }} --expose-token --output tsv --query accessToken)
    echo "TOKEN=$TOKEN" >> $GITHUB_ENV` 
```

7. ***Uso del Token de ACR para Iniciar Sesión en Docker***
-   **run**: Utiliza el token obtenido para iniciar sesión en Docker en el registro de contenedores de Azure.
```
- name: Use ACR Token
  run: |
    echo "Using the ACR token: $TOKEN"
    docker login ${{ secrets.ACR_NAME }}.azurecr.io -u 00000000-0000-0000-0000-000000000000 -p $TOKEN` 
```

8. ***Configurar Docker Buildx***
-   **uses**: Utiliza la acción `docker/setup-buildx-action@v1` para configurar Docker Buildx, que permite construir imágenes multiplataforma.
```
- name: Set up Docker Buildx
  uses: docker/setup-buildx-action@v1` 
```

9. ***Construir y Enviar la Imagen Docker a ACR***
-   **working-directory**: Especifica el directorio donde se ejecutará este paso.
-   **run**: Ejecuta el comando para construir y enviar la imagen Docker a ACR. Se utiliza `github.sha` para etiquetar la imagen con el hash del commit, y también se etiqueta como `latest`. La etiqueta del bash es util para identificar en el ACR la ultima versión implementada, y la latest la que tomara el web app.
```
- name: Build and Push Docker image
  working-directory: ./src
  run: |
    docker buildx build --platform linux/amd64 --push \
      -t ${{ secrets.ACR_NAME }}.azurecr.io/webapp:${{ github.sha }} \
      -t ${{ secrets.ACR_NAME }}.azurecr.io/webapp:latest \
      -f Dockerfile \
      .` 
```

10. ***Cerrar Sesión en ACR***
-   **run**: Ejecuta el comando para cerrar la sesión en ACR.
```
- name: Azure Container Registry Logout
  run: |
    docker logout ${{ secrets.ACR_NAME }}.azurecr.io` 
```

11. ***Desplegar la Imagen en Azure Web App***
-   **uses**: Utiliza la acción `azure/webapps-deploy@v2` para desplegar la imagen Docker en una aplicación web en Azure.
-   **with**: Especifica el nombre de la aplicación web (`app-name`) y la imagen Docker (`images`) que se desplegará.
```
- name: Deploy to Azure Web App
  uses: azure/webapps-deploy@v2
  with:
    app-name: ${{ secrets.WEBAPP_NAME }}
    images: ${{ secrets.ACR_NAME }}.azurecr.io/webapp:latest` 
```



## Pruebas y Verificación
**PASOS PARA ACCEDER A LA APLICACION UNA VEZ DESPLEGADA**
1. #### *Verificar el Estado del Despliegue en GitHub Actions*

-   **GitHub Actions**: Primero, verifica en GitHub si el workflow de Actions se ha ejecutado correctamente. Accede a la pestaña **"Actions"** en tu repositorio, selecciona el último workflow que se ejecutó y revisa los detalles para confirmar que todos los pasos se completaron sin errores.

2. #### *Verificar el Estado de la Web App en el Portal de Azure*

-   **Portal de Azure**:
    1.  Inicia sesión en el [Portal de Azure](https://portal.azure.com/).
    2.  Navega a **"App Services"** en el menú lateral izquierdo.
    3.  Busca y selecciona tu Web App.
    4.  En la sección **"Overview"** de la Web App, podrás ver el estado de la aplicación (Running, Stopped, etc.) y la URL para acceder a la aplicación.

3. ####  *Acceder a la Web App*

-   **Navegador Web**:
    1.  Copia la URL de la Web App desde el Portal de Azure.
    2.  Pega la URL en tu navegador y verifica que la aplicación esté funcionando como se espera.

**PASOS PARA VERIFICAR LA INFRAESTRUCTURA  DESPLEGADA**
1. ####  *Verificar el Estado de los Recursos en el Portal de Azure*

-   **Portal de Azure**:
    1.  Inicia sesión en el [Portal de Azure](https://portal.azure.com/).
    2.  Accede al **"Resource Group"** en el que se desplegó la infraestructura.
    3.  Revisa los recursos creados.
    4.  Puedes hacer clic en cada recurso para revisar su configuración específica y asegurarte de que se ajusta a lo que definiste en tus archivos de Terraform.

2. #### *Revisar el Archivo de Estado* (`terraform.tfstate`)

-   **Terraform State**:
    
    1.  Abre el archivo `terraform.tfstate` que se encuentra en la cuenta de almacenamiento creada para almacenar el estado de terraform.
    2.  Verifica que todos los recursos definidos en tus archivos de configuración de Terraform estén presentes en el estado y que sus atributos coincidan con lo que esperabas.

**PRUEBAS POST DESPLIEGUE**
1. #### Hacer un cambio en el repositorio local dentro de la carpeta src y luego seguir los pasos de verificación indicados anteriormente.
## Mantenimiento y Actualización


