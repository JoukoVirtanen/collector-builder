BASE_PATH = .
include Makefile-constants.mk


.PHONY: builder
builder:
	docker build \
		--cache-from quay.io/stackrox-io/collector-builder:cache \
		--cache-from quay.io/stackrox-io/collector-builder:$(COLLECTOR_BUILDER_TAG) \
		-t quay.io/stackrox-io/collector-builder:$(COLLECTOR_BUILDER_TAG) \
		-f "$(CURDIR)/builder/Dockerfile" \
		.

.PHONY: shfmt-check
shfmt-check:
	shfmt -d $(CURDIR)

.PHONY: shfmt-format
shfmt-format:
	shfmt -w $(CURDIR)

.PHONY: shellcheck-all
shellcheck-all:
	./utilities/shellcheck-all/shellcheck-all.sh

.PHONY: shellcheck-all-dockerized
shellcheck-all-dockerized:
	docker build -t shellcheck-all $(CURDIR)/utilities/shellcheck-all
	docker run --rm -v "$(CURDIR):/scripts" shellcheck-all:latest

