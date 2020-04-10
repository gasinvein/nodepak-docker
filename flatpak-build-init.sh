#!/bin/bash
set -e

. /etc/os-release

BUILDDIR="$1"
APPNAME="$2"
SDK="${3:-${ID%.*}.Sdk}"
RUNTIME="${4:-${ID%.*}.Platform}"
BRANCH="${5:-${VERSION_ID%.*}}"

function get_triplet {
    IFS=/ read -r flatpak_id flatpak_arch flatpak_branch <<< "$1"
    if [ -z "${flatpak_arch}" ]; then
        flatpak_arch=$(flatpak --default-arch)
    fi
    if [ -z "${flatpak_branch}" ]; then
        if [ -n "${BRANCH}" ]; then
            flatpak_branch="${BRANCH}"
        else
            return 1
        fi
    fi
    echo "${flatpak_id}/${flatpak_arch}/${flatpak_branch}"
}

RUNTIME=$(get_triplet "${RUNTIME}")
SDK=$(get_triplet "${SDK}")

mkdir -p "${BUILDDIR}"/{files,var/tmp}
ln -sfT /run "${BUILDDIR}"/var/run

cat <<METADATA_EOF > "${BUILDDIR}"/metadata
[Application]
name=${APPNAME}
runtime=${RUNTIME}
sdk=${SDK}
METADATA_EOF
