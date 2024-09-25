# InfiniMetrics in Docker

Compose file and installation script to deploy containerized InfiniMetrics in a self-managed environment

## Requirements

Name | Minimal requirement
--- | --- |
Docker | 20.10.18	
Docker Compose | 2.17.0
Bash |
Container architecture | linux/x86_64

## Installation

Clone the repository:
```
git clone https://github.com/Infinidat/infinimetrics-container.git
```

List the versions available:
```
git tag
```

Check out the version you want to install:
```
git checkout <version, e.g. 7.0.0>
```

Install InfiniMetrics and start the containers:
```
./install.sh --start-containers
```

You are prompted to change the default installation parameters. Unless you are familiar with these parameters, use the recommended values.

Following a successful installation, a command to start the InfiniMetrics compose app is printed.

InfiniMetrics is set to start automatically with the Docker engine. 

### Manual Installation

If you prefer, you can install InfiniMetrics and not have it start automatically:

```
./install.sh
```

Start InfiniMetrics manually:

```
docker compose --env-file .env --env-file .env.user up -d
```

## Upgrade 

Fetch the changes from the repository:

```
git fetch --tags
```

List the versions available:
```
git tag
```

Check out the version you want to upgrade to:
```
git checkout <version, e.g. 7.0.0>
```

Stop the current containers, upgrade InfiniMetrics, and start the upgraded containers:
```
./install.sh --start-containers
```

### Manual Upgrade

If you prefer, you can upgrade InfiniMetrics and not have it start automatically after the upgrade:

```
./install.sh
```

Start InfiniMetrics manually after the upgrade:

```
docker compose --env-file .env --env-file .env.user up -d
```
## Install.sh usage

```
Usage: ./install.sh [options]

Install containerized InfiniMetrics in a self-managed environment.

Options:
 -h, --help           Show this message
 --noninteractive     Skip the interactive initialization prompt
 --start-containers   Start the containers automatically following install
 --skip-init          Skip database initialization/migration (not recommended)
```

## Custom .env.user file

The .env.user file is automatically created during the installation. You can change and customize it. It will not be overwritten during installations/upgrades.

Attention: Only the `.env.user` file is preserved during upgrades. The `.env` file is always overwritten.

## Misc

### Running InfiniMetrics CLI from containers

To run InfiniMetrics commands from containers:

    ./infinimetrics.sh [command]

### Backup and restore commands in InfiniMetrics

You can back up and restore the data collected by InfiniMetrics in order to move them between deployments, or just to perform backup for the data collected by InfiniMetrics.

**Backup**

```
./infinimetrics.sh backup [<serial>...] [--from=FROM] > backup.tar.gz
```

**Restore**

Normally, the backup tar.gz file will be written to the data/tmp directory. If the default data directory is different, refer to the DATA_DIR variable inside .env.user.
The following command will restore the file into InfiniMetrics.

Example: (assuming that the name of the backup file is <backup.tar.gz>)
```
./infinimetrics.sh restore /tmp/infinimetrics/<backup.tar.gz>
```

**Note**: The path to the restore file must start with `/tmp/infinimetrics` so that it can be found inside the container.


### Installing a custom SSL certificate

Following installation, you can upload a custom SSL certificate.

1. Upload the certificate pem file from the InfiniMetrics UI.
2. Restart the nginx container:
```
docker compose restart nginx
```

### Log collection

Log collection is available from both the UI and the CLI.

If you are downloading from the UI, the compressed log file will be downloaded from the browser.

If you are collecting logs from the CLI, the resulting file will be stored as compressed tar in the data/tmp directory.

    ./infinimetrics.sh collect-logs --since <date>

In addition to the log tar file, also provide the output of docker_logs.sh scripts:

    ./docker_logs.sh --since <date>

Where `<date>` is in YYYY-MM-DD format. 

## Offline installation

In case this compose suite is deployed in an environment without Internet access to the public DockerHub, first load the provided images by first executing:

    ./image_load.sh

Then proceed with `install.sh` instructions from above.
