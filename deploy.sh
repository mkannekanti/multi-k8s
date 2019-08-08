#!/bin/bash
docker build -t mkannekanti/multi-client:latest -t mkannekanti/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t mkannekanti/multi-server:latest -t mkannekanti/multi-server:$SHA -f ./server/Dockerfile ./server
docker built -t mkannekanti/multi-worker:latest -t mkannekanti/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push mkannekanti/multi-client:latest
docker push mkannekanti/multi-server:latest
docker push mkannekanti/multi-worker:latest

docker push mkannekanti/multi-client:$SHA
docker push mkannekanti/multi-server:$SHA
docker push mkannekanti/multi-worker:$SHA

kubectl apply -f ./k8s
kubectl set image deployments/server-deployment server=mkannekanti/multi-server:$SHA
kubectl set image deployments/client-deployment client=mkannekanti/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=mkannekanti/multi-worker:$SHA