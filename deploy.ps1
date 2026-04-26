$ErrorActionPreference = "Stop"

$name = "kubernetes-demo-api"

Write-Host "--------------------------------------"
Write-Host "Checking Minikube status ..."
Write-Host "--------------------------------------"
minikube status

Write-Host "--------------------------------------"
Write-Host "Applying Kubernetes manifests ..."
Write-Host "--------------------------------------"
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

Write-Host "--------------------------------------"
Write-Host "Waiting for rollout ..."
Write-Host "--------------------------------------"
kubectl rollout status deployment/$name

Write-Host "--------------------------------------"
Write-Host "Getting pods ..."
Write-Host "--------------------------------------"
kubectl get pods

Write-Host "--------------------------------------"
Write-Host "Getting services ..."
Write-Host "--------------------------------------"
kubectl get services

Write-Host "--------------------------------------"
Write-Host "Service URL ..."
Write-Host "--------------------------------------"
minikube service "$name-service" --url