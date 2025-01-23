# MetaTrader 5 in Docker

This repository provides a Docker-based setup to run MetaTrader 5 (MT5) on Ubuntu using Wine. The setup also includes Python bindings to interact with the MT5 terminal programmatically.

## Prerequisites

Make sure you have the following software installed on your system:

- [Docker](https://docs.docker.com/get-docker/)
- (Optional) [XQuartz](https://www.xquartz.org/) for GUI forwarding on macOS
- (Optional) An X server such as [VcXsrv](https://sourceforge.net/projects/vcxsrv/) for GUI forwarding on Windows

## Getting Started

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/your-repo/mt5-docker.git
cd mt5-docker
```

### 2. Build the Docker Image

Run the following command to build the Docker image:

```bash
docker build -t mt5_docker .
```

### 3. Run the Docker Container

Run the container using the following command:

```bash
docker run -it --rm mt5_docker
```

### 4. (Optional) GUI Forwarding for MT5

If you need to access the MetaTrader 5 graphical interface, ensure that an X server is running on your host machine and then use the following command:

#### On macOS:
1. Install [XQuartz](https://www.xquartz.org/) and enable "Allow connections from network clients" in the Security tab of XQuartz Preferences.
2. Run this command in your terminal before starting the container:
   ```bash
   xhost + 127.0.0.1
   ```
3. Start the container:
   ```bash
   docker run -it --rm -e DISPLAY=host.docker.internal:0 mt5_docker
   ```

#### On Windows:
1. Install and start [VcXsrv](https://sourceforge.net/projects/vcxsrv/).
2. Run the container with the following command:
   ```bash
   docker run -it --rm -e DISPLAY=<your_host_ip>:0 mt5_docker
   ```

Replace `<your_host_ip>` with the IP address of your host machine.

### 5. Persisting Data (Optional)

To save MetaTrader 5 settings, logs, or data outside of the container, map a volume to the container. For example:

```bash
docker run -it --rm -v $(pwd)/mt5_data:/root/.mt5 mt5_docker
```

This will store all MetaTrader 5 data in a local directory `mt5_data`.

---

## Dependencies

The following dependencies are installed inside the Docker container:

- **Ubuntu 20.04**: Base image for the container
- **Wine**: Compatibility layer for running Windows applications
- **Python 3**: Used for interacting with MetaTrader 5 programmatically
- **MetaTrader 5**: Trading platform
- **MetaTrader5 Python package**: Python library for MT5 API interaction
- **Xvfb**: Virtual framebuffer for GUI applications

---

## Using the Python Script

The container includes a sample Python script `run_mt5.py` that initializes MetaTrader 5 and shuts it down.

To modify the script, edit the `run_mt5.py` file in the repository before building the Docker image, or mount your script into the container like this:

```bash
docker run -it --rm -v $(pwd)/your_script.py:/opt/run_mt5.py mt5_docker
```

Replace `your_script.py` with the path to your Python script.

---

## Notes

1. **X Server for GUI**: If you do not need the GUI, you can skip the X server setup and simply use the Python API to interact with MT5.
2. **Wine Configuration**: During the first run, Wine might require additional setups like installing Mono or Gecko packages. The Dockerfile handles these automatically.
3. **Cross-Platform Compatibility**: This setup works on Linux, macOS, and Windows provided Docker is installed.

---

## Troubleshooting

- If the container fails to start with GUI support:
  - Ensure an X server is running on your host machine.
  - Make sure `DISPLAY` is set correctly.
- Check for Wine-related errors inside the container using:
  ```bash
  docker exec -it <container_id> winecfg
  ```

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.
