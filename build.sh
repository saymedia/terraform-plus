#!/bin/bash -xe

export BASE_VERSION="1373a6086ba14b8d09cd3797346272b5a6eb37cd"
export GOPATH="$PWD/gopath"
export PATH="$GOPATH/bin:$PATH"
export DISTDIR="$PWD/dist"
mkdir -p "$GOPATH"

export GOX_MAIN_TEMPLATE="$DISTDIR/{{.OS}}/{{.Dir}}"
export GOX_PLUGIN_TEMPLATE="$DISTDIR/{{.OS}}/terraform-{{.Dir}}"
export GOX_ARCH="amd64"
export GOX_OS="linux darwin"

# We'll use gox to cross-compile
go get github.com/mitchellh/gox
# We just assume the cross toolchains are already installed, since on Debian
# there are deb packages for those.

# Build Terraform itself
go get -v github.com/hashicorp/terraform
gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_MAIN_TEMPLATE" github.com/hashicorp/terraform

cd $GOPATH/src/github.com/hashicorp/terraform
git fetch origin
git checkout $BASE_VERSION

# Build the standard plugins
go get -v github.com/hashicorp/terraform/builtin/bins/...
gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_PLUGIN_TEMPLATE" github.com/hashicorp/terraform/builtin/bins/...

# No we'll work on the plugins that are waiting to be merged into the main Terraform repo.
git remote add apparentlymart git@github.com:apparentlymart/terraform.git || true
git fetch apparentlymart

# stateful_provisioning resource
if [ ! -f $GOPATH/bin/terraform-provider-stateful ]; then
    git checkout app-deploy
    go get github.com/hashicorp/terraform/builtin/bins/provider-stateful
    gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_PLUGIN_TEMPLATE" github.com/hashicorp/terraform/builtin/bins/provider-stateful
fi

# chef provider
if [ ! -f $GOPATH/bin/terraform-provider-chef ]; then
    git checkout chef-provider
    go get github.com/hashicorp/terraform/builtin/bins/provider-chef
    gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_PLUGIN_TEMPLATE" github.com/hashicorp/terraform/builtin/bins/provider-chef
fi

# mysql provider
if [ ! -f $GOPATH/bin/terraform-provider-mysql ]; then
    git checkout mysql-provider
    go get github.com/hashicorp/terraform/builtin/bins/provider-mysql
    gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_PLUGIN_TEMPLATE" github.com/hashicorp/terraform/builtin/bins/provider-mysql
fi

# tls provider
if [ ! -f $GOPATH/bin/terraform-provider-tls ]; then
    git checkout tls
    go get github.com/hashicorp/terraform/builtin/bins/provider-tls
    gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_PLUGIN_TEMPLATE" github.com/hashicorp/terraform/builtin/bins/provider-tls
fi

# influxdb provider
if [ ! -f $GOPATH/bin/terraform-provider-influxdb ]; then
    git checkout influxdb-provider
    go get github.com/hashicorp/terraform/builtin/bins/provider-influxdb
    gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_PLUGIN_TEMPLATE" github.com/hashicorp/terraform/builtin/bins/provider-influxdb
fi

# grafana provider
if [ ! -f $GOPATH/bin/terraform-provider-grafana ]; then
    git checkout grafana-provider
    go get github.com/hashicorp/terraform/builtin/bins/provider-grafana
    gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_PLUGIN_TEMPLATE" github.com/hashicorp/terraform/builtin/bins/provider-grafana
fi

# new build of the terraform provider to include the terraform_synthetic_state resource
# this one intentionally clobbers the one in the standard build
git checkout synth-state
gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_PLUGIN_TEMPLATE" github.com/hashicorp/terraform/builtin/bins/provider-terraform

# out-of-tree beanstalk provider
go get github.com/saymedia/terraform-beanstalk/terraform-provider-beanstalk
gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_MAIN_TEMPLATE" github.com/saymedia/terraform-beanstalk/terraform-provider-beanstalk

# ZZZZZZZZZZZZZZZZZZZZIPPIT
cd $DISTDIR/linux
zip ../terraform-linux.zip *

cd $DISTDIR/darwin
zip ../terraform-darwin.zip *
