kubectl-get-all-deployments:
	kubectl get deployments

kubectl-apply-deployment:
	kubectl apply -f ./src/deployment.yml

kubectl-delete-deployment:
	kubectl delete -f ./src/deployment.yml


kubectl-get-service:
	kubectl get service

kubectl-apply-service:
	kubectl apply -f ./src/service.yml

kubectl-delete-service:
	kubectl delete -f ./src/service.yml

kubectl-apply-service2:
	kubectl apply -f ./src/service2.yml

kubectl-delete-service2:
	kubectl delete -f ./src/service2.yml


kubectl-get-pods:
	kubectl get pods

kubectl-apply-pod:
	kubectl apply -f ./src/pod.yml

kubectl-delete-pod:
	kubectl delete -f ./src/pod.yml

kubectl-exec-pod1:
	kubectl exec -it netology-pod /bin/bash

kubectl-exec-pod1-curl-80:
	kubectl exec -it netology-pod -- curl netology-svc:9001

kubectl-exec-pod1-curl-1180:
	kubectl exec -it netology-pod -- curl netology-svc:9002


kubectl-:
	minikube service netology-node-port --url


curl-localhost-30080:
	curl http://192.168.67.2:30080