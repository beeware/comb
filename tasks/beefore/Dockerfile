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

# Run the test
CMD ["/tools/run.sh"]
