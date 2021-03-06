# CoreOS Cluster
CoreOS Cluster including:
* [coreos](https://coreos.com/blog/coreos-beta-release/)
* [etcd2](https://github.com/coreos/etcd)
* [fleet](https://github.com/coreos/fleet)
* [consul](http://consul.io/)
* [registrator](https://github.com/gliderlabs/registrator) 
* [google cloud provider](https://cloud.google.com/)

## Setup
* Create a Google Cloud Account (you get 2 months for free)
* Create a new token at https://discovery.etcd.io/new?size=3 and replace on `cloud-config-leader.yaml`:
```
    discovery: https://discovery.etcd.io/your_token_here
```
* Log into https://console.developers.google.com/ and go to `APIs & auth > Credentials`. Click on `Create a new OAuth client ID` and select "Service account". Save the downloaded file as `gce_account.json` in the same dir of this project.
* Rename sample files
* You should review both sample files, especially `variable "gce_project_name"` which must be the name of a valid google cloud project. See: https://console.developers.google.com/project.
* Do not forget to enable billing, it's obligatory.
* Default credentials: admin/changeme123
* Run
```
terraform apply
```

## Todo & Ideas
* Support AWS
* Add logging management 
