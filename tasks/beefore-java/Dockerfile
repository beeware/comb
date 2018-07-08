# Use an official Python runtime as a parent image
FROM python:3.6.6-slim

# Set the working directory to a mountable /app directory
WORKDIR /app
VOLUME /app

# Get some core tools
RUN apt-get update
RUN apt-get install -y curl unzip apt-transport-https

# Copy the runtest script into the container
ADD tools /tools

# Slim variants don't have a man directory,
# which causes problems with update-alternatives
RUN mkdir -p /usr/share/man/man1

# Add Java and ant
RUN apt-get install -y openjdk-8-jdk-headless ant

# Run the test with a waggle report
CMD ["/tools/run.sh"]
