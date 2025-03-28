# weave-application

**From application's root directory**

## Setup

```bash
cp .env.dist .env
```

**Setup services (see weave-service setup and commands)**

## Commands

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


# weave-service setup and commands
[Link to weave-service default README](../default-service/README.md)