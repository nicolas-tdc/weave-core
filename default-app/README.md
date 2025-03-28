# weave-application

## Setup

- Copy environment file

**From application's root directory**
```bash
cp .env.dist .env
```

- Set environment variables: edit copied .env file

- Setup services: see instructions found in README.md files of your added services

[See weave-service default setup and commands](./weave/default-service/README.md)

## Commands
**From application's root directory**

- Start application
```bash
./weave.sh start
```

- Stop application
```bash
./weave.sh stop
```

- Update application
```bash
./weave.sh update
```

- Add services to application
```bash
./weave.sh add-services
```

- Execute application's backup-task
```bash
./weave.sh backup-task
```

- Enable cron for backup task
```bash
./weave.sh backup-enable
```

- Disable cron for backup task
```bash
./weave.sh backup-disable
```
