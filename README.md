# Idan Mishor

## Pre-requisites
Before you start please make sure you have the following:

- GCP Account
- GCP user credentials
- Terraform installed
- Kubectl installed
- Google SDK Installed

## Delivery Objects
- Docker files for each application
- Terraform project to initialze GKE cluster
- CI/CD process

# Default Configurations:
 - The default name for the GKEcluster is **playground**
 - Default region for cluster deployment is **europe-west1**
 - Default deployment name is **hw-app**
 
    
# Runbook for deployment
In order to provision the environment please use the following steps:

 - clone the repo localy
 - create the GKE cluster:
    - go into the terraform folder and type `terraform init`
    - run `terraform plan`
    - run `terraform apply` to create the cluster
after few minutes your cluster will be ready
 - get authentication credentials to interact with the cluster:
 
   `gcloud container clusters get-credentials playground --region europe-west1`
 - deploy the deployments and services for each app
 ```
    kubectl apply -f service.yaml
    kubectl apply -f deployment.yaml
 ```

# Autoscale handeling
- **The terraform project takes care of autoscaling the cluster as it sets minimum and maximun nodes per zone**
- enable autoscale on each service by running the bellow commands:
```
  kubectl autoscale deployment hw-app --max 10 --min 2 --cpu-percent 50
```
# continuous delivery 
  I would use Jenkins as the CI/CD tool in order to get this code ready for CD deployment and perform the following steps:
- Define a policy to restrict commits directly to the master branch, instead use feature branches.
-  Define a webhook to trigger build pipleline onpon a commit to the repo. the pipeline will do the following:
  1. run unit tests (for example check python syntax: `python -m py_compile app_a.py`)
  2. build docker image
  3. push the new docker to GCR 
  4. change the **deployment.yaml** file fo use the newly pushed docker image
  5. deploy the service with the new docker image into a staging environment
  6. run full tests, in our case:
 ```
   curl https://{{service_ip_addr}}/hello
   curl -X POST -H 'Authorization: mytoken' https://{{service_ip_addr}}/jobs --insecure
   ab -m POST -H "Authorization: mytoken" -n 500 -c 4 https://{{service_ip_addr}}/jobs --insecure
  ```
 7. after all checks passed create a pull request to master
 8. after confiltcs have been sorted merge to master is allowd
 9. upon a merge to master a new pipeline will be triggered that deploys the new service to production the productoin environment.
 10. run full tests again
 11. after all test are successfull creates a rolling update on the production service
