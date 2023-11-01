# MirrordDemo

Demo app for debugging a few mirrord issues I ran into. The app is generic enough
to run on most Elixir versions.

## Running the App

```bash
# start the app locally
mix deps.get
mix deps.compile
mix compile
mix run --no-halt

# Run using mirrord
MIX_DEBUG=1 MIRRORD_PROGRESS_MODE=off RUST_LOG=mirrord=trace MIRRORD_AGENT_TTL=120 RUST_BACKTRACE=1 mirrord exec -- mix run --no-halt

# Will start an http server on port 8080
# Making a call to `/external` will make a GET requeset to https://example.com
# when running under mirrord this will fail with:
## erl_child_setup: failed with error 9 on line 208
# before panicking
# All other endpoints return Hello world as plain text
```
