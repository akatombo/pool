# component-skeleton - 0.1.0

# CONFIGURATION
COMPONENT_NAME = component-name
STANDALONE_VARIABLE = ComponentName

DEVELOPEMENT_MODE = true
MOCHA_REPORTER = spec


# TASKS - do not update this :P
all: build

# build component with defined mode
build: components
ifeq ($(DEVELOPEMENT_MODE),true)
	@echo "building in development mode ..."
	@./node_modules/.bin/component build \
		--name $(COMPONENT_NAME) \
		--standalone $(STANDALONE_VARIABLE) \
		--dev
else
	@echo "building ..."
	@./node_modules/.bin/component build \
		--name $(COMPONENT_NAME) \
		--standalone $(STANDALONE_VARIABLE)
endif
	@echo "build done."


# Install component dependencies
components:
	@./node_modules/.bin/component install \
		--dev

# Alias for components	
install: components

# Build component and run Mocha tests
test: build test-without-build

# Just run Mocha tests
test-without-build:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--require should \
		--reporter $(MOCHA_REPORTER) \
		--timeout 2000 \
		--compilers ls:LiveScript \
		test/*.ls

# Remove build and components folders
clean:
	@rm -fr build components

watch:
	@./node_modules/.bin/lsc \
		--compile --watch src \
		--output lib \

.PHONY: build test clean