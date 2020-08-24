BUILD_DIR=./build

NIMBUS_DOCKER_IMAGE_NAME=beacon_chain_builder
NIMBUS_DOCKER_CONTAINER_NAME=beacon_chain_builder

ETH2STATS_DOCKER_IMAGE_NAME=eth2stats_builder
ETH2STATS_DOCKER_CONTAINER_NAME=eth2stats_builder

setup_build_folder:
	mkdir -p $(BUILD_DIR)

build_nimbus_docker_image:
	docker build --no-cache -t $(NIMBUS_DOCKER_IMAGE_NAME) -f docker/Dockerfile.nimbus docker

build_eth2stats_docker_image:
	docker build --no-cache -t $(ETH2STATS_DOCKER_IMAGE_NAME) -f docker/Dockerfile.eth2stats docker

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

step_01_setup_system:
	ansible-playbook -i inventory.yml -u root system/playbook.yml

step_02_mount_storage:
	ansible-playbook -i inventory.yml storage/playbook.yml

step_03_build_nimbus_docker_image: build_nimbus_docker_image

step_04_docker_build_nimbus: docker_build_nimbus

step_05_upload_nimbus_executable:
	ansible-playbook -i inventory.yml nimbus/playbook.yml --tags upload_exec

step_06_upload_keys:
	ansible-playbook -i inventory.yml nimbus/playbook.yml --tags upload_keys

step_07_setup_nimbus:
	ansible-playbook -i inventory.yml nimbus/playbook.yml --tags setup

step_08_import_keys:
	@echo "run this on the server:"
	@echo "sudo beacon_node deposits import  --data-dir=/var/nimbus/data/shared_medalla_0 /var/nimbus/validator_keys/"

step_09_run_nimbus:
	ansible-playbook -i inventory.yml nimbus/playbook.yml --tags run

step_10_build_eth2stats_docker_image: build_eth2stats_docker_image

step_11_docker_build_eth2stats: docker_build_eth2stats

step_12_upload_eth2stats_executable:
	ansible-playbook -i inventory.yml eth2stats/playbook.yml --tags upload_exec

step_13_run_eth2stats:
	ansible-playbook -i inventory.yml eth2stats/playbook.yml
