# Use the official Ubuntu base image
FROM ubuntu:20.04

# Set environment variable to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update the system and install required dependencies
RUN apt-get update && apt-get install -y \
    wget \
    xvfb \
    wine \
    winbind \
    unzip \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Add support for i386 architecture and install wine32
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y wine32

# Download MetaTrader 5 installation script from the official website
RUN wget https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5ubuntu.sh \
    && chmod +x mt5ubuntu.sh \
    && ./mt5ubuntu.sh

# Copy a custom Python script for interacting with MetaTrader 5
COPY run_mt5.py /opt/run_mt5.py

# Set the working directory inside the container
WORKDIR /opt

# Install the MetaTrader5 Python package
RUN pip3 install --no-cache-dir MetaTrader5

# Expose the display environment for GUI applications
ENV DISPLAY=:0
EXPOSE 5900

# Set the default command to initialize and interact with MetaTrader 5
CMD ["xvfb-run", "python3", "run_mt5.py"]
