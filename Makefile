BUILD_DIR=build/bin
DART_COMPILE=dart compile exe
PACKAGES_ROOT=packages
INSTALL_DIR=$(HOME)/bin

$(shell mkdir -p $(BUILD_DIR))

all: i3_ping i3_toggl

i3_ping i3_toggl:
	$(DART_COMPILE) $(PACKAGES_ROOT)/$@/lib/main.dart -o $(BUILD_DIR)/$@

clean:
	rm -f $(wildcard $(BUILD_DIR)/*)

install:
	cp -rf $(wildcard $(BUILD_DIR)/*) $(INSTALL_DIR)