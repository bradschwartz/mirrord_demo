# MirrordDemo

Demo app for debugging a few mirrord issues I ran into. The app is generic enough
to run on most Elixir versions, but you'll see different errors depending if you
run via an `asdf` shim or not.

## Running the App

```bash
# use asdf shim to reproduce broken pipe on shared FDs issue: https://github.com/metalbear-co/mirrord/issues/1966
asdf install
# use non-asdf version to reproduce errors around path
# I use brew to install elixir but ymmv
brew install elixir
export PATH=$(brew --prefix)/bin:$PATH # to put it before the asdf shim

mix deps.get
mix deps.compile
mix compile
mix run --no-halt

# For mirrord logs to show the trace error
MIX_DEBUG=1 MIRRORD_PROGRESS_MODE=off RUST_LOG=mirrord=trace MIRRORD_AGENT_TTL=120 RUST_BACKTRACE=1 mirrord exec -- mix run --no-halt

# Will start an http server on port 8080 that will respond hello world to all endpoints
# You can hit it with curl http://localhost:8080/hello
```
