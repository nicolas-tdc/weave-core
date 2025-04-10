# weave-service

[Setup your service](#setup-your-service)
[Available commands](#available-commands)

## Setup your service

- Copy environment file

*Execute from your service's root directory*
```bash
cp .env.dist .env
```

- Set environment variables: edit copied .env file

## Available commands
**Execute from your service's root directory**

- r | run

*Starts the service*
```bash
./weave.sh r
```
Options:
* Development mode : -d|-dev

- k | kill

*Stops the service*
```bash
./weave.sh k
```
Options:
* Development mode : -d|-dev

- log | log-available-ports

*Logs the service's available ports*
```bash
./weave.sh log
```
Options:
* Development mode : -d|-dev

- upd | update
```bash
./weave.sh upd
```
Options:
* Development mode : -d|-dev

- bak | backup-task

*Executes the service's backup-task*
```bash
./weave.sh backup-task
```
Options:
* Development mode : -d|-dev
