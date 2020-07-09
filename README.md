# Orbiter

A collection of web apps, Slack and Twitter bots for all things NASA.

[Web](./web)

[Slack](./slack)

The infrastructure for these apps has evolved over time

* initially they were deployed to [Heroku](https://www.heroku.com) using [Github Actions](https://github.com/admanaut/orbiter/actions) (link to repo [here](https://github.com/admanaut/orbiter/tree/144ec7544461ee08fff94f37d637f6d43ac7e405))
* then they were moved to [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/), provisioned by [Terraform](https://www.terraform.io), deployed by [Github Actions](https://github.com/admanaut/orbiter/actions) still (link to repo [here](https://github.com/admanaut/orbiter/tree/64e1082d03ac6d901b564bdd59f4cf043e6ab740))
