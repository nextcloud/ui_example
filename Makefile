.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "Welcome to UiExample example. Please use \`make <target>\` where <target> is one of"
	@echo " "
	@echo "  Next commands are only for dev environment with nextcloud-docker-dev!"
	@echo "  They should run from the host you are developing on(with activated venv) and not in the container with Nextcloud!"
	@echo "  "
	@echo "  build-push        build image and upload to ghcr.io"
	@echo "  "
	@echo "  run30             install UiExample for Nextcloud 30"
	@echo "  run31             install UiExample for Nextcloud 31"
	@echo "  run               install UiExample for Nextcloud Last"
	@echo "  "
	@echo "  For development of this example use PyCharm run configurations. Development is always set for last Nextcloud."
	@echo "  First run 'UiExample' and then 'make registerXX', after that you can use/debug/develop it and easy test."
	@echo "  "
	@echo "  register30        perform registration of running UiExample into the 'manual_install' deploy daemon."
	@echo "  register31        perform registration of running UiExample into the 'manual_install' deploy daemon."
	@echo "  register          perform registration of running UiExample into the 'manual_install' deploy daemon."
	@echo "  "
	@echo "  L10N (for manual translation):"
	@echo "  translation_templates      extract translation strings from sources"
	@echo "  convert_translations_nc    convert translations to Nextcloud format files (json, js)"
	@echo "  compile_po_to_mo           compile po files to mo files"
	@echo "  copy_translations    		copy translations to the common locale/<lang>/LC_MESSAGES/<appid>.(po|mo)"

.PHONY: build-push
build-push:
	docker login ghcr.io
	docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag ghcr.io/nextcloud/ui_example:latest .

.PHONY: run30
run30:
	docker exec master-stable30-1 sudo -u www-data php occ app_api:app:unregister ui_example --silent --force || true
	docker exec master-stable30-1 sudo -u www-data php occ app_api:app:register ui_example \
		--info-xml https://raw.githubusercontent.com/nextcloud/ui_example/refs/heads/main/appinfo/info.xml

.PHONY: run31
run31:
	docker exec master-stable31-1 sudo -u www-data php occ app_api:app:unregister ui_example --silent --force || true
	docker exec master-stable31-1 sudo -u www-data php occ app_api:app:register ui_example \
		--info-xml https://raw.githubusercontent.com/nextcloud/ui_example/refs/heads/main/appinfo/info.xml

.PHONY: run
run:
	docker exec master-nextcloud-1 sudo -u www-data php occ app_api:app:unregister ui_example --silent --force || true
	docker exec master-nextcloud-1 sudo -u www-data php occ app_api:app:register ui_example \
		--info-xml https://raw.githubusercontent.com/nextcloud/ui_example/refs/heads/main/appinfo/info.xml

.PHONY: register30
register30:
	docker exec master-stable30-1 sudo -u www-data php occ app_api:app:unregister ui_example --silent --force || true
	docker exec master-stable30-1 rm -rf /tmp/ui_example_l10n && docker cp l10n master-stable30-1:/tmp/ui_example_l10n
	docker exec master-stable30-1 sudo -u www-data php occ app_api:app:register ui_example manual_install --json-info \
  "{\"id\":\"ui_example\",\"name\":\"UI Example\",\"daemon_config_name\":\"manual_install\",\"version\":\"1.0.0\",\"secret\":\"12345\",\"port\":9035, \"translations_folder\":\"\/tmp\/ui_example_l10n\", \"routes\": [{\"url\":\"img\\\/.*\",\"verb\":\"GET, POST, PUT, DELETE\",\"access_level\":1,\"headers_to_exclude\":[]},{\"url\":\"js\\\/.*\",\"verb\":\"GET, POST, PUT, DELETE\",\"access_level\":1,\"headers_to_exclude\":[]}, {\"url\":\"css\\\/.*\",\"verb\":\"GET, POST, PUT, DELETE\",\"access_level\":1,\"headers_to_exclude\":[]}, {\"url\":\"api\\\/.*\",\"verb\":\"GET, POST, PUT, DELETE\",\"access_level\":1,\"headers_to_exclude\":[]}]}" \
  --wait-finish

.PHONY: register31
register31:
	docker exec master-stable31-1 sudo -u www-data php occ app_api:app:unregister ui_example --silent --force || true
	docker exec master-stable31-1 rm -rf /tmp/ui_example_l10n && docker cp l10n master-stable31-1:/tmp/ui_example_l10n
	docker exec master-stable31-1 sudo -u www-data php occ app_api:app:register ui_example manual_install --json-info \
  "{\"id\":\"ui_example\",\"name\":\"UI Example\",\"daemon_config_name\":\"manual_install\",\"version\":\"1.0.0\",\"secret\":\"12345\",\"port\":9035, \"translations_folder\":\"\/tmp\/ui_example_l10n\", \"routes\": [{\"url\":\"img\\\/.*\",\"verb\":\"GET, POST, PUT, DELETE\",\"access_level\":1,\"headers_to_exclude\":[]},{\"url\":\"js\\\/.*\",\"verb\":\"GET, POST, PUT, DELETE\",\"access_level\":1,\"headers_to_exclude\":[]}, {\"url\":\"css\\\/.*\",\"verb\":\"GET, POST, PUT, DELETE\",\"access_level\":1,\"headers_to_exclude\":[]}, {\"url\":\"api\\\/.*\",\"verb\":\"GET, POST, PUT, DELETE\",\"access_level\":2,\"headers_to_exclude\":[]}]}" \
  --wait-finish

.PHONY: register
register:
	docker exec master-nextcloud-1 sudo -u www-data php occ app_api:app:unregister ui_example --silent --force || true
	docker exec master-nextcloud-1 rm -rf /tmp/ui_example_l10n && docker cp l10n master-nextcloud-1:/tmp/ui_example_l10n
	docker exec master-nextcloud-1 sudo -u www-data php occ app_api:app:register ui_example manual_install --json-info \
  "{\"id\":\"ui_example\",\"name\":\"UI Example\",\"daemon_config_name\":\"manual_install\",\"version\":\"1.0.0\",\"secret\":\"12345\",\"port\":9035, \"translations_folder\":\"\/tmp\/ui_example_l10n\", \"routes\": [{\"url\":\"img\\\/.*\",\"verb\":\"GET, POST, PUT, DELETE\",\"access_level\":1,\"headers_to_exclude\":[]},{\"url\":\"js\\\/.*\",\"verb\":\"GET, POST, PUT, DELETE\",\"access_level\":1,\"headers_to_exclude\":[]}, {\"url\":\"css\\\/.*\",\"verb\":\"GET, POST, PUT, DELETE\",\"access_level\":1,\"headers_to_exclude\":[]}, {\"url\":\"api\\\/.+\",\"verb\":\"GET, POST, PUT, DELETE\",\"access_level\":1,\"headers_to_exclude\":[]}]}" \
  --wait-finish

.PHONY: translation_templates
translation_templates:
	./translationtool.phar create-pot-files

.PHONY: convert_translations_nc
convert_translations_nc:
	./translationtool.phar convert-po-files

compile_po_to_mo:
	bash ./scripts/compile_po_to_mo.sh

.PHONY: copy_translations
copy_translations:
	bash ./scripts/copy_translations.sh
