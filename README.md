Docker image extending the official Jenkins docker image 

## Build/run
To build the image, simply invoke

	docker build -t hostmobility/jenkinsci \
		github.com/hostmobility/docker-jenkinsci

And to run it

	docker run -e JENKINS_OPTS="--httpPort=8888 --httpsPort=-1" \
		-p 8888:8888 \
		-p 50000:50000 \
		--privileged \
		-v /home/builder/jenkins_home/:/var/jenkins_home \
		-v ~/.ssh:/var/jenkins_home/.ssh \
		-v /media/jenkins:/media/jenkins \
		-v /media/storage_hdd/jenkins:/media/storage/jenkins \
		hostmobility/jenkinsci
