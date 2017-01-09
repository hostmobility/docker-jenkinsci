Docker image extending the official Jenkins docker image 

## Build/run
To build the image, simply invoke

	docker build -t hostmobility/jenkinsci \
		github.com/hostmobility/docker-jenkinsci

And to run it

	docker run -p 8080:8080 -p 50000:50000 \
		-v /home/builder/jenkins_home/:/var/jenkins_home \
		-v ~/.ssh:/var/jenkins_home/.ssh \
		hostmobility/jenkinsci

