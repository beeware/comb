# Use the BeeKeeper Python image as a starting point.
FROM beekeeper/py34

# Set the working directory to /app
WORKDIR /app

# Copy the runtest script into the container
ADD . /app

# Install GTK+3 python bindings
RUN apk add py3-gobject3

# Run the test with a waggle report
CMD ["./run.sh"]
