# Nested Makefile for Flutter and Shorebird commands

# Default target
.DEFAULT_GOAL := help

# Helper target
help:
	@echo "Available commands:"
	@echo "  make run-dev               - Run Flutter in development mode"
	@echo "  make run-prod              - Run Flutter in production mode"
	@echo "  make deploy-ios    - Deploy to iOS using Shorebird"
	@echo "  make deploy-ios-patch    - Deploy to iOS using Shorebird Patch"
	@echo ""
	@echo "The -v flag is mandatory for deploy commands. Example:"

# Nested run commands
run:
	@echo "Please specify 'dev' or 'prod'"

run-dev:
	flutter run -t lib/main_dev.dart --flavor development

run-prod:
	flutter run -t lib/main_prod.dart --flavor production

deploy-ios:
	shorebird release ios --target ./lib/main_prod.dart --flavor production

deploy-ios-patch:
	shorebird patch --platforms=ios --flavor=production --target=./lib/main_prod.dart


.PHONY: help run run-dev run-prod deploy deploy-ios deploy-patch