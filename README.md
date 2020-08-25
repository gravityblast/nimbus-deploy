# Nimbus Deploy scripts.


Copy config.env.example to config.env and insert the variables values.

Copy inventory.yml.example to inventory.yml and set your server name.

## Steps

`make step_01_setup_system`

It sets up the system creating a user with no password and the same username as the one used in local to run the script.
It uploads ~/.ssh/id_rsa.pub in ~/.ssh/authorized_keys.
It sets up a firewall allowing only ssh and port 9000 for nimbus.

`make step_02_mount_storage`

It creates a partition and mounts STORAGE_DEVICE_ID to /var/nimbus-storage.

`make step_03_build_nimbus_docker_image`

It builds a docker image used to build nimbus.

`make step_04_docker_build_nimbus`

It builds nimbus inside docker.

`make step_05_upload_nimbus_executable`

It uploads the nimbus executable.

`make step_06_setup_nimbus`

It creates a nimbus user used to run nimbus, and the folders in /var/nimbus-storage/nimbus.

`make step_07_upload_keys`

It uploads your validators keys. They must be in ./assets/validator_keys.

`make step_08_import_keys`

It prints what to run on the server to import your keys in nimbus.

`make step_09_run_nimbus`

It enables the systemd nimbus service.

`make step_10_build_eth2stats_docker_image`

It builds a docker image used to build eth2stats.

`make step_11_docker_build_eth2stats`

It builds eth2stats inside docker.

`make step_12_upload_eth2stats_executable`

It uploads the eth2stats executable.

`make step_13_run_eth2stats`

It runs eth2stats taking the node name from the NIMBUS_NODE_NAME env variable.
