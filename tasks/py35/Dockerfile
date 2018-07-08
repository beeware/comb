# Use an official Python runtime as a parent image
FROM python:3.5.5-slim

# Copy the runtest script into the container
ADD tools /tools

# Set the working directory to a mountable /app directory
WORKDIR /app
VOLUME /app

# Get some core tools
RUN apt-get update && apt-get install -y curl unzip apt-transport-https

# Run the test with a waggle report
CMD ["/tools/run.sh"]
