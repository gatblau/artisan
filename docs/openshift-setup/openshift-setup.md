[[_TOC_]]

# Setup Nexus Repo

Nexus Repository is the central source of control to efficiently manage all binaries and build artifacts across your DevOps pipeline. 

## Prerequisites

1) Install Nexus Operator in openshift namespace
   - Switch to Administrator Perspective
   - Open OperatorHub -> Search for "Nexus Repository Operator"
   - Select namespace & click on install button

2) Create separate Service Account for Nexus Repository

    User Management -> Service Accounts -> Create ServiceAccount

3) Now attach custom scc

```bash
oc apply -f nexus-custom-scc.yaml

oc adm policy add-scc-to-user scc-nexus -z <nexus-service-account>
```

## Create Nexus Repo Application

1) Switch to Administrator Section

2) Click on Operators & select Nexus Repository Operator

3) Click on NexusRepo tab -> Create NexusRepo

4) Select yaml view -> change app name 

5) Change NEXUS_SECURITY_RANDOMPASSWORD to true

6) Click on Create Button

## Expose Route for Nexus Repo

1) Switch to Administrator Section

2) Click on Networking -> Routes -> Create Route -> Enter route name -> From service list select nexus repo

3) Enable security route -> Termination Type=Edge -> Insecure Traffic=Redirect 

4) Click on Create button 

Now we have to change the ServiceAccount as by default application gets installed inside the Default SA. 

Click on Nexus repo app -> Click on Pods -> Switch to yaml section & add below code under spec

```bash
spec:
  serviceAccountName: <nexus-service-account>
```

## Create Nexus Repository 

1) Now open nexus console & follow the on screen instructions to setup repo

2) Click repositories -> Create Repository -> Select Raw Hosted ->  Enter Name=artisan & click on Create Repository button  

# Setup Artisan Registry

Artisan Registry in openshift acts like a proxy for the nexus repository that we have created in the previous step. Here we just need to create an artisan registry application.

1) oc create -f ArtisanRegistry_OpenshiftCatalogTemplate.yaml

2) Switch to Developer section

3) Click on Add -> In catalog, search for Artisan Registry template

4) Pass all required parameters. Refer the below table for parameter values

5) Click on Create button

Parameter Details For Artisan Registry

| item | possible vale | description |
|---|---|---|
| APPLICATION_NAME | - | Application name |
| OXA_METRICS_ENABLED | - true <br> - false | Enable Metrix |
| OXA_SWAGGER_ENABLED | - true <br> - false | Enable Swagger UI |
| OXA_HTTP_UNAME | - | Nexus Registry Username |
| OXA_HTTP_PWD | - | Nexus Registry Password |
| OXA_HTTP_BACKEND | Nexus3 | Backend name |
| OXA_HTTP_BACKEND_DOMAIN | - | Nexus App URI |
| OXA_HTTP_UPLOAD_LIMIT | 30 | Artefact Upload Limit |


# Setup Artisan Runner

Artisan Runner is used to create tekton PipelineRun so that there is no need to install tkn cli on the host machine.

1) Create artisan-runner Service Account

2) Create artisan-runner template

```bash
oc create -f ArtisanRunner_OpenshiftCatalogTemplate.yaml
```

2) Switch to Developer section

3) Click on Add -> In catalog, search for Artisan Runner template

4) Pass all required parameters. Refer the below table for parameter values

5) Click on Create button

Attach rbac policy to artisan-runner service account. This policy will allow us to create tekton pipeline & it's resources inside openshift.

```bash
oc apply -f art-runner-rbac.yaml
```

| item | possible vale | description |
|---|---|---|
| APPLICATION_NAME | artisan-runner | Application name |
| OXA_HTTP_UNAME | - | Artisan Runner Username |
| OXA_HTTP_PWD | - | Artisan Runner Password |
| ARTISAN_RUNNER_IMAGE | quay.io/gatblau/artisan-runner | Artisan Runner Docker Image Name |

# Setup SonnarQube in OpenShift

SonarQube is an open-source platform developed by SonarSource for continuous inspection of code quality to perform automatic reviews with static analysis of code to detect bugs, code smells, and security vulnerabilities on 20+ programming languages.

1) oc create -f SonarQube_OpenshiftCatalogTemplate.yaml

2) Switch to Developer section

3) Click on Add -> In catalog, search for SonarQube template

4) Pass all required parameters. Refer the below table for parameter values

5) Click on Create button

| item | possible vale | description |
|---|---|---|
| APPLICATION_NAME | sonarqube | Application name |
| SONARQUBE_IMAGE | docker.io/library/sonarqube | SonarQube Docker Image Name |

## Generate Token

For authentication we need to generate Sonar Token for that simply get login into the Sonar Dashboard using default creds. Click on Administrator -> My Account -> Security -> Under Generate Token section enter any name & click on Generate button. Save token with you.

# Install Artisan CLI in control machine

```bash
art open -u=<ART_REG_USER>:<ART_REG_PWD> <ART_PACKAGE_NAME>
```

Now copy art cli to /usr/bin/ folder

```bash
cp art /usr/bin/
```

Validate installation by using the below command

```bash
art -v
```

# Configure non-privileged user for Artisan & generate keys

It's always good to execute commands with minimal permissions. So here we have to configure a non-privileged user to run the tool.

```bash
# Create runtime group
groupadd -g 100000000 -o runtime

# Create runtime user & add to group
useradd -u 100000000 -G runtime runtime

# Give docker permission to runtime user
usermod -aG docker runtime

```

Now genertare Cryptographic Signature Keys. Here private key is used for encrypting the package and public key to decrypt it.

```bash
art pgp gen .
```

import public & private key 

```bash
art pgp import -k=true root_rsa_key.pgp
art pgp import -k=false root_rsa_pub.pgp
```

# CICD using Openshift Tekton Pipeline

OpenShift Pipelines is a cloud-native continuous integration and delivery (CI/CD) solution for building pipelines using Tekton. Tekton is a flexible Kubernetes-native open-source CI/CD framework which enables automating deployments across multiple platforms (Kubernetes, serverless, VMs, etc)

## Prerequisites

Create pipeline gitlab secrets & secrets to pull docker image from gitlab registry to deploy application.

```bash
# Add gitlab creds in secrets-pipeline.yaml file & Create pipeline secrets
oc create -f secrets-pipeline.yaml

# Create secrets to pull docker image from the gitlab registry
oc create secret docker-registry <secret_name1> --docker-server=registry.gitlab.com  --docker-username=<gitlab_uname> --docker-password=<gitlab_user_pwd>

oc create secret docker-registry <secret_name2> --docker-server=gitlab.com  --docker-username=<gitlab_uname> --docker-password=<gitlab_user_pwd>

```
After creating secrets we need to link these secrets to the service account under which applications are running.

```bash
# Link secret to the pipeline service account
oc secrets link pipeline pipeline-gitlab-secret

# Link secrets to the default service account
oc secrets link default <secret_name1> --for=pull
oc secrets link default <secret_name2> --for=pull
```

We are done with Openshift Setup required to create Tekton Pipeline & Generate Code using artisan package. Now [CLICK HERE](https://github.com/gatblau/artisan/tree/master/package/app#how-to-run-the-packages) to know more about How to build the & run packages.