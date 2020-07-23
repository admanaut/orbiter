provider "helm" {
  version = "~> 1.2"
}

resource "helm_release" "fluxcd" {
  name       = "fluxcd"
  repository = "https://charts.fluxcd.io"
  chart      = "flux"

  max_history = 2
  atomic = true

  namespace = "flux"
  create_namespace = true

  set {
    name  = "git.url"
    value = "https://github.com/admanaut/orbiter-gitops.git"
  }

  set {
    name  = "git.pollInterval"
    value = "1m"
  }

  set {
    name  = "git.readonly"
    value = "true"
  }

}
