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

# Add the node package source and install nodejs
RUN cd /tools && \
    apt-get install -y gnupg && \
    curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh && \
    chmod 755 nodesource_setup.sh && \
    ./nodesource_setup.sh && \
    apt-get install -y nodejs

# Install npm and the beefore javascript dependencies
RUN cd /tools && \
    npm install -g npm && \
    npm install -g

# Run the test with a waggle report
CMD ["/tools/run.sh"]
