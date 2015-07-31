## Dev Env Config & Usage

### ngrok

One-time setup of ngrok authtoken for your env. Copy command from:

https://dashboard.ngrok.com/

Foe example,

```
ngrok authtoken xxx
```

### Running ngrok

```
ngrok http -bind-tls=true -subdomain=ronen 3000
```

Your locally running meteor app, listening on port 3000, will be accessible from the Internet at: https://ronen.ngrok.io/

-bind-tls=true forces ngrok to only listen on https, not http.
