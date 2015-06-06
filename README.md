# CoreOS Cluster
CoreOS Cluster including:
* coreos beta
* etcd
* consul
* service registrator
* google cloud provider

## Setup
* Create a Google Cloud Account
* Create a new token at https://discovery.etcd.io/new?size=3 and replace on `cloud-config-master.yaml`:
```
    discovery: https://discovery.etcd.io/your_token_here
```
* Log into https://console.developers.google.com/ and go to `APIs & auth > Credentials`. Click on `Create a new OAuth client ID` and select "Service account". Save the downloaded file as `gce_account.json` in the same dir of this project.
* Run
```
terraform apply
```

## TODO
* Add [consul](http://consul.io/)
* Add a service discover registrator
