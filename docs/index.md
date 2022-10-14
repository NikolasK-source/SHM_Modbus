# Shared Memory Modbus Client Simulator

This project is a a collection of applications to simulate a Modbus TCP/RTU client. 

It contains the following tools:

- General Shared Memory Tools:
  - [Shared Memory Dump](https://nikolask-source.github.io/dump_shm/)
  - [Shared Memory Write](https://nikolask-source.github.io/write_shm/)
  - [Shared Memory Random](https://nikolask-source.github.io/shared_mem_random/)
- Modbus Clients:
  - [RTU](https://nikolask-source.github.io/modbus_rtu_client_shm/)
  - [TCP](https://nikolask-source.github.io/modbus_tcp_client_shm/)
- Modbus Shared Memory Tools:
  - [STDIN to Modbus SHM](https://nikolask-source.github.io/stdin_to_modbus_shm/)

In addition, a start script is included, which also provides a guided mode.

## Install

## Flapak
The application is available as flatpak and published on flathub as ```network.koesling.shm-modbus```.

The installation can be done with the following command: 
```
flatpak install network.koesling.shm-modbus
```

### Using the Arch User Repository (recommended for Arch based Linux distributions)
The application is available as [shm-modbus](https://aur.archlinux.org/packages/shm-modbus) in the [Arch User Repository](https://aur.archlinux.org/).
See the [Arch Wiki](https://wiki.archlinux.org/title/Arch_User_Repository) for information about how to install AUR packages.

Unlike the flatpak variant, no ```.desktop``` file is included in the AUR package.
It is therefore a terminal only application.


### Launch scripts
Since the execution of the individual tools via the flatpak is uncomfortable due to the long names, launch scripts are available.
- [Long commands](https://gist.github.com/NikolasK-source/cb6ce0dc20bb775e369e3a955967a969) ([zip download](https://gist.github.com/NikolasK-source/cb6ce0dc20bb775e369e3a955967a969/archive/ca0e97323feadad82a1063130b803ebee65dda20.zip))
- [Short commands](https://gist.github.com/NikolasK-source/1da665492478ad2e12f0495e8212f641) ([zip download](https://gist.github.com/NikolasK-source/1da665492478ad2e12f0495e8212f641/archive/e8d586d47328eb5f952746d5231eae4ff6bd0039.zip))

If these are stored in a directory that is in the PATH environment variable, they can be used to start the tools.

| Tool | Long Command | Short Command |
| - | - | - |
| Modbus TCP Client | modbus-tcp-client-shm | mbtcp |
| Modbus RTU Client | modbus-rtu-client-shm | mbrtu |
| STDIN to Modbus SHM | stdin-to-modbus-shm | stdin2mb |
| Shared Memory Dump | dump-shm | dshm |
| Shared Memory Write | write-shm | wshm |
| Shared Memory Random | shared-mem-random | shmrnd |

## Use

The primary use case of this application is the use of the individual tools from the command line.
A desktop launcher with a guided mode is available, but it only provides limited functionality.

Usage Examples (all examples assume that the lunch scripts (long commands) are installed.):
- [Modbus TCP client](examples/tcp_client.md)
- [Shared Memory Dump](examples/dump_shm.md)
- [Shared Memory Write](examples/write_shm.md)
- [Shared Memory Random](examples/shm_random.md)
- [STDIN to Modbus Shared Memory](examples/stdin_to_shm.md)

### Steps for Simulating a Modbus Client.

1. Start the appropriate Modbus client ([modbus-tcp-client-shm](https://nikolask-source.github.io/modbus_tcp_client_shm/) or [modbus-rtu-client-shm](https://nikolask-source.github.io/modbus_rtu_client_shm/)).
Information about the configuration of the clients can be found in their documentation.
([TCP](https://nikolask-source.github.io/modbus_tcp_client_shm/) / [RTU](https://nikolask-source.github.io/modbus_rtu_client_shm/))

2. Use the Tools to Read and Manipulate:
  - [dump-shm](https://nikolask-source.github.io/dump_shm/) can be used to read the content of a shared memory. 
  Especially useful in connection with ```hexdump```.
  - [write-shm](https://nikolask-source.github.io/write_shm/) can be used to write the content of a shared memory.
  - [shared-mem-random](https://nikolask-source.github.io/shared_mem_random/) is a tool to write random values to a shared memory
  - [stdin-to-modbus-shm](https://nikolask-source.github.io/stdin_to_modbus_shm/) is a tool to write values to the modbus registers. It can handle various data types and endiannes. 

## Common Problems
A list of common problems can be found [here](common_problems.md).

## License

MIT License

Copyright (c) 2022 Nikolas Koesling

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
