# Use a the beeware/beefore image as a starting point
FROM pybee/beefore

# Copy the runtest script into the container
ADD tools /tools

# Slim variants don't have a man directory,
# which causes problems with update-alternatives
RUN mkdir -p /usr/share/man/man1

# Add Java and ant
RUN apt-get install -y openjdk-8-jdk-headless ant

# Run the test with a waggle report
CMD ["/tools/run.sh"]
