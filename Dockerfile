# Use the Beeware Python image as a starting point.
FROM pybee/py37

# Copy the runtest script into the container
ADD tools /tools

# Install pytest and runners
RUN pip install pytest pytest-xdist pytest-tldr pytest-runner

# Slim variants don't have a man directory,
# which causes problems with update-alternatives
RUN mkdir -p /usr/share/man/man1

# Add Java, ant, and git
RUN apt-get install -y openjdk-11-jdk-headless ant git

# Run the test with a waggle report
CMD ["/tools/run.sh"]
