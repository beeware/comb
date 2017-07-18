# Use an official Python runtime as a parent image
FROM python:3.6-slim

# Set the working directory to /app
WORKDIR /app

# Copy the runtest script into the container
ADD . /app

# Get some core tools
RUN apt-get update && apt-get install -y curl unzip apt-transport-https

# Install docker
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-engine
RUN service docker start

# Run the waggler
CMD ["./run.sh"]
