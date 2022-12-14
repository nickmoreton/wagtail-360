.PHONY: list
list:
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

migrate:
	@python testmanage.py migrate

admin:
	@echo "Creating superuser"
	@echo "from django.contrib.auth import get_user_model; get_user_model().objects.create_superuser('admin', '', 'admin')" | python testmanage.py shell

run:
	@python testmanage.py runserver 0.0.0.0:8000

test:
	@echo "Running tests..."
	@coverage run testmanage.py test --deprecation all
	@coverage report -m

lint:
	@echo "Running pre-commit hooks"
	@pre-commit run --all-files

load:
	@echo "Loading fixtures"
	@python testmanage.py loaddata fixtures/load.json

dump:
	@echo "Dumping fixtures"
	@python testmanage.py dumpdata  -e wagtailsearch --natural-foreign  --indent 2 > fixtures/dump.json
