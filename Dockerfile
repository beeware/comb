# Use the Beeware Python image as a starting point.
FROM pybee/py34

# Set the working directory to /app
WORKDIR /app

# Copy the runtest script into the container
ADD tools /tools

# Install XVFB
RUN apt-get install -y xvfb

# Install GTK+3 python bindings
RUN apt-get install -y python3-gi python3-gi-cairo gir1.2-gtk-3.0

# Install pygobject build dependencies
RUN apt-get install -y python3-dev libgirepository1.0-dev libcairo2-dev pkg-config

# `gi` is installed to /usr/lib/python3/dist-packages, which is not in the
# python path by default.
ENV PYTHONPATH=$PYTHONPATH:/usr/lib/python3/dist-packages/

# _gi.so must exist for `gi` to import correctly
RUN ln /usr/lib/python3/dist-packages/gi/_gi.*.so /usr/lib/python3/dist-packages/gi/_gi.so

# Run the tests
CMD ["/tools/run.sh"]
