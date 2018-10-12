# Python for sysadmins

## Interesting modules from stdlib

### File system access

Overview: <https://docs.python.org/3/library/filesys.html>

- `os` [`module`](https://docs.python.org/3/library/os.html#files-and-directories)
  - `mkdir`, `chown`, `mkfifo`, `stat`, `getpid`, `getuid`, ...
  - [file descriptors](https://docs.python.org/3/library/os.html#file-descriptor-operations) **attn: `os.open('file')` != `open('file')`!**

- [`pathlib`](https://docs.python.org/3/library/pathlib.html): object-oriented filesystem paths

  ```pycon
  >>> p = PurePath('/usr/bin/python3')
  >>> p.parts
  ('/', 'usr', 'bin', 'python3')
  >>> p.root
  '/'
  >>> p.parent
  PurePosixPath('/usr/bin')

  >>> p = PureWindowsPath('c:/Program Files/PSF')
  >>> p.parts
  ('c:\\', 'Program Files', 'PSF')
  ```

- [`shutil`](https://docs.python.org/3/library/shutil.html): high-level filesystem operations (`copytree`)

  ```pycon
  >>> import os, stat, shutil, logging
  >>>
  >>> def remove_readonly(func, path, _):
  ...     "Clear the readonly bit and reattempt the removal"
  ...     os.chmod(path, stat.S_IWRITE)
  ...     func(path)
  >>>
  >>> shutil.rmtree(directory, onerror=remove_readonly)
  >>> shutil.copytree(source, destination, ignore=ignore_patterns('*.pyc', 'tmp*'))
  >>> archive_name = os.path.expanduser(os.path.join('~', 'myarchive'))
  >>> root_dir = os.path.expanduser(os.path.join('~', '.ssh'))
  >>> shutil.make_archive(archive_name, 'gztar', root_dir)
  '/Users/tarek/myarchive.tar.gz'
  >>>
  ```

- [`tempfile`](https://docs.python.org/3/library/tempfile.html) (see also: Linux `mktemp` command)

  ```pycon
  >>> import tempfile

  # create a temporary file and write some data to it
  >>> fp = tempfile.TemporaryFile()
  >>> fp.write(b'Hello world!')
  # read data from file
  >>> fp.seek(0)
  >>> fp.read()
  b'Hello world!'
  # close the file, it will be removed
  >>> fp.close()

  # create a temporary file using a context manager
  >>> with tempfile.TemporaryFile() as fp:
  ...     fp.write(b'Hello world!')
  ...     fp.seek(0)
  ...     fp.read()
  b'Hello world!'
  >>>
  # file is now closed and removed

  # create a temporary directory using the context manager
  >>> with tempfile.TemporaryDirectory() as tmpdirname:
  ...     print('created temporary directory', tmpdirname)
  >>>
  # directory and contents have been removed
  ```

- Unix-style **pathname patterns**
  - [`glob`](https://docs.python.org/3/library/glob.html) (pattern expansion)

  ```pycon
  >>> import glob
  >>> glob.glob('./[0-9].*')
  ['./1.gif', './2.txt']
  >>> glob.glob('*.gif')
  ['1.gif', 'card.gif']
  >>> glob.glob('?.gif')
  ['1.gif']
  >>> glob.glob('**/*.txt', recursive=True)
  ['2.txt', 'sub/3.txt']
  >>> glob.glob('./**/', recursive=True)
  ['./', './sub/']
  ```

  - ([`fnmatch`](https://docs.python.org/3/library/fnmatch.html) (pattern matching)

  ```pycon
  >>> import fnmatch, re, os
  >>>
  >>> for file in os.listdir('.'):
  ...     if fnmatch.fnmatch(file, '*.txt'):
  ...         print(file)
  ...
  text.txt
  book.txt
  >>>
  >>> regex = fnmatch.translate('*.txt')
  >>> regex
  '(?s:.*\\.txt)\\Z'
  >>> reobj = re.compile(regex)
  >>> reobj.match('foobar.txt')
  <re.Match object; span=(0, 10), match='foobar.txt'>
  ```

- low-level I/O streams: [`io`](https://docs.python.org/3/library/io.html)
  - `TextIO`, `BytesIO`, `BufferedStream`, `StringIO`

### Interacting with the OS

Overview (all platforms): <https://docs.python.org/3/library/allos.html>

- [`sys`](https://docs.python.org/3/library/sys.html) (stdin/out/err, platform, path, exit)

  ```python
  # All platforms
  sys.stdin, sys.stdout, sys.stderr               # = file-like objects (see module `io`)
  sys.argv                                        # command line arguments
  sys.exit(status_code)

  if sys.platform.startswith('linux'):
      # Linux-specific code here.
      sys.prefix
      sys.ps1, sys.ps2
  elif sys.platform.startswith('windows'):
      # Windows-specific code here.
      sys.winver                                  # version for registry keys
      sys.getwindowsversion()                     # windows version
  if sys.platform.startswith('freebsd'):
      # FreeBSD-specific code here...

  # Python specifics & internals
  sys.version, sys.hexversion, sys.version_info   # python version
  sys.modules, sys.path                           # python loaded modules & search path
  sys.settrace()                                  # trace your calls for debugging
  sys.exc_info()                                  # check exception details
  ```

  - (current) process parameters (uid, gid, env, uname, pid, fd, ...): <https://docs.python.org/3/library/os.html#process-parameters>
  - process management (kill, fork, nice, ...): <https://docs.python.org/3/library/os.html#process-management>
  - system [`info`](https://docs.python.org/3/library/os.html#miscellaneous-system-information)
  - capture [`signals`](https://docs.python.org/3/library/signal.html)
  - platform [`info`](https://docs.python.org/3/library/platform.html)
  - logging (syslog, NTEvents, UDP, HTTP, SMTP, ...): <https://docs.python.org/3/library/logging.handlers.html>

- executing other processes:
  - [`subprocess`](https://docs.python.org/3/library/subprocess.html)
    - [`subprocess.Popen`](https://docs.python.org/3/library/subprocess.html#popen-constructor) (capture output/exit code, send signal, communicate, ... )

    ```python
    import subprocess, signal

    proc = subprocess.Popen(args, bufsize=-1, executable=None, stdin=None, stdout=None, stderr=None, preexec_fn=None, close_fds=True, shell=False, cwd=None, env=None, universal_newlines=False, startupinfo=None, creationflags=0, restore_signals=True, start_new_session=False, pass_fds=(), *, encoding=None, errors=None, text=None)

    try:
        outs, errs = proc.communicate(timeout=15)
        proc.send_signal(signal)
        pid = proc.pid
        proc.wait(timeout=10)
        status = proc.returncode
    except TimeoutExpired:
        proc.kill()
        outs, errs = proc.communicate()
    ```

  - [`arguments`](https://docs.python.org/3/library/shlex.html): correct argument splitting and **`shlex.quote(s)` to prevent code injection!**

    ```pycon
    >>> filename = 'somefile; rm -rf ~'
    >>> command = 'ls -l {}'.format(filename)
    >>> print(command)  # executed by a shell: boom!
    ls -l somefile; rm -rf ~
    >>>
    >>> # quote() lets you plug the security hole:
    >>> from shlex import quote
    >>> command = 'ls -l {}'.format(quote(filename))
    >>> print(command)
    ls -l 'somefile; rm -rf ~'
    >>>
    >>> remote_command = 'ssh home {}'.format(quote(command))
    >>> print(remote_command)
    ssh home 'ls -l '"'"'somefile; rm -rf ~'"'"''
    >>>
    >>> # split command arguments for correct interpretation
    >>> from shlex import split
    >>> remote_command = split(remote_command)
    >>> remote_command
    ['ssh', 'home', "ls -l 'somefile; rm -rf ~'"]
    >>> command = split(remote_command[-1])
    >>> command
    ['ls', '-l', 'somefile; rm -rf ~']
    ```

  - POSIX standard error codes: [`erno`](https://docs.python.org/3/library/errno.html)

    ```pycon
    >>> import errno
    >>> "; ".join(f"{value} = {key}" for key, value in errno.errorcode.items())
    'ENODEV = 19; ENOCSI = 50; EHOSTUNREACH = 113; ENOMSG = 42; EUCLEAN = 117; EL2NSYNC = 45; EL2HLT = 51; ENODATA = 61;
    [...]
    ```

- internet & protocols:

- IPv4/v6 addressing: [`ipaddress` module](https://docs.python.org/3/library/ipaddress.html)

```pycon
>>> # IPv4/v6
>>> ipaddress.ip_address('192.168.0.1')
IPv4Address('192.168.0.1')
>>> ipaddress.ip_address('2001:db8::')
IPv6Address('2001:db8::')
>>>
>>> # networks & subnets
>>> ipaddress.ip_network('192.168.0.0/28')
IPv4Network('192.168.0.0/28')
>>> ipaddress.IPv4Address('192.168.0.1')
IPv4Address('192.168.0.1')
>>> ipaddress.IPv4Address(3232235521)
IPv4Address('192.168.0.1')
>>> ipaddress.IPv4Address(b'\xC0\xA8\x00\x01')
IPv4Address('192.168.0.1')
>>> list(ip_network('192.0.2.0/29').hosts())  #doctest: +NORMALIZE_WHITESPACE
[IPv4Address('192.0.2.1'), IPv4Address('192.0.2.2'),
 IPv4Address('192.0.2.3'), IPv4Address('192.0.2.4'),
 IPv4Address('192.0.2.5'), IPv4Address('192.0.2.6')]
>>> list(ip_network('192.0.2.0/31').hosts())
[IPv4Address('192.0.2.0'), IPv4Address('192.0.2.1')]
>>> list(ip_network('192.0.2.0/24').subnets())
[IPv4Network('192.0.2.0/25'), IPv4Network('192.0.2.128/25')]
>>> list(ip_network('192.0.2.0/24').subnets(prefixlen_diff=2))  #doctest: +NORMALIZE_WHITESPACE
[IPv4Network('192.0.2.0/26'), IPv4Network('192.0.2.64/26'),
 IPv4Network('192.0.2.128/26'), IPv4Network('192.0.2.192/26')]
>>> list(ip_network('192.0.2.0/24').subnets(new_prefix=26))  #doctest: +NORMALIZE_WHITESPACE
[IPv4Network('192.0.2.0/26'), IPv4Network('192.0.2.64/26'),
 IPv4Network('192.0.2.128/26'), IPv4Network('192.0.2.192/26')]
>>> list(ip_network('192.0.2.0/24').subnets(new_prefix=23))
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
    raise ValueError('new prefix must be longer')
ValueError: new prefix must be longer
>>> list(ip_network('192.0.2.0/24').subnets(new_prefix=25))
[IPv4Network('192.0.2.0/25'), IPv4Network('192.0.2.128/25')]
>>> ip_network('192.0.2.0/24').supernet()
IPv4Network('192.0.2.0/23')
>>> ip_network('192.0.2.0/24').supernet(prefixlen_diff=2)
IPv4Network('192.0.0.0/22')
>>> ip_network('192.0.2.0/24').supernet(new_prefix=20)
IPv4Network('192.0.0.0/20')

>>>
>>> # str/int conversion
>>> str(ipaddress.IPv4Address('192.168.0.1'))
'192.168.0.1'
>>> int(ipaddress.IPv4Address('192.168.0.1'))
3232235521
>>> str(ipaddress.IPv6Address('::1'))
'::1'
>>> int(ipaddress.IPv6Address('::1'))
1
>>>
>>> # compare & compute
>>> IPv4Address('127.0.0.2') > IPv4Address('127.0.0.1')
True
>>> IPv4Address('127.0.0.2') == IPv4Address('127.0.0.1')
False
>>> IPv4Address('127.0.0.2') != IPv4Address('127.0.0.1')
True
>>> IPv4Address('127.0.0.2') + 3
IPv4Address('127.0.0.5')
>>> IPv4Address('127.0.0.2') - 3
IPv4Address('126.255.255.255')
>>> IPv4Address('255.255.255.255') + 1
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ipaddress.AddressValueError: 4294967296 (>= 2**32) is not permitted as an IPv4 address
>>> a = ip_network('192.168.1.0/24')
>>> b = ip_network('192.168.1.128/30')
>>> b.subnet_of(a)
True
>>> ip_network('192.0.2.1/32').compare_networks(ip_network('192.0.2.2/32'))
-1
>>> ip_network('192.0.2.1/32').compare_networks(ip_network('192.0.2.0/32'))
1
>>> ip_network('192.0.2.1/32').compare_networks(ip_network('192.0.2.1/32'))
0
>>> for addr in IPv4Network('192.0.2.0/28'):
...     addr
...
IPv4Address('192.0.2.0')
IPv4Address('192.0.2.1')
IPv4Address('192.0.2.2')
IPv4Address('192.0.2.3')
IPv4Address('192.0.2.4')
[...]
>>> IPv4Network('192.0.2.0/28')[0]
IPv4Address('192.0.2.0')
>>> IPv4Network('192.0.2.0/28')[15]
IPv4Address('192.0.2.15')
>>> IPv4Address('192.0.2.6') in IPv4Network('192.0.2.0/28')
True
>>> IPv4Address('192.0.3.6') in IPv4Network('192.0.2.0/28')
False
>>>
>>> # PTR records
>>> ipaddress.ip_address("127.0.0.1").reverse_pointer
'1.0.0.127.in-addr.arpa'
>>> ipaddress.ip_address("2001:db8::1").reverse_pointer
'1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa'
>>>
>>> # Interface objects
>>> interface = IPv4Interface('192.0.2.5/24')
>>> interface.ip
IPv4Address('192.0.2.5')
>>> interface = IPv4Interface('192.0.2.5/24')
>>> interface.network
IPv4Network('192.0.2.0/24')
```

- HTTP, FTP, SMTP, ... are included in *stdlib*: <https://docs.python.org/3/library/internet.html>
- data formats (email/mime, base64, binascii, uuencode...):  <https://docs.python.org/3/library/netdata.html>
- SSH: [`paramiko` library](http://docs.paramiko.org/en/2.4/) (low-ish level), [`fabric` library](http://www.fabfile.org/) builds on top
- DNS: [`dnspython` library](http://www.dnspython.org/)
- [`LDAP`](https://www.python-ldap.org/en/latest/)
- raw TCP/UDP [`socket`](https://docs.python.org/3/library/socket.html), <https://docs.python.org/3/library/socketserver.html>
- scapy (pkt manipulation): <https://scapy.readthedocs.io/en/latest/usage.html>

### network devices

- SNMP: [`PySNMP`](http://snmplabs.com/pysnmp/examples/contents.html), <https://easysnmp.readthedocs.io/en/latest/> <https://github.com/aswinvk28/snmp-mininet>
- NETCONF: [`nccclient`](https://pypi.org/project/ncclient/)
- RESTCONF (or any other ReST API): [`requests`](http://docs.python-requests.org/en/master/) - HTTP requests for humans (*TM)
- YANG: [cisco `ydk` library](https://developer.cisco.com/site/ydk/)
- check out the [`cisco sample code`](https://github.com/CiscoDevNet/python_code_samples_network)

### Misc tools

- output/reporting: pprint, formatter, tablib, textile, gdchart/matplotlib, ...
- [unix specific services](https://docs.python.org/3/library/unix.html) 
- [windows specific](https://docs.python.org/3/library/windows.html)
- *[`zip`](https://docs.python.org/3/library/archiving.html)

### User interfaces

- [`interactive`](https://docs.python.org/3/library/cmd.html)
- cmd [`args`](https://docs.python.org/3/library/argparse.html) 
- [`curses`](https://docs.python.org/3/library/curses.html), <https://docs.python.org/3/howto/curses.html> 
- readline, getpass, textwrap, ...
- GUI: tkinter, wxpython

## Further reading/watching

- <https://app.pluralsight.com/library/courses/python-linux-system-administrators/table-of-contents\>
- <https://docs.python-guide.org/scenarios/admin/>

## Exercises

- Read PuTTY configs --> read & update .vscode settings.json
- Make script that can be used in a pipe