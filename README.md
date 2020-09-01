# Nimbus Deploy scripts.


Copy config.env.example to config.env and insert the variables values.

Copy inventory.yml.example to inventory.yml and set your server name.

## Requirements

* ansible installed in the local machine.
* a remote server with ubuntu.
* root access with ssh public key (put your local `~/.ssh/id_rsa.pub` in your remote `/root/.ssh/authorized_keys` file) to run the first step as root.

## Steps

### Step 1

`make step_01_setup_system`

It sets up the system creating a user with no password and the same username as the one used in local to run the script.
It uploads ~/.ssh/id_rsa.pub in ~/.ssh/authorized_keys.
It sets up a firewall allowing only ssh and port 9000 for nimbus.

### Step 2 (OPTIONAL)

Optional:

`make step_02_format_and_mount_storage`

or

`make step_02_only_mount_storage`

It creates a partition and mounts STORAGE_DEVICE_ID to /var/nimbus-storage.

### Step 3

`make step_03_build_nimbus_docker_image`

It builds a docker image used to build nimbus.

### Step 4

`make step_04_docker_build_nimbus`

It builds nimbus inside docker.

### Step 5

`make step_05_upload_nimbus_executable`

It uploads the nimbus executable.

### Step 6

`make step_06_setup_nimbus`

It creates a nimbus user used to run nimbus, and the folders in /var/nimbus-storage/nimbus.

### Step 7

`make step_07_upload_keys`

It uploads your validators keys. They must be in ./assets/validator_keys.

### Step 8

`make step_08_import_keys`

It prints what to run on the server to import your keys in nimbus.

### Step 9

`make step_09_remove_keys`

Removes the validator keys from the server.

### Step 10

`make step_10_run_nimbus`

It enables the systemd nimbus service.

### Step 11

`make step_11_build_eth2stats_docker_image`

It builds a docker image used to build eth2stats.

### Step 12

`make step_12_docker_build_eth2stats`

It builds eth2stats inside docker.

### Step 13

`make step_13_upload_eth2stats_executable`

It uploads the eth2stats executable.

### Step 14

`make step_14_run_eth2stats`

It runs eth2stats taking the node name from the NIMBUS_NODE_NAME env variable.
