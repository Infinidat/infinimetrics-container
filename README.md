# Self-Hosted InfiniMetrics deployment

Compose file and installation script to deploy containerized InfiniMetrics in a self-managed environment.

## Requirements

Name | Minimal requirement
--- | --- |
Docker | 20.10.18+	
Docker Compose | 2.17.0+	
Bash |
Container architecture | linux/x86_64

## Setup
### Installation / Upgrade

Clone the repository, check out to the correct version, and run:

```
./install.sh
```

You will be prompted to change the default installation parameters. Unless you are familiar with these configuration values, use the recommended ones.

After a successful installation, a command to start the InfiniMetrics compose app will be printed: 

```
docker compose --env-file .env --env-file .env.user up -d
```

To start the containers automatically following successful install/upgrade, run:

```
./install.sh --start-containers
```

### Install.sh usage

```
Usage: ./install.sh [options]

Install containerized InfiniMetrics in Self-Hosted environment.

Options:
 -h, --help           Show this message
 --noninteractive     Skip the interactive initialization prompt
 --start-containers   Start the containers automatically after install
 --skip-init          Skip database initialization/migration (not recommended)
```

### Custom .env.user file

The .env.user is automatically created during the installation. You may change and customize and it will not be overridden between installations/upgrades.

Attention: only  `.env.user` file is preserved between upgrades, while `.env` file is overridden.

## Misc

### Running InfiniMetrics CLI from containers

To run InfiniMetrics commands from containers, run:

    ./infinimetrics.sh [command]

### Backup and restore in a self-hosted environment

**Backup**

```
./infinimetrics.sh backup [<serial>...] [--from=FROM] > backup.tar.gz
```

**Restore**

The backup tar.gz file should be placed into data/tmp directory (in case the default data directory is different, look at the DATA_DIR variable inside .env.user). The following command will restore the file into InfiniMetrics, assuming that the name of the backup file is <backup.tar.gz>:
```
./infinimetrics.sh restore /tmp/infinimetrics/<backup.tar.gz>
```

Note: the path to the restore file must start with /tmp/infinimetrics so it can be found inside the container.


### Installing a custom SSL certificate

After an installation of self-hosted InfiniMetrics, it is possible to upload a custom SSL certificate.

1. Upload the certificate pem file from the InfiniMetrics UI
2. Restart the nginx container:
```
docker compose restart nginx
```

### Log collection

Logs collection is available both from UI and CLI.

In case of downloading from the UI, the compressed log file will be downloaded from the browser.

In case of collecting logs from CLI, the resulting file will be stored as compressed tar in data/tmp directory.

    ./infinimetrics.sh collect-logs --since <date>

In addition to the log tar file the output of docker_logs.sh scripts should be provided:

    ./docker_logs.sh --since <date>

While `<date>` is in the YYYY-MM-DD format. 
