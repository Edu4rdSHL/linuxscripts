If you receive messages about an undefined reference to `__onexitbegin` or something similar, you may have an older version of crt2.o, instead of the version that ming has available to it.

Try this in your terminal and see if it helps:

```bash
$ cd ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-pc-windows-gnu/lib/
$ mv crt2.o crt2.o.bak
$ cp /usr/x86_64-w64-mingw32/lib/crt2.o ./
```
