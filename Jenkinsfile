stage('test'){
node ('docker-jenkins-slave') {
checkout scm
sh 'chmod a+x ./run_test.sh'
sh './run_test.sh'
}
}
node() {
checkout scm
stage('build the image') {
withDockerServer([credentialsId: 'jenkins-slave', uri:'tcp://${DOCKERHOST}:2376']) {
docker.build '${DOCKER_REGISTRY_USER}/rsvpapp:mooc'
}
}
stage('push the image to DockerHub') {
withDockerServer([credentialsId: 'jenkins-slave', uri: 'tcp://${DOCKERHOST}:2376'])
{
withDockerRegistry([credentialsId: 'dockerhub']) {
docker.image('${DOCKER_REGISTRY_USER}/rsvpapp:mooc').push()
}
}
}
stage('deploy the image to staging server') {
withDockerServer([credentialsId: 'staging-server', uri: 'tcp://${STAGING}:2376'])
{
sh 'docker-compose -p rsvp_staging up -d'
}
input 'Check application running at http://${STAGING}:5000 Looks good ?'
withDockerServer([credentialsId: 'staging-server', uri: 'tcp://${STAGING}:2376'])
{
sh 'docker-compose -p rsvp_staging down -v'
}
}
stage('deploy in production server') {
withDockerServer([credentialsId: 'production', uri: 'tcp://${PRODUCTION}:2376'])
{
sh 'docker stack deploy -c docker-stack.yaml myrsvpapp'
}
input 'Check application running at http://${PRODUCTION}:5000 Looks good ?'
withDockerServer([credentialsId: 'production', uri: 'tcp://${PRODUCTION}:2376'])
{
sh 'docker stack down myrsvpapp'
}
}
}
