BUILD_DIR=./build
DOCKER_IMAGE_NAME=beacon_chain_builder
DOCKER_CONTAINER_NAME=beacon_chain_builder

build_docker_image:
	docker build --no-cache -t $(DOCKER_IMAGE_NAME) docker

setup_build_folder:
	mkdir -p $(BUILD_DIR)

docker_build_nimbus: setup_build_folder
	docker run --rm \
		--name $(DOCKER_CONTAINER_NAME) \
		-v $$(pwd)/$(BUILD_DIR):/nimbus/build \
		$(DOCKER_IMAGE_NAME)

kill_docker_container:
	docker kill $(DOCKER_CONTAINER_NAME)

step_1_setup_system:
	ansible-playbook -i inventory.yml -u root setup/playbook.yml

step_2_build_docker_image: build_docker_image

step_3_docker_build_nimbus: docker_build_nimbus

step_4_upload_executable:
	ansible-playbook -i inventory.yml nimbus/playbook.yml --tags upload_exec

step_5_upload_keys:
	ansible-playbook -i inventory.yml nimbus/playbook.yml --tags upload_keys

step_6_setup_nimbus:
	ansible-playbook -i inventory.yml nimbus/playbook.yml --tags setup

step_7_import_keys:
	@echo "run this on the server:"
	@echo "sudo beacon_node deposits import  --data-dir=/var/nimbus/data/shared_medalla_0 /var/nimbus/validator_keys/"

step_8_run_nimbus:
	ansible-playbook -i inventory.yml nimbus/playbook.yml --tags run
