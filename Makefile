.DEFAULT_GOAL := help

help:
	@echo "Available commands:"
	@echo "  make setup                 Prepare development environment"
	@echo "  make lint                  Run ShellCheck"
	@echo "  make sysinfo               Show system information"
	@echo "  make train                 Run training"
	@echo "  make cleanup KEEP=N        Remove checkpoints, keep N latest"
	@echo "  make clean                 Remove generated files"	

setup:
	@./scripts/setup.sh
lint:
	@shellcheck scripts/*.sh
sysinfo:
	@./scripts/sysinfo.sh
train:
	@./scripts/train.sh
# cleanup:
# 	@./cleanup.sh $(KEEP)

clean:
	@rm -rf logs/*
	@rm -rf checkpoints/*
	@echo "Cleaned logs and checkpoints."