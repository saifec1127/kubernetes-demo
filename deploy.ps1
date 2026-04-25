# Agar koi command fail ho jaye to script turant stop ho
$ErrorActionPreference = "Stop"

# Application ka naam
$name = "kubernetes-demo-api"

# Docker Hub username
$username = "saifec1127"

# Final Docker image name
$image = "$username/${name}:latest"

Write-Host "--------------------------------------"
Write-Host "Building Docker image ..."
Write-Host "Image: $image"
Write-Host "--------------------------------------"

docker build -t $image .

Write-Host "--------------------------------------"
Write-Host "Pushing image to Docker Hub ..."
Write-Host "--------------------------------------"

docker push $image

Write-Host "--------------------------------------"
Write-Host "Applying Kubernetes manifests ..."
Write-Host "--------------------------------------"

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

Write-Host "--------------------------------------"
Write-Host "Getting pods ..."
Write-Host "--------------------------------------"

kubectl get pods

Write-Host "--------------------------------------"
Write-Host "Getting services ..."
Write-Host "--------------------------------------"

kubectl get services

Write-Host "--------------------------------------"
Write-Host "Fetching the main service ..."
Write-Host "--------------------------------------"

kubectl get services "$name-service"