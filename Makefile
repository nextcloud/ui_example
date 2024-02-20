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
	@echo "  run27             install UiExample for Nextcloud 27"
	@echo "  run28             install UiExample for Nextcloud 28"
	@echo "  run               install UiExample for Nextcloud Last"
	@echo "  "
	@echo "  For development of this example use PyCharm run configurations. Development is always set for last Nextcloud."
	@echo "  First run 'UiExample' and then 'make registerXX', after that you can use/debug/develop it and easy test."
	@echo "  "
	@echo "  register27        perform registration of running UiExample into the 'manual_install' deploy daemon."
	@echo "  register28        perform registration of running UiExample into the 'manual_install' deploy daemon."
	@echo "  register          perform registration of running UiExample into the 'manual_install' deploy daemon."
	@echo "  "
	@echo "  L10N (for manual translation):"
	@echo "  translation_templates      extract translation strings from sources"
	@echo "  convert_translations_nc    convert translations to Nextcloud format files (json, js)"
	@echo "  convert_to_locale    		copy translations to the common locale/<lang>/LC_MESSAGES/<appid>.(po|mo)"

.PHONY: build-push
build-push:
	docker login ghcr.io
	docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag ghcr.io/cloud-py-api/ui_example:latest .

.PHONY: run27
run27:
	docker exec master-stable27-1 sudo -u www-data php occ app_api:app:unregister ui_example --silent --force || true
	docker exec master-stable27-1 sudo -u www-data php occ app_api:app:register ui_example --force-scopes \
		--info-xml https://raw.githubusercontent.com/cloud-py-api/nc_py_api/main/examples/as_app/ui_example/appinfo/info.xml

.PHONY: run28
run28:
	docker exec master-stable28-1 sudo -u www-data php occ app_api:app:unregister ui_example --silent --force || true
	docker exec master-stable28-1 sudo -u www-data php occ app_api:app:register ui_example --force-scopes \
		--info-xml https://raw.githubusercontent.com/cloud-py-api/nc_py_api/main/examples/as_app/ui_example/appinfo/info.xml

.PHONY: run
run:
	docker exec master-nextcloud-1 sudo -u www-data php occ app_api:app:unregister ui_example --silent --force || true
	docker exec master-nextcloud-1 sudo -u www-data php occ app_api:app:register ui_example --force-scopes \
		--info-xml https://raw.githubusercontent.com/cloud-py-api/nc_py_api/main/examples/as_app/ui_example/appinfo/info.xml

.PHONY: register27
register27:
	docker exec master-stable27-1 sudo -u www-data php occ app_api:app:unregister ui_example --silent --force || true
	docker exec master-stable27-1 rm -rf /tmp/ui_example_l10n && docker cp l10n master-stable27-1:/tmp/ui_example_l10n
	docker exec master-stable27-1 sudo -u www-data php occ app_api:app:register ui_example manual_install --json-info \
  "{\"id\":\"ui_example\",\"name\":\"UI Example\",\"daemon_config_name\":\"manual_install\",\"version\":\"1.0.0\",\"secret\":\"12345\",\"port\":9035,\"scopes\":[],\"system_app\":0, \"translations_folder\":\"\/tmp\/ui_example_l10n\"}" \
  --force-scopes --wait-finish

.PHONY: register28
register28:
	docker exec master-stable28-1 sudo -u www-data php occ app_api:app:unregister ui_example --silent --force || true
	docker exec master-stable28-1 rm -rf /tmp/ui_example_l10n && docker cp l10n master-stable28-1:/tmp/ui_example_l10n
	docker exec master-stable28-1 sudo -u www-data php occ app_api:app:register ui_example manual_install --json-info \
  "{\"id\":\"ui_example\",\"name\":\"UI Example\",\"daemon_config_name\":\"manual_install\",\"version\":\"1.0.0\",\"secret\":\"12345\",\"port\":9035,\"scopes\":[],\"system_app\":0, \"translations_folder\":\"\/tmp\/ui_example_l10n\"}" \
  --force-scopes --wait-finish

.PHONY: register
register:
	docker exec master-nextcloud-1 sudo -u www-data php occ app_api:app:unregister ui_example --silent --force || true
	docker exec master-nextcloud-1 rm -rf /tmp/ui_example_l10n && docker cp l10n master-nextcloud-1:/tmp/ui_example_l10n
	docker exec master-nextcloud-1 sudo -u www-data php occ app_api:app:register ui_example manual_install --json-info \
  "{\"id\":\"ui_example\",\"name\":\"UI Example\",\"daemon_config_name\":\"manual_install\",\"version\":\"1.0.0\",\"secret\":\"12345\",\"port\":9035,\"scopes\":[\"NOTIFICATIONS\"],\"system_app\":0, \"translations_folder\":\"\/tmp\/ui_example_l10n\"}" \
  --force-scopes --wait-finish

.PHONY: translation_templates
translation_templates:
	./translationtool.phar create-pot-files

.PHONY: convert_translations_nc
convert_translations_nc:
	./translationtool.phar convert-po-files

.PHONY: convert_to_locale
convert_to_locale:
	./scripts/convert_to_locale.sh
