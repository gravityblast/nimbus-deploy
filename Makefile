# Copy config.env.example to config.env and insert the variables values.
# Copy inventory.yml.example to inventory.yml and set your server name.

include config.env

BUILD_DIR=./build

NIMBUS_DOCKER_IMAGE_NAME=beacon_chain_builder
NIMBUS_DOCKER_CONTAINER_NAME=beacon_chain_builder

ETH2STATS_DOCKER_IMAGE_NAME=eth2stats_builder
ETH2STATS_DOCKER_CONTAINER_NAME=eth2stats_builder

config:
ifndef NIMBUS_NODE_NAME
	$(error NIMBUS_NODE_NAME is undefined)
endif

setup_build_folder:
	mkdir -p $(BUILD_DIR)

build_nimbus_docker_image:
	docker build --no-cache -t $(NIMBUS_DOCKER_IMAGE_NAME) docker/nimbus

build_eth2stats_docker_image:
	docker build --no-cache -t $(ETH2STATS_DOCKER_IMAGE_NAME) docker/eth2stats

docker_build_nimbus: setup_build_folder
	docker run --rm \
		--name $(NIMBUS_DOCKER_CONTAINER_NAME) \
		-v $$(pwd)/$(BUILD_DIR):/nimbus/build \
		$(NIMBUS_DOCKER_IMAGE_NAME)

docker_build_eth2stats: setup_build_folder
	docker run --rm \
		--name $(ETH2STATS_DOCKER_CONTAINER_NAME) \
		-v $$(pwd)/$(BUILD_DIR):/eth2stats/build \
		$(ETH2STATS_DOCKER_IMAGE_NAME)

kill_docker_container:
	docker kill $(NIMBUS_DOCKER_CONTAINER_NAME)

# It sets up the system creating a user with no password and the same username as the one used in local to run the script.
# It uploads ~/.ssh/id_rsa.pub in ~/.ssh/authorized_keys.
# It sets up a firewall allowing only ssh and port 9000 for nimbus.
step_01_setup_system: config
	ansible-playbook -i inventory.yml -u root ansible/system/playbook.yml

# It creates a partition and mounts STORAGE_DEVICE_ID to /var/nimbus-storage.
step_02_format_and_mount_storage: config
	ansible-playbook -i inventory.yml ansible/storage/playbook.yml

step_02_only_mount_storage: config
	ansible-playbook -i inventory.yml ansible/storage/playbook.yml --tags mount

# It builds a docker image used to build nimbus.
step_03_build_nimbus_docker_image: config build_nimbus_docker_image

# It builds nimbus inside docker.
step_04_docker_build_nimbus: config docker_build_nimbus

# It uploads the nimbus executable.
step_05_upload_nimbus_executable: config
	ansible-playbook -i inventory.yml ansible/nimbus/playbook.yml --tags upload_exec

# It creates a nimbus user used to run nimbus, and the folders in /var/nimbus-storage/nimbus.
step_06_setup_nimbus: config
	ansible-playbook -i inventory.yml ansible/nimbus/playbook.yml --tags setup

# It uploads your validators keys. They must be in ./assets/validator_keys.
step_07_upload_keys: config
ifeq ($(wildcard ./assets/validator_keys),)
	$(error "the ./assets/validator_keys folder must exist")
endif
	ansible-playbook -i inventory.yml ansible/nimbus/playbook.yml --tags upload_keys

# It prints what to run on the server to import your keys in nimbus.
step_08_import_keys: config
	@echo "run this on the server with your nimbus user:"
	@echo "beacon_node deposits import  --data-dir=/var/nimbus-storage/nimbus/data/shared_medalla_0 /var/nimbus-storage/nimbus/validator_keys/"

# Removes the validator keys from the server.
step_09_remove_keys: config
	ansible-playbook -i inventory.yml ansible/nimbus/playbook.yml --tags remove_keys

# It enables the systemd nimbus service.
step_10_run_nimbus: config
	ansible-playbook -i inventory.yml ansible/nimbus/playbook.yml --tags run

# It builds a docker image used to build eth2stats.
step_11_build_eth2stats_docker_image: config build_eth2stats_docker_image

# It builds eth2stats inside docker.
step_12_docker_build_eth2stats: config docker_build_eth2stats

# It uploads the eth2stats executable.
step_13_upload_eth2stats_executable: config
	ansible-playbook -i inventory.yml ansible/eth2stats/playbook.yml --tags upload_exec

# It runs eth2stats taking the node name from the NIMBUS_NODE_NAME env variable.
step_14_run_eth2stats: config
	ansible-playbook -i inventory.yml ansible/eth2stats/playbook.yml
