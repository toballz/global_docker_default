# Global Docker Workspace

This directory contains scripts and utilities for managing Docker and Docker Compose builds across projects.

## Files Included

* **`docker-build-compose.bat`**: A Windows batch script that acts as a convenient launcher. It triggers the Linux bash script (`docker-build-compose.sh`) within the WSL environment and pauses the terminal upon completion so you can easily review the console output.
* **`docker-build-compose.sh`**: The main shell script that handles the actual Docker Compose build logic.



## Usage

* **Edit docker-build-compose.sh**: Edit param <STAGE=dev|prod>.
* ./docker-build-compose.sh for linux || docker-build-compose.bat for windows


