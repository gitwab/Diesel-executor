CC = gcc
CFLAGS = -Wall -Wextra -fPIC -D_GNU_SOURCE
GTK_CFLAGS = $(shell pkg-config --cflags gtk4)
GTK_LIBS = $(shell pkg-config --libs gtk4)
LUA_CFLAGS = $(shell pkg-config --cflags lua5.1 2>/dev/null || pkg-config --cflags lua 2>/dev/null)
LUA_LIBS = $(shell pkg-config --libs lua5.1 2>/dev/null || pkg-config --libs lua 2>/dev/null)

all: atingle injector sober_test_inject.so

# Main UI executable
atingle: AtingleUI.c
	$(CC) $(CFLAGS) $(GTK_CFLAGS) AtingleUI.c -o atingle $(GTK_LIBS) -lpthread

# Injector executable
injector: Injector.c
	$(CC) $(CFLAGS) Injector.c -o injector -ldl

# Shared library to inject
sober_test_inject.so: injected_lib.c init.lua
	$(CC) $(CFLAGS) -shared injected_lib.c $(LUA_CFLAGS) -o sober_test_inject.so $(LUA_LIBS) -ldl

clean:
	rm -f atingle injector sober_test_inject.so *.o

.PHONY: all clean
