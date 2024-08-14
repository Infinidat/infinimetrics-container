# InfiniMetrics in Docker

Compose file and installation script to deploy containerized InfiniMetrics in a self-managed environment.

## Requirements

Name | Minimal requirement
--- | --- |
Docker | 20.10.18+	
Docker Compose | 2.17.0+	
Bash |
Container architecture | linux/x86_64

## Setup
### Installation

Clone this repository, and then check out the correct git tag (e.g `git checkout <ver>`).

Then run:

```
./install.sh
```

You will be prompted to change the default installation parameters. Unless you are familiar with these configuration values, use the recommended ones.

Following a successful installation, a command to start the InfiniMetrics compose app will be printed: 

```
docker compose --env-file .env --env-file .env.user up -d
```

To start the containers automatically following successful install/upgrade, run:

```
./install.sh --start-containers
```

### Upgrade 

Fetch the changes from this repository (`git fetch --tags`), 

Checkout the new version (e.g `git checkout <ver>`) and run `./install.sh` again.

The remaining instructions to start the containers are the same as in the installation above.

### Install.sh usage

```
Usage: ./install.sh [options]

Install containerized InfiniMetrics in self-managed environment.

Options:
 -h, --help           Show this message
 --noninteractive     Skip the interactive initialization prompt
 --start-containers   Start the containers automatically following install
 --skip-init          Skip database initialization/migration (not recommended)
```

### Custom .env.user file

The .env.user is automatically created during the installation. You may change and customize it and it will not be overridden during installations/upgrades.

Attention: only  `.env.user` file is preserved during upgrades, while `.env` file is overridden.

## Misc

### Running InfiniMetrics CLI from containers

To run InfiniMetrics commands from containers, run:

    ./infinimetrics.sh [command]

### Backup and restore commands in InfiniMetrics

**Backup**

```
./infinimetrics.sh backup [<serial>...] [--from=FROM] > backup.tar.gz
```

**Restore**

The backup tar.gz file should be placed into data/tmp directory (in case the default data directory is different, look at the DATA_DIR variable inside .env.user). The following command will restore the file into InfiniMetrics. 

Example: (assuming that the name of the backup file is <backup.tar.gz>)
```
./infinimetrics.sh restore /tmp/infinimetrics/<backup.tar.gz>
```

**Note**: the path to the restore file must start with `/tmp/infinimetrics` so it can be found inside the container.


### Installing a custom SSL certificate

Following an installation, it is possible to upload a custom SSL certificate.

1. Upload the certificate pem file from the InfiniMetrics UI
2. Restart the nginx container:
```
docker compose restart nginx
```

### Log collection

Log collection is available from both the UI and CLI.

If you are downloading from the UI, the compressed log file will be downloaded from the browser.

If you are collecting logs from CLI, the resulting file will be stored as compressed tar in data/tmp directory.

    ./infinimetrics.sh collect-logs --since <date>

In addition to the log tar file, the output of docker_logs.sh scripts should be provided:

    ./docker_logs.sh --since <date>

Where `<date>` is in the YYYY-MM-DD format. 

## Offline installation

In case this compose suite is deployed in an environment without Internet access to the public DockerHub, first load the provided images by first executing:

    ./image_load.sh

Then proceed with `install.sh` instructions from above.
