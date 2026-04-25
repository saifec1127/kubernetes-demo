#!/bin/bash

# ------------------------------------------------------------
# set -e
# ------------------------------------------------------------
# Iska matlab:
# Agar script me koi bhi command fail ho jaati hai,
# to script wahi par turant ruk jayegi.
#
# Example:
# Agar docker push fail ho gaya,
# to uske baad kubectl apply nahi chalega.
# Ye safe behavior hai.
# ------------------------------------------------------------
set -e


# ------------------------------------------------------------
# NAME
# ------------------------------------------------------------
# Ye hamari application ka naam hai.
# Isi naam ka use hum:
# - Docker image naming me
# - Kubernetes service naming me
# indirectly kar rahe hain.
#
# Example:
# NAME="kubernetes-demo-api"
# to service ka naam ho sakta hai:
# kubernetes-demo-api-service
# ------------------------------------------------------------
NAME="kubernetes-demo-api"


# ------------------------------------------------------------
# USERNAME
# ------------------------------------------------------------
# Ye tumhara Docker Hub username hai.
# Docker image ko push karne ke liye image ka full naam hota hai:
#
# username/image-name:tag
#
# Yahan username = saifec1127
# ------------------------------------------------------------
USERNAME="saifec1127"


# ------------------------------------------------------------
# IMAGE
# ------------------------------------------------------------
# Ye final Docker image name bana raha hai.
#
# Format:
# $USERNAME/$NAME:latest
#
# Agar:
# USERNAME="saifec1127"
# NAME="kubernetes-demo-api"
#
# to final image banegi:
# saifec1127/kubernetes-demo-api:latest
#
# latest ek tag hai.
# Tag ka matlab image ka version.
# ------------------------------------------------------------
IMAGE="$USERNAME/$NAME:latest"


# ------------------------------------------------------------
# Step 1: Docker image build karna
# ------------------------------------------------------------
# Ye message sirf terminal me info dikhane ke liye hai
# taaki tumhe pata chale ab script kaunsa step run kar rahi hai.
# ------------------------------------------------------------
echo "Building Docker image ..."

# Ye command current folder ke Dockerfile ko use karke
# Docker image build karti hai.
#
# docker build
#   -t  => image ka tag/name dene ke liye
#   $IMAGE => final image name
#   . => current folder build context hai
#
# Build context ka matlab:
# current folder ki files Docker daemon ko milengi
# jisse Dockerfile COPY wagairah kar sake.
docker build -t $IMAGE .


# ------------------------------------------------------------
# Step 2: Docker Hub par image push karna
# ------------------------------------------------------------
# Build hone ke baad image sirf local machine par hoti hai.
# Kubernetes agar Docker Hub se image kheech raha hai,
# to image ko Docker Hub par push karna zaroori hai.
# ------------------------------------------------------------
echo "Pushing image to Docker Hub ..."

# Ye command built image ko Docker Hub par upload karti hai.
#
# Important:
# Isse pehle docker login kiya hua hona chahiye.
#
# Agar login nahi hoga,
# to push fail ho jayega.
docker push $IMAGE


# ------------------------------------------------------------
# Step 3: Kubernetes manifests apply karna
# ------------------------------------------------------------
# Ab image Docker Hub par chali gayi,
# to ab Kubernetes ko bolna hai ki
# naye deployment aur service configs apply kare.
# ------------------------------------------------------------
echo "Applying Kubernetes manifests ..."

# deployment.yaml apply karna:
# Ye Kubernetes Deployment resource create/update karega.
#
# Deployment ka kaam:
# - pods create karna
# - replicas maintain karna
# - image ke basis par containers chalana
kubectl apply -f k8s/deployment.yaml

# service.yaml apply karna:
# Ye Kubernetes Service create/update karega.
#
# Service ka kaam:
# - pods ko ek stable naam dena
# - un tak network traffic pahunchana
# - cluster ya outside se access allow karna
kubectl apply -f k8s/service.yaml


# ------------------------------------------------------------
# Step 4: Pods ka status dekhna
# ------------------------------------------------------------
# Isse pata chalega ki deployment apply hone ke baad
# pods create hue ya nahi
# aur wo Running state me aaye ya nahi.
# ------------------------------------------------------------
echo "Getting pods ..."

# kubectl get pods
# Ye cluster ke pods ki list dikhata hai
# along with:
# - READY
# - STATUS
# - RESTARTS
# - AGE
#
# Yahan se tum dekh sakte ho:
# - Running
# - CrashLoopBackOff
# - ImagePullBackOff
# - Pending
kubectl get pods


# ------------------------------------------------------------
# Step 5: Services ka status dekhna
# ------------------------------------------------------------
# Isse pata chalega ki service create hui ya nahi
# aur kis port par expose ho rahi hai.
# ------------------------------------------------------------
echo "Getting services ..."

# kubectl get services
# Ye cluster ki sari services dikhata hai.
#
# Yahan se tum dekh sakte ho:
# - service name
# - type (ClusterIP / NodePort / LoadBalancer)
# - cluster IP
# - ports
kubectl get services


# ------------------------------------------------------------
# Step 6: Sirf hamari main service ka output dekhna
# ------------------------------------------------------------
# Ye command specifically hamari app ki service ko fetch karegi.
#
# Agar NAME="kubernetes-demo-api"
# to final service name banega:
# kubernetes-demo-api-service
# ------------------------------------------------------------
echo "Fetching the main service ..."

# Yahan $NAME-service ka expand hoke value banegi:
# kubernetes-demo-api-service
#
# Ye command specifically us service ko show karegi.
kubectl get services $NAME-service