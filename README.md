# devsecops-nap
Repo to simplify and learn DevSecOps with Nginx App Protect

# Pre-Reqs

* Azure AKS up and running
* A private container repo (Azure Container registry for instance)
* Kubeconfig file
* Kubectl CLI and/or k8s tools like Lens
* Nginx App Protect license

# Deploy Sentence App in your AKS

* Deploy Sentence Application in your AKS
* To do so, use the manifests available in /k8s-deployment folder

## Deploy the Sentence App microservice

The manifest aks-sentence-deployment.yaml will deploy the different microservices. As reminder, the Sentence Application display a sentence with 4 words coming from 4 microservices (more information here https://github.com/MattDierick/sentence-generator-app)

## Deploy the frontend microservice

The manifest aks-sentence-deployment-nginx-nolb.yaml will deploy the frontend service (base on nginx webserver). As you can notice, this service is not yet exposed. The associated service is a ClusterIP type.

# Build the Nginx App Protect docker image

In order to expose the Sentence Application, we will deploy a NAP as a POD (not Ingress) in order to expose and protect the Sentence Application.

The docker image will stay static. It means, we don't want to re-build a new image everytime a config update is done. It means configuration files will be imported from a source of truth (Github).
A configuration update is:

* A new application exposed (nginx.conf)
* A NAP policy update (signature, violation exception ...)

**Prepare your Azure Container Registry**

* Create an Azure Container Registry as private (premium offering)
* Interconnect your laptop (the one with Docker running) with your private Azure repo

`az login`

`az account set --subscription <subscription-ID>`

`TOKEN=$(az acr login --name <your_registry> --expose-token --output tsv --query accessToken)`

`docker login <your_registry>.azurecr.io --username 00000000-0000-0000-0000-000000000000 --password $TOKEN`

**Steps**

* In /nginx-nap directory, copy your nginx-repo.crt and nginx-repo.key
* Build your docker image

`DOCKER_BUILDKIT=1 docker build --no-cache --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key -t <your_registry>.azurecr.io/nginx/nap:v1.0 .`

* Push your NAP image into your private registry

`docker push <your_registry>.azurecr.io/nginx/nap:v1.0`

