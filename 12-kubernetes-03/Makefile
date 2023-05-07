kubectl-apply-deployment1:
	kubectl apply -f ./src/deployment1.yml

kubectl-delete-deployment1:
	kubectl delete -f ./src/deployment1.yml

kubectl-get-all-deployments:
	kubectl get deployments

kubectl-get-deployment:
	kubectl get deployments nginx-multitool

kubectl-describe-deployment:
	kubectl describe deployments nginx-multitool

kubectl-logs-deployment:
	kubectl logs deployments/nginx-busybox


kubectl-get-all-pods:
	kubectl get pods -A

kubectl-get-default-pods:
	kubectl get pods

kubectl-get-logs-pod:
	kubectl logs pods/nginx-busybox-57994587bd-qhmx6


kubectl-apply-service1:
	kubectl apply -f ./src/service1.yml

kubectl-delete-service1:
	kubectl delete -f ./src/service1.yml

kubectl-get-service:
	kubectl get service

kubectl-describe-service1:
	kubectl describe service netology-svc

kubectl-port-forward-service-80:
	kubectl port-forward svc/netology-svc 36307:80

kubectl-port-forward-service-1180:
	kubectl port-forward svc/netology-svc 37307:1180


kubectl-apply-pod1:
	kubectl apply -f ./src/pod1.yml

kubectl-delete-pod1:
	kubectl delete -f ./src/pod1.yml

kubectl-logs-pod1:
	kubectl logs -p netology-web

kubectl-get-pod1:
	kubectl get pod netology-web

kubectl-describe-pod1:
	kubectl describe pod netology-web

kubectl-exec-pod1:
	kubectl exec -it netology-web /bin/bash

kubectl-exec-pod1-curl-80:
	kubectl exec -it netology-web -- curl netology-svc:80

kubectl-exec-pod1-curl-1180:
	kubectl exec -it netology-web -- curl netology-svc:1180


kubectl-apply-deployment2:
	kubectl apply -f ./src/deployment2.yml

kubectl-delete-deployment2:
	kubectl delete -f ./src/deployment2.yml


kubectl-apply-service2:
	kubectl apply -f ./src/service2.yml

kubectl-delete-service2:
	kubectl delete -f ./src/service2.yml


kubectl-exec-pod1-curl-:
	kubectl exec -it nginx-busybox-cbb9d94cc-tkc9j /bin/bash

kubectl-get-logs-pod-:
	kubectl logs pods/nginx-busybox-576b9c7469-4t5nr



up:
	docker-compose up -d

down:
	docker-compose down

build:
	docker-compose build

push:
	docker-compose push

pull:
	docker-compose pull

down-clear:
	docker-compose down --volume --remove-orphans

busybox-bash:
	docker exec -it busybox sh