#!/usr/bin/env bash
set -ex
IFS=$' \n\t'

export BASE_VERSION="v0.6.15"
export PLUS_VERSION="0.1"
export PLUS_WORKING_BRANCH="terraform-plus-$BASE_VERSION-$PLUS_VERSION"
export GOPATH="$PWD/gopath"
export PATH="$GOPATH/bin:$PATH"
export DISTDIR="$PWD/dist"
export WORKDIR="$PWD"
mkdir -p "$GOPATH"

export GOX_MAIN_TEMPLATE="$DISTDIR/{{.OS}}/{{.Dir}}"
export GOX_PLUGIN_TEMPLATE="$DISTDIR/{{.OS}}/terraform-{{.Dir}}"
export GOX_ARCH="amd64"
export GOX_OS=${*:-"linux darwin"}

# We'll use gox to cross-compile
go get github.com/mitchellh/gox
# We just assume the cross toolchains are already installed, since on Debian
# there are deb packages for those.

go get -u -v github.com/hashicorp/terraform

cd "$GOPATH/src/github.com/hashicorp/terraform"
git clean -dfx
git reset --hard
git fetch origin
git checkout -B $PLUS_WORKING_BRANCH tags/$BASE_VERSION

# Adjust the version number to include our PLUS_VERSION
BASE_VERSION_GIVEN=$(perl -ne '/"(\d+\.\d+\.\d+)"/ && print $1' "$GOPATH/src/github.com/hashicorp/terraform/terraform/version.go")
FULL_PLUS_VERSION="$BASE_VERSION_GIVEN+$PLUS_VERSION"
echo "--- Building TerraformPlus $FULL_PLUS_VERSION"
echo "--- Based on Terraform tag $BASE_VERSION"

cat >"$GOPATH/src/github.com/hashicorp/terraform/terraform/version.go" <<EOF
package terraform

// Modified version.go for terraform-plus
const Version = "$FULL_PLUS_VERSION"
const VersionPrerelease = ""
EOF

# Build Terraform itself
gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_MAIN_TEMPLATE" github.com/hashicorp/terraform

# Remove our overridden version.go so we don't get conflicts as we
# build the plugins and switch branches.
git clean -dfx
git reset --hard

# Build the standard plugins
gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_PLUGIN_TEMPLATE" $(go list github.com/hashicorp/terraform/builtin/bins/... | grep -v /vendor/)

# No we'll work on the plugins that are waiting to be merged into the main Terraform repo.
git remote add apparentlymart git@github.com:apparentlymart/terraform.git || true
git fetch apparentlymart

# grafana provider
if [ ! -f "$GOPATH/bin/terraform-provider-grafana" ]; then
    git checkout grafana-provider
    go get -v github.com/hashicorp/terraform/builtin/bins/provider-grafana
    gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_PLUGIN_TEMPLATE" github.com/hashicorp/terraform/builtin/bins/provider-grafana
fi

# new build of the terraform provider to include the terraform_synthetic_state resource
# this one intentionally clobbers the one in the standard build
git checkout $PLUS_WORKING_BRANCH
# the synth-state branch was before HashiCorp started vendoring packages so instead of 
# checking out the branch we'll cherry-pick the relevant commit. This is brittle and 
# will break eventually.
git cherry-pick -n remotes/apparentlymart/synth-state
gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_PLUGIN_TEMPLATE" github.com/hashicorp/terraform/builtin/bins/provider-terraform
git clean -dfx
git reset --hard

# out-of-tree beanstalk provider
git checkout master
go get -u -v github.com/saymedia/terraform-beanstalk/terraform-provider-beanstalk
git checkout $PLUS_WORKING_BRANCH
gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_MAIN_TEMPLATE" github.com/saymedia/terraform-beanstalk/terraform-provider-beanstalk

# out-of-tree buildkite provider
git checkout master
go get -u -v github.com/saymedia/terraform-buildkite/terraform-provider-buildkite
git checkout $PLUS_WORKING_BRANCH
gox -arch="$GOX_ARCH" -os="$GOX_OS" -output="$GOX_MAIN_TEMPLATE" github.com/saymedia/terraform-buildkite/terraform-provider-buildkite

# put terraform.git into an expected state
git checkout master
git branch -d $PLUS_WORKING_BRANCH

# ZZZZZZZZZZZZZZZZZZZZIPPIT
echo "--- Build done"
for os in $GOX_OS; do
    echo "--- Zipping $os"
    cd "$DISTDIR/$os"
    tar -Jcvf ../terraform-plus-v"$FULL_PLUS_VERSION"-"$os".tar.xz ./*
done
echo "--- DING! Fries are done"
if [[ -e "$DISTDIR/terraform-plus-v$FULL_PLUS_VERSION-darwin.tar.xz" ]]; then
    openssl dgst -sha256 "$DISTDIR/terraform-plus-v$FULL_PLUS_VERSION-darwin.tar.xz"
fi
exit 0
