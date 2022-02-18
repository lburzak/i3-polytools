BUILD_DIR=build/bin
DART_COMPILE=dart compile exe
PACKAGES_ROOT=packages

$(shell mkdir -p $(BUILD_DIR))

i3_ping:
	$(DART_COMPILE) $(PACKAGES_ROOT)/$@/lib/main.dart -o $(BUILD_DIR)/$@

clean:
	rm -f