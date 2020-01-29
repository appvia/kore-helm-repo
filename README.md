### Kore Helm Repo

This repository will build a Helm Repository (http server) from a list of charts and supplimental values and templates specific to Kore clusters (e.g. application resources for monitoring).

The charts are listed in the file `charts.txt` in the format:
```
chartrepo/name:version
chartrepo2/anothertname2:version
```

#### Build

Run `make build` to build locally or simply `make docker` to build in docker.

#### Details

Each chart will be fetched from upstream and repackaged using any updates specified.

The build will fail if an `application` resource Kind has not been specified for a chart. Currently these have to be specified in the `charts-updates/[chart-name-version]/templates/*.yaml`.

Kore-Keeper will monitor all `Application` resources with the correct labels for cluster health.

#### TODO:

1. Build `Application` resources automatically from chart files (we have all the info in the `Chart.yaml` files and the resource types in the `templates` folders).
1. Productionise / use other http server.
1. Add FROM action to make this a re-usable resource (provide you own charts.txt).