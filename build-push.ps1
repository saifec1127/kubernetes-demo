$ErrorActionPreference = "Stop"

$name = "kubernetes-demo-api"
$username = "saifec1127"
$image = "$username/${name}:latest"

Write-Host "Building Docker image ..."
docker build -t $image .

Write-Host "Pushing image to Docker Hub ..."
docker push $image