# Use an official Python runtime as a parent image
FROM python:3.6-slim

# Set the working directory to /app
WORKDIR /app

# Copy the runtest script into the container
ADD . /app

# Get some core tools
RUN apt-get update
RUN apt-get install -y curl unzip

# Add Java and ant
RUN apt-get install -y default-jdk ant

# Run the test
CMD ["./run.sh"]
