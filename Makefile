BUILD_DIR=build/bin
DART_COMPILE=dart compile exe
PACKAGES_ROOT=packages
INSTALL_DIR=$(HOME)/bin

define compile_dart
	$(DART_COMPILE) $(PACKAGES_ROOT)/$(1)/lib/main.dart -o $(BUILD_DIR)/$(1)
endef

$(shell mkdir -p $(BUILD_DIR))

all: i3_ping i3_toggl

i3_ping i3_toggl:
	$(call compile_dart,$@)

i3_meetings: .client_id.local.json
	$(call compile_dart,$@) --define=CLIENT_ID=$(shell cat $^ | jq '.identifier'),CLIENT_SECRET=$(shell cat $^ | jq '.secret')

clean:
	rm -f $(wildcard $(BUILD_DIR)/*)

install:
	cp -rf $(wildcard $(BUILD_DIR)/*) $(INSTALL_DIR)