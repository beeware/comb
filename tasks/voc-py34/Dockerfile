# Use the BeeKeeper Python image as a starting point.
FROM beekeeper/py34

# Set the working directory to /app
WORKDIR /app

# Copy the runtest script into the container
ADD . /app

# Add Java and ant
RUN apt-get install -y default-jdk ant

# Run the test with a waggle report
CMD ["./run.sh"]
