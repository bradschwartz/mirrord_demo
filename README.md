# MirrordDemo

Demo app for debugging a few mirrord issues I ran into. The app is generic enough
to run on most Elixir versions.

## Bcrypt Module Not Loaded Error

To replicate, clone repo, download deps, but ensure no compilation artifacts are
on the filesystem:

```bash
mix deps.get
rm -rf _build
```

Start the app under mirrord, where it will compile under mirrord architecture.
Then, try to use the `:bcrypt_elixir` library to generate a salt and see it blow
up:

```bash
$ mirrord exec -- iex -S mix
## ... compiling logs
## relevant portion for compiling bcrypt:
==> bcrypt_elixir
mkdir -p "/Users/brad.schwartz/code/bradschwartz/mirrord_demo/_build/dev/lib/bcrypt_elixir/priv"
cc -g -O3 -Wall -Wno-format-truncation -I"/Users/brad.schwartz/.asdf/installs/erlang/25.3.2.2/erts-13.2.2.1/include" -Ic_src -fPIC -shared -dynamiclib -undefined dynamic_lookup c_src/bcrypt_nif.c c_src/blowfish.c -o "/Users/brad.schwartz/code/bradschwartz/mirrord_demo/_build/dev/lib/bcrypt_elixir/priv/bcrypt_nif.so"
warning: unknown warning option '-Wno-format-truncation' [-Wunknown-warning-option]
1 warning generated.
warning: unknown warning option '-Wno-format-truncation' [-Wunknown-warning-option]
1 warning generated.
Compiling 3 files (.ex)
Generated bcrypt_elixir app
...#
iex(1)> Bcrypt.Base.gen_salt(4)
```

That last command errors with:

```log
 Bcrypt.Base.gen_salt(4)

09:11:39.199 [error] Process #PID<0.1389.0> raised an exception
** (RuntimeError) An error occurred when loading Bcrypt.
Make sure you have a C compiler and Erlang 20 installed.
If you are not using Erlang 20, either upgrade to Erlang 20 or
use version 0.12 of bcrypt_elixir.
See the Comeonin wiki for more information.

    (bcrypt_elixir 3.1.0) lib/bcrypt/base.ex:15: Bcrypt.Base.init/0
    (kernel 8.5.4) code_server.erl:1317: anonymous fn/1 in :code_server.handle_on_load/5

09:11:39.206 [error] Process #PID<0.1391.0> raised an exception
** (RuntimeError) An error occurred when loading Bcrypt.
Make sure you have a C compiler and Erlang 20 installed.
If you are not using Erlang 20, either upgrade to Erlang 20 or
use version 0.12 of bcrypt_elixir.
See the Comeonin wiki for more information.

    (bcrypt_elixir 3.1.0) lib/bcrypt/base.ex:15: Bcrypt.Base.init/0
    (kernel 8.5.4) code_server.erl:1317: anonymous fn/1 in :code_server.handle_on_load/5

09:11:39.201 [warning] The on_load function for module Elixir.Bcrypt.Base returned:
{%RuntimeError{
   message: "An error occurred when loading Bcrypt.\nMake sure you have a C compiler and Erlang 20 installed.\nIf you are not using Erlang 20, either upgrade to Erlang 20 or\nuse version 0.12 of bcrypt_elixir.\nSee the Comeonin wiki for more information.\n"
 },
 [
   {Bcrypt.Base, :init, 0,
    [file: 'lib/bcrypt/base.ex', line: 15, error_info: %{...}]},
   {:code_server, :"-handle_on_load/5-fun-0-", 1,
    [file: 'code_server.erl', line: 1317]}
 ]}


09:11:39.209 [warning] The on_load function for module Elixir.Bcrypt.Base returned:
{%RuntimeError{
   message: "An error occurred when loading Bcrypt.\nMake sure you have a C compiler and Erlang 20 installed.\nIf you are not using Erlang 20, either upgrade to Erlang 20 or\nuse version 0.12 of bcrypt_elixir.\nSee the Comeonin wiki for more information.\n"
 },
 [
   {Bcrypt.Base, :init, 0,
    [file: 'lib/bcrypt/base.ex', line: 15, error_info: %{...}]},
   {:code_server, :"-handle_on_load/5-fun-0-", 1,
    [file: 'code_server.erl', line: 1317]}
 ]}

** (UndefinedFunctionError) function Bcrypt.Base.gen_salt/1 is undefined (module Bcrypt.Base is not available)
    (bcrypt_elixir 3.1.0) Bcrypt.Base.gen_salt(4)
```

## Running the App

```bash
# start the app locally
mix deps.get
mix deps.compile
mix compile
mix run --no-halt

# Run using mirrord
MIX_DEBUG=1 MIRRORD_PROGRESS_MODE=off RUST_LOG=mirrord=trace MIRRORD_AGENT_TTL=120 RUST_BACKTRACE=1 mirrord exec -- mix run --no-halt

# To validate the DNS issues to kube internal pods, I've been running nginx
kubectl run nginx --image=nginx --restart=Never

# Will start an http server on port 8080
# Making a call to `/external` will make a GET requeset to https://example.com
# Making a call to `/internal` will make a GET request to `http://nginx`
# All other calls return `Hello World` 200
```
