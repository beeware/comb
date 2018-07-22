# Use the Beeware Python image as a starting point.
FROM pybee/py34

# Copy the runtest script into the container
ADD tools /tools

# Install pytest and runners
RUN pip install pytest pytest-xdist pytest-runner pytest-tldr

# Slim variants don't have a man directory,
# which causes problems with update-alternatives
RUN mkdir -p /usr/share/man/man1

# Add Java and ant
RUN apt-get install -y openjdk-8-jre-headless ant

# Run the test with a waggle report
CMD ["/tools/run.sh"]
