# weave-service

[Setup your service](#setup-your-service)
[Available commands](#available-commands)

## Setup your service

- **Set your environment variables for each environment**

Modify default-env files for remote modifications

Modify root environment files for local modifications

## Available commands
**Execute from your service's root directory**

- **r | run**

*Starts the service*
```bash
./weave.sh r
```
Options:
* Development mode : -d|-dev

- **k | kill**

*Stops the service*
```bash
./weave.sh k
```
Options:
* Development mode : -d|-dev

- **log | log-available-ports**

*Logs the service's available ports*
```bash
./weave.sh log
```
Options:
* Development mode : -d|-dev

- **bak | backup-task**

*Executes the service's backup-task*
```bash
./weave.sh backup-task
```
Options:
* Development mode : -d|-dev
