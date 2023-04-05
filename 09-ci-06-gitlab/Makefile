restart: docker-down docker-up

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-down-clear:
	docker-compose down --volume --remove-orphans

gitlab-reset-password-root:
	# pass1234#
	docker exec -it gitlab sh -c 'gitlab-rake "gitlab:password:reset[root]"'

ping-from-gitlab-runner-to-gitlab:
	docker exec -it gitlab-runner sh -c 'ping gitlab'

curl-test:
	docker exec -it gitlab-runner sh -c 'curl -Gik https://172.21.0.3:443/'

curl-test2:
	docker exec -it gitlab-runner sh -c 'openssl x509 -in /etc/gitlab-runner/certs/your-domain.net.crt -out /etc/gitlab-runner/certs/your-domain.net.pem -outform PEM'

curl-test3:
#    docker exec -it gitlab-runner sh -c 'export HOST="your-domain.net" && export IP="127.0.0.1" && openssl req -newkey "rsa\:4096" -nodes -keyout ${HOST}.key -x509 -days 365 -out ${HOST}.crt -addext "subjectAltName = IP:${IP}" -subj "/C=US/ST=CA/L=SanFrancisco/O=MyCompany/OU=RND/CN=${HOST}/"'
#    docker exec -it gitlab-runner sh -c "openssl req -newkey "rsa:4096" -nodes -keyout your-domain.net.key -x509 -days 365 -out your-domain.net.crt -addext "subjectAltName = IP:172.21.0.3" -subj "/C=US/ST=CA/L=SanFrancisco/O=MyCompany/OU=RND/CN=${HOST}/""

gitlab-runner-register:
	docker exec -it gitlab-runner sh -c 'gitlab-runner register --tls-ca-file /etc/gitlab-runner/certs/your-domain.net.key --url https://172.21.0.3:443/ --registration-token GR1348941yYRy5uXd3Dmqcx24fs8K'
#	docker exec -it gitlab-runner sh -c 'gitlab-runner register --tls-ca-file /etc/gitlab-runner/certs/letsencrypt_account_private_key.pem --url https://172.21.0.3:443/ --registration-token GR1348941yYRy5uXd3Dmqcx24fs8K'

docker-pull:
	docker pull registry.gitlab.com/somovaa/netology/python-api.py:latest

docker-run:
	docker run -p 5290:5290 -d registry.gitlab.com/somovaa/netology/python-api.py:latest

get_info:
	curl localhost:5290/get_info