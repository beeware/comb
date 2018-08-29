# Use the beeware Python 3.6 image as a starting point.
FROM pybee/py36

# Copy the runtest script into the container
ADD tools /tools

# Get some core tools
RUN apt-get install -y git

# Install beefore
RUN pip install beefore==0.2.1

# Run the test
CMD ["/tools/run.sh"]
