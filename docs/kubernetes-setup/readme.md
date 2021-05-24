The steps in this readme are performed on Azure Cluster (AKS).

# Prerequisite
To perform the below steps, on the development machine the following tools are required:

- kubectl cli
- az cli

# Deploy Kubernetes Service on Azure 

1) Select Kubernetes Service from the list of available services

2) Click on Add -> Add Kubernetes Cluster

3) Enter required cluster configuration details & click on Review + Create. It will take around 2-3 minutes to deploy cluster based on the number of nodes

4) Once the cluster is up & running click on the connect button

5) Copy az commands to get logged into the AKS cluster

# Install Tekton Pipeline

Install Tekton Pipeline in Kubernetes
```bash
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
```

Create Service Account 
```bash
kubectl create sa pipeline
```

# Create Pipeline Registry Secrets
NOTE: In this example, a Gitlab repository and registry are used.

Create pipeline gitlab secrets & secrets to pull docker image from gitlab registry to deploy application.

```bash
# Add gitlab creds in secrets-pipeline.yaml file & Create pipeline secrets
kubectl create -f secrets-pipeline.yaml

# Create secrets to pull docker image from the gitlab registry
kubectl create secret docker-registry <secret_name1> --docker-server=registry.gitlab.com  --docker-username=<gitlab_uname> --docker-password=<gitlab_user_pwd>

kubectl create secret docker-registry <secret_name2> --docker-server=gitlab.com  --docker-username=<gitlab_uname> --docker-password=<gitlab_user_pwd>

```

After creating secrets we need to link them to the service account under which applications are running.

```bash
# Link secret to the pipeline service account
kubectl secrets link pipeline pipeline-gitlab-secret

# Link secrets to the default service account
kubectl secrets link default <secret_name1> --for=pull
kubectl secrets link default <secret_name2> --for=pull

```

# Deploy Artisan Runner App

Before deploying artisan runner app, we need to enable AKS cluster routing so that application is accessible using url instead of public ip

```bash
az aks enable-addons --resource-group <RESOURCE_GROUP_NAME> --name <KUBE_CLUSTER_NAME> --addons http_application_routing
```

Now get AKS cluster app routing zone name
```bash
az aks show --resource-group <RESOURCE_GROUP_NAME> --name <KUBE_CLUSTER_NAME> --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName -o table
```

Output Format: 70e74a97963e4f81a821.eastus.aksapp.io

Note:- Replace the above output with ${HTTPApplicationRoutingZoneName} in artisan-runner.yaml. Also add artisan uname & password.

Add policy to the artisan runner app namespace
```bash
kubectl apply -f art-runner-rbac.yaml
```

Create Artisan Runner app
```bash
kubectl apply -f artisan-runner.yaml
```

# Attach rbac policy to the pipeline service account

In kubernetes, pipeline SA is not able to create deployment, ingress & service resources in the default SA. to create these resources we need to attach the rbac-app-deployment.yaml rbac to pipeline SA

```bash
oc apply -f rbac-app-deployment.yaml
```

# Run ci pipeline in different namespace (optional)

1) Create ci-namespace

```bash
kubectl create ns ci-namespace
```

2) Add rbac policy 

```bash
kubectl apply -f ci-rbac-runner.yaml
```

3) Create Service Account 
```bash
kubectl create sa pipeline
```

3) Create Pipeline Registry Secrets (Refer above sections)
