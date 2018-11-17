jobs=$(shell realpath ./jobs)
casc_configs=$(shell realpath ./jobs)

image=jenkins_plugins
JENKINS_HOME=/var/jenkins_home
VOLUMES=--mount type=bind,source=${jobs},target=${JENKINS_HOME}/jobs
VOLUMES+= --mount type=bind,source=${casc_configs},target=${JENKINS_HOME}/casc_configs

# bindmount a full jenkins install
#VOLUMES+= --mount type=bind,source=/opt/jenkins/jenkins-8080,target=${JENKINS_HOME}

ENV=-e CASC_JENKINS_CONFIG=${JENKINS_HOME}/casc_configs 
ENV+=-e JAVA_OPTS=-Djenkins.install.runSetupWizard=false

t: gen

adminuser.secret:
	$(shell umask 077; date +%s|sha256sum|base64|head -c 32 > adminuser.secret )

user1.secret:
	$(shell umask 077; date +%s|sha256sum|base64|head -c 32 > user1.secret )

gen: adminuser.secret user1.secret
	mkdir -p casc_configs
	sed -e "s/==adminuser.secret==/$(shell cat adminuser.secret)/g" -e "s/==user1.secret==/$(shell cat user1.secret)/g" < template/jenkins.yaml > casc_configs/jenkins.yaml

vars:
	echo jobs ${jobs}
	echo casc_configs ${casc_configs}
	docker logs ${image}

dockerinit:	
	docker pull ${image}

shell:
	docker run --rm -it ${VOLUMES} ${ENV} $(image) /bin/bash -i

build:
	docker build . -t ${image}

run: gen
	docker run --rm ${VOLUMES} ${ENV} -p 8080:8080 ${image}

lint:  
	yamllint template/jenkins.yaml

