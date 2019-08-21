jobs=$(shell realpath ./jobs)

image=jenkins_casc_folder_auth
JENKINS_HOME=/var/jenkins_home
VOLUMES=--mount type=bind,source=${jobs},target=${JENKINS_HOME}/jobs

default: build vars run

vars:
	docker inspect ${image} | grep JENKINS

shell:
	docker run --rm -it ${VOLUMES} $(image) /bin/bash -i

build: 
	docker build . -t ${image}

run: 
	docker run --rm ${VOLUMES} -p 8080:8080 ${image} 2>&1 | tee run.log

lint:  
	yamllint jenkins.yaml

