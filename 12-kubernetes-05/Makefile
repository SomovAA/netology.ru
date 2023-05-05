kubectl-get-all-deployments:
	kubectl get deployments

kubectl-apply-deployment-frontend:
	kubectl apply -f ./src/frontend/Deployment.yml

kubectl-delete-deployment-frontend:
	kubectl delete -f ./src/frontend/Deployment.yml

kubectl-apply-deployment-backend:
	kubectl apply -f ./src/backend/Deployment.yml

kubectl-delete-deployment-backend:
	kubectl delete -f ./src/backend/Deployment.yml


kubectl-get-service:
	kubectl get service

kubectl-apply-service-frontend:
	kubectl apply -f ./src/frontend/Service.yml

kubectl-delete-service-frontend:
	kubectl delete -f ./src/frontend/Service.yml

kubectl-apply-service-backend:
	kubectl apply -f ./src/backend/Service.yml

kubectl-delete-service-backend:
	kubectl delete -f ./src/backend/Service.yml


kubectl-get-pods:
	kubectl get pods

kubectl-exec-pod-backend-curl-80:
	kubectl exec -it backend-69fdc9f5fb-bj6nf -- curl frontend:80


kubectl-get-ingress:
	kubectl get ingress

kubectl-apply-ingress:
	kubectl apply -f ./src/Ingress.yml

kubectl-delete-ingress:
	kubectl delete -f ./src/Ingress.yml

kubectl-describe-ingress:
	kubectl describe ingress my-ingress


minikube-service-backend:
	minikube service backend --url

minikube-service-frontend:
	minikube service frontend --url


kubectl-get-pods-ingress-nginx:
	kubectl get pods --namespace=ingress-nginx

kubectl-logs-ingress-nginx:
	kubectl logs pods/ingress-nginx-controller-6bdb654777-mhkj2 --namespace=ingress-nginx




kubectl-get-service-ingress-nginx-controller:
	kubectl get service ingress-nginx-controller --namespace=ingress-nginx

