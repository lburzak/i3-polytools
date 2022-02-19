BUILD_DIR=build/bin
DART_COMPILE=dart compile exe
PACKAGES_ROOT=packages

$(shell mkdir -p $(BUILD_DIR))

all: i3_ping i3_toggl

i3_ping i3_toggl:
	$(DART_COMPILE) $(PACKAGES_ROOT)/$@/lib/main.dart -o $(BUILD_DIR)/$@

clean:
	rm -f