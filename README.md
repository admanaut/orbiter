# Orbiter

A collection of web apps, Slack and Twitter bots for all things NASA.

[Web](./web)

[Slack](./slack)

The infrastructure for these apps has evolved over time

* initially they were deployed to [Heroku](https://www.heroku.com) using [Github Actions](https://github.com/admanaut/orbiter/actions) (link to repo [here](https://github.com/admanaut/orbiter/tree/144ec7544461ee08fff94f37d637f6d43ac7e405))
* then they were moved to [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/), provisioned by [Terraform](https://www.terraform.io) and [Kustomize](https://kustomize.io), deployed by [Github Actions](https://github.com/admanaut/orbiter/actions) still (link to repo [here](https://github.com/admanaut/orbiter/tree/01d4f090fdc7b9e9f37ab016c29e33ccabf0d919))
* now, manifests built with Kustomize, via Github Actions, are pushed to a [GitOps repo](https://github.com/admanaut/orbiter-gitops) and eventually syncronised with the Kube cluster using [FluxCD](https://github.com/fluxcd/flux) installed in the cluster. (link to repo [here](https://github.com/admanaut/orbiter/tree/aca128cecb11d6ad0c0cf3c2bc8da6ce5dfcfb33))
