# Use a the beeware/beefore image as a starting point
FROM pybee/beefore

# Copy the runtest script into the container
ADD tools /tools

# Add the node package source and install nodejs
RUN cd /tools && \
    apt-get install -y gnupg && \
    curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh && \
    chmod 755 nodesource_setup.sh && \
    ./nodesource_setup.sh && \
    apt-get install -y nodejs

# Install npm and the beefore javascript dependencies
RUN cd /tools && \
    npm install -g npm && \
    npm install -g

# Run the test with a waggle report
CMD ["/tools/run.sh"]
