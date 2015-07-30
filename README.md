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
ngrok http -bind-tls=true -subdomain=ronen -key $HOME/.ngrok2/ngrok.key -crt $HOME/.ngrok2/ngrok.crt 3000

ngrok http -bind-tls=true -subdomain=ronen 3000
```

docker run -d --name ngrokd --restart=always -p 4480:4480 -p 4444:4444 -p 4443:4443 sequenceiq/ngrokd -httpAddr=:4480 -httpsAddr=:4444 -domain=ngrok.lavaina.com

Replace ronen with your dev env name.

Your locally running meteor app, listening on port 3000, will be accessible from the Internet at: https://ronen.ngrok.io/

-bind-tls=true forces ngrok to only listen on https, not http.
