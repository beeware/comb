# Use an official Python runtime as a parent image
FROM python:3.6.6-slim

# Copy the runtest script into the container
ADD tools /tools

# Set the working directory to a mountable /app directory
WORKDIR /app
VOLUME /app

# Get some core tools
RUN apt-get update
RUN apt-get install -y curl unzip

# Add the node package source and install nodejs
RUN curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
RUN chmod 755 nodesource_setup.sh
RUN ./nodesource_setup.sh
RUN apt-get install -y nodejs
RUN npm install npm

# Install node requirements
RUN cd /tools && npm install

# Run the test with a waggle report
CMD ["/tools/run.sh"]
