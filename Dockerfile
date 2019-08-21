FROM jenkins/jenkins
MAINTAINER Sean McEligot <sean.mceligot@gmail.com>

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY jenkins-plugin-manager-0.1-alpha-12-SNAPSHOT.jar plugin-management-cli-0.1-alpha-12-SNAPSHOT.jar plugin-management-library-0.1-alpha-12-SNAPSHOT.jar /usr/share/jenkins/
RUN java -jar /usr/share/jenkins/jenkins-plugin-manager-*.jar --war /usr/share/jenkins/jenkins.war --plugin-file /usr/share/jenkins/ref/plugins.txt

COPY jenkins.yaml ${JENKINS_HOME}/jenkins.yaml
ENV CASC_JENKINS_CONFIG=$JENKINS_HOME/jenkins.yaml

COPY init.groovy.d/ $JENKINS_HOME/init.groovy.d/

COPY logging.properties ${JENKINS_HOME}/logging.properties

ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false -Djenkins.model.Jenkins.slaveAgentPort=50000 -Djenkins.model.Jenkins.slaveAgentPortEnforce=true -Djava.util.logging.config.file=${JENKINS_HOME}/logging.properties"

