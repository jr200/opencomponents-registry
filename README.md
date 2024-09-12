# opencomponents-registry-chart

Helm chart to deploy an opencomponents registry to a kubernetes cluster with s3 (non-aws/minio) support.

opencomponents requires server encryption to be enabled on the s3 bucket. This means you will need to at least configure minio with a static KMS key.

## Installation

First configure an empty s3 bucket. e.g.,

```
s3cmd mb --bucket-location=us-east-1 s3://oc-registry/
```

_note: on minio, I also had to manually set the encryption for the bucket to SSE-KMS via the UI_

```
echo '[]' > components.json && \
s3cmd put ./components.json s3://oc-registry/components/components.json && \
rm components.json
```

Setup the appropriate config options in the `values.yaml`, and install using helm.

```
helm repo add jr200 https://jr200.github.io/helm-charts/
helm repo update
helm install -f values.yaml my-oc-registry jr200/opencomponents-registry
```

# Helm Chart Values Configuration

| Key                           | Type     | Default                                          | Description                                             |
| ----------------------------- | -------- | ------------------------------------------------ | ------------------------------------------------------- |
| `devDebug`                    | `bool`   | `false`                                          | Puts main container in infinite sleep allowing _exec_.  |
| `config.envFilePaths`         | `array`  | `["/usr/src/app/.env", "/var/run/secrets/.env"]` | Paths to environment variable files sourced on startup. |
| `config.publishAuth.enabled`  | `bool`   | `false`                                          | Enable authentication for publishing components.        |
| `config.publishAuth.username` | `string` | `publisher`                                      | Username for publishing.                                |
| `config.publishAuth.password` | `string` | `publisher`                                      | Password for publishing.                                |
| `config.baseUrl`              | `string` | `https://oc-registry.example.com`                | Base URL for the registry.                              |
| `config.componentsDir`        | `string` | `components`                                     | Directory to store components in the registry.          |
| `config.s3.debug`             | `bool`   | `true`                                           | Enable debug mode for S3 configuration.                 |
| `config.s3.ssl`               | `bool`   | `true`                                           | Enable SSL for S3 connections.                          |
| `config.s3.forcePathStyle`    | `bool`   | `true`                                           | Enable path-style S3 requests.                          |
| `config.s3.bucket`            | `string` | `oc-registry`                                    | Name of the S3 bucket.                                  |
| `config.s3.region`            | `string` | `us-east-1`                                      | S3 bucket region.                                       |
| `config.s3.path`              | `string` | `//s3.example.com/oc-registry/`                  | S3 path to the bucket.                                  |
| `config.s3.endpoint`          | `string` | `https://s3.example.com`                         | Custom S3 endpoint URL.                                 |
| `config.s3.secret.enabled`    | `bool`   | `false`                                          | Enable S3 secrets for access key and secret key.        |
| `config.s3.secret.access_key` | `string` | `~`                                              | S3 access key.                                          |
| `config.s3.secret.secret_key` | `string` | `~`                                              | S3 secret key.                                          |

The registry can be exposed using the usual kubernetes options.

| Key                                  | Type     | Default                  | Description                     |
| ------------------------------------ | -------- | ------------------------ | ------------------------------- |
| `service.type`                       | `string` | `ClusterIP`              | Type of service.                |
| `service.port`                       | `int`    | `80`                     | Port for the service to expose. |
| `ingress.enabled`                    | `bool`   | `false`                  | Enable or disable ingress.      |
| `ingress.className`                  | `string` | `""`                     | Ingress class name.             |
| `ingress.annotations`                | `object` | `{}`                     | Annotations for the ingress.    |
| `ingress.hosts[0].host`              | `string` | `chart-example.local`    | Host for the ingress.           |
| `ingress.hosts[0].paths[0].path`     | `string` | `/`                      | Path for the ingress.           |
| `ingress.hosts[0].paths[0].pathType` | `string` | `ImplementationSpecific` | Path type for the ingress.      |
| `ingress.tls`                        | `array`  | `[]`                     | TLS settings for ingress.       |

# References

- opencomponents: https://opencomponents.github.io/
- minio kms: https://min.io/docs/minio/linux/reference/minio-server/settings/kes.html
