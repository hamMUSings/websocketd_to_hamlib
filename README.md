# websocketd_to_hamlib Summary
Non-secure web-socket server on port 12020 to send commands to a remote hamlib rigctld server 

> [!WARNING]
> This is **ONLY** the communication translation an external rigctld server is REQUIRED
# Launch
```
docker compose up -d
```

## Optional
- Change the port in the [docker-compose.yaml](https://github.com/hamMUSings/websocketd_to_hamlib/blob/main/docker-compose.yaml)

# Usage
This runs a custom script that front ends sending commands via rigctl.  As websocketd doesn't have any authentication or anything this is relatively insecure method of creating a web-socket.  However,  the custom shell scripts adds a token amount of security as only the commands written into the script are executable via the web-socket command set. For example, only power off is exposed via this script as power on would be a larger security issue.

To use the following commands send them with a web socket client either in a browser or stand alone to
```
ws://IP:12020
```

# Command Set
The command set closely mimics hamlib commands to make it easier to understand and to use.  All web-socket commands start with 'hamlib' which tells websocketd to use to script for hamlib. It is possible to add more scripts with different prefixes.

It consists of 4 switches after hamlib
- -s : Hamlib Server IP/Host name (Optional: default is 127.0.0.1)
- -p : Hamlib Server Port (Optional: default is 4532)
- -a : Hamlib "Action" command (Required)
- -d : Data for action command if needed such as setting frequency data is the frequency to set it to

The hamlib actions are the same as the rigctl hamlib library commands.

## Command Structure

```
hamlib -s HAMLIB_SERVERIP -p HAMLIB_PORT -a HAMLIB_ACTION -d ACTION_DATA
```

## Action Commands Supported
### f, get_freq -- Will return the frequency the radio is tuned to

```
hamlib -s IP -p PORT -a f
```

### F, set_freq -- Sets frequency on the radio in Hz. Requires a data argument. Script only allows valid ham frequencies to be sent.

Example, to set the frequency to 10 MHz
```
hamlib -s IP -p PORT -a F -d 10000000
```

### t, get_ptt -- Returns the numeric code of the PTT status of the radio connected

```
hamlib -s IP -p PORT -a t
```

### T, set_ptt -- Sets the PTT status. Requires a data argument

- Supported Data arguments:
  - 0 : Off
  - 1 : On

Example. to set the PTT to off
```
hamlib -s IP -p PORT -a T -d 0
```

### m, get_mode -- Returns the mode the radio is set token

```
hamlib -s IP -p PORT -a m
```

### M, set_mode -- Sets the mode of the radio but only allows a subset of all options.  Requires a data option (All CAPS or all lowercase is supported)

Mode Options:
- USB or usb : Upper Side Band
- LSB or lsb : Lower Side Band
- FM or fm : Frequency Modulation

Exmaple, setting the radio to USB mode
```
hamlib -s IP -p PORT -a M -d USB
```

Also valid
```
hamlib -s IP -p PORT -a M -d usb
```

# Docker
Pre-Built docker container can be found [here](https://hub.docker.com/r/hammusings/websocketd_to_hamlib)
