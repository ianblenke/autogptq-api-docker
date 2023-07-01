# autogptq-api-docker

This is a docker-compose with Dockerfile for running autogptq-api from here:

- https://github.com/mzbac/AutoGPTQ-API

To use, run:

	make

This will run the docker-compose commands in the `Makefile` and spin up a container.

This will automatically download and run the model:

- https://huggingface.co/TheBloke/WizardCoder-15B-1.0-GPTQ

This is the suggested way of running the API server for:

- https://github.com/mzbac/wizardCoder-vsc

After which you can point the WizardCoder Visual Studio Code extention at:

- http://localhost:5000

