# Installation & Usage Guide

## Prerequisites

### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install -y build-essential libgtk-4-dev libcurl4-openssl-dev libjson-c-dev lua5.1-dev
```

### Fedora/RHEL
```bash
sudo dnf install -y gcc gtk4-devel libcurl-devel json-c-devel lua-devel
```

### Arch Linux
```bash
sudo pacman -S base-devel gtk4 curl json-c lua5.1
```

## Building from Source

### Option 1: Using the build script (Recommended)
```bash
git clone https://github.com/gitwab/Wineblox-executor.git
cd Wineblox-executor
chmod +x build.sh
./build.sh
```

### Option 2: Using make directly
```bash
git clone https://github.com/gitwab/Wineblox-executor.git
cd Wineblox-executor
make check-deps
make
```

### Option 3: Manual compilation
```bash
gcc -Wall -Wextra -fPIC -D_GNU_SOURCE -O2 -shared injected_lib.c -o sober_test_inject.so -ldl `pkg-config --cflags --libs lua5.1`
gcc -Wall -Wextra -fPIC -D_GNU_SOURCE -O2 Injector.c -o injector -ldl
gcc -Wall -Wextra -fPIC -D_GNU_SOURCE -O2 `pkg-config --cflags gtk4 libcurl json-c` AtingleUI_Enhanced.c -o atingle `pkg-config --libs gtk4 libcurl json-c` -lpthread
```

## Running the Executor

### 1. Start ROBLOX on Wine
```bash
WINEPREFIX=~/.wine wine ~/.wine/drive_c/Program\ Files/Roblox/Versions/*/RobloxPlayerBeta.exe
```

### 2. Inject the executor (in another terminal)
```bash
# Auto-detect ROBLOX process
sudo ./injector sober

# Or specify PID manually
sudo ./injector <PID> ./sober_test_inject.so

# Or use custom library path
sudo ./injector sober /path/to/sober_test_inject.so
```

### 3. Open the UI (optional)
```bash
./atingle_enhanced
```

## Troubleshooting

### "PTRACE_ATTACH failed: Operation not permitted"
- Run with `sudo`: `sudo ./injector sober`
- Check ptrace_scope: `cat /proc/sys/kernel/yama/ptrace_scope`
- If set to 2 or 3, temporarily allow it:
  ```bash
  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
  ```

### "Process 'sober' not found"
- Ensure ROBLOX is running on Wine before injecting
- Use Process ID method instead: `sudo ./injector $(pgrep -f RobloxPlayerBeta)`

### "Cannot find libc.so.6" or "Cannot find libdl.so.2"
- Check if system libraries are accessible
- Run: `ldd /proc/$(pgrep -f RobloxPlayerBeta)/exe`

### Injection appears to work but nothing happens
- Check injector output for errors (run with `strace -e trace=ptrace`)
- Verify Lua library is correctly built: `ldd ./sober_test_inject.so`

## Build Targets

```bash
make all              # Build everything
make atingle_enhanced # Enhanced UI only
make injector         # Injector only
make sober_test_inject.so  # Library only
make check-deps       # Verify dependencies
make clean            # Remove built files
make help             # Show all targets
```

## Security Notes

- This tool requires elevated privileges (`sudo`) to attach to processes
- Only use on systems you own or have permission to modify
- The injection technique uses `ptrace()` which may be detected by anticheat systems

## Contributing

Found a bug? Submit an issue or PR to help improve this project!
