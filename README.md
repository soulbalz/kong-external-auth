# Kong External Auth

Kong plugin to authenticate requests using http services.

## Description

This plugin lets you authenticate any request using a separate HTTP service.

For every incoming request are forwarded to the auth service.

If the service returns `200`, the request continues the normal path.
In any other case, `401` (Unauthorized) is returned to the client.
