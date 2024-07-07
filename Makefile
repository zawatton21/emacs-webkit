LIBS = gtk+-3.0 webkit2gtk-4.0
CFLAGS = -std=c99 -Wall -Wextra -Wno-unused-parameter -fpic
CFLAGS += `pkg-config --cflags $(LIBS)`

# Platform-specific settings
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    CC = gcc
    LDFLAGS += -Wl,--no-as-needed
    TARGET = webkit-module.so
else ifeq ($(UNAME_S),Darwin)
    CC = gcc-14
    TARGET = webkit-module.dylib
endif
LDFLAGS += `pkg-config --libs $(LIBS)`

all: $(TARGET)

debug: CFLAGS += -DDEBUG -g
debug: $(TARGET)

$(TARGET): webkit-module.c
	$(CC) -shared $(CFLAGS) $(LDFLAGS) -o $@ $^

clean:
	$(RM) webkit-module.so webkit-module.dylib

.PHONY: clean all debug
