BUILD_DIR=build/bin
DART_COMPILE=dart compile exe
PACKAGES_ROOT=packages
INSTALL_DIR=$(HOME)/bin

define compile_dart
	$(DART_COMPILE) $(PACKAGES_ROOT)/$(1)/lib/main.dart -o $(BUILD_DIR)/$(1)
endef

define read_env
$(shell cat $(1) | tr '\n' ',')
endef

$(shell mkdir -p $(BUILD_DIR))

all: i3_ping i3_toggl

i3_ping:
	$(call compile_dart,$@)

i3_toggl: i3_toggl.env
	$(call compile_dart,$@) --define=$(call read_env,$^)

i3_meetings: i3_meetings.env
	$(call compile_dart,$@) --define=$(call read_env,$^)

clean:
	rm -f $(wildcard $(BUILD_DIR)/*)

install:
	cp -rf $(wildcard $(BUILD_DIR)/*) $(INSTALL_DIR)