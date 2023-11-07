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

# To validate the DNS issues to kube internal pods, I've been running nginx
kubectl run nginx --image=nginx --restart=Never

# Will start an http server on port 8080
# Making a call to `/external` will make a GET requeset to https://example.com
# Making a call to `/internal` will make a GET request to `http://nginx`
# All other calls return `Hello World` 200
```
