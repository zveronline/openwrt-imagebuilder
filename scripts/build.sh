#!/usr/bin/env bash
set -e

OPENWRT_VERSION="v24.10.5"

TARGET="mediatek"
SUBTARGET="filogic"
PROFILE="cudy_tr3000-v1"

ARCH="aarch64_cortex-a53_mediatek_filogic"

AWG_REPO="Slava-Shchipunov/awg-openwrt"
AWG_TAG="v${OPENWRT_VERSION}"

IB_NAME="openwrt-imagebuilder-${OPENWRT_VERSION}-${TARGET}-${SUBTARGET}.Linux-x86_64.tar.xz"

wget -q "https://downloads.openwrt.org/releases/${OPENWRT_VERSION}/targets/${TARGET}/${SUBTARGET}/${IB_NAME}"
tar xf "${IB_NAME}"
cd openwrt-imagebuilder-*

mkdir -p packages

BASEURL="https://github.com/${AWG_REPO}/releases/download/${AWG_TAG}"

for pkg in amneziawg-tools kmod-amneziawg luci-proto-amneziawg luci-i18n-amneziawg-ru; do
  IPK="${pkg}_${OPENWRT_VERSION}_${ARCH}.ipk"
  echo "Trying ${IPK}"
  wget -q "${BASEURL}/${IPK}" -O "packages/${IPK}" || {
    echo "WARNING: ${IPK} not found"
    rm -f "packages/${IPK}"
  }
done

make image \
  PROFILE="${PROFILE}" \
  PACKAGES="luci-i18n-base-ru nano kmod-zram zram-swap kmod-lib-lz4 kmod-usb-storage block-mount kmod-fs-f2fs mkf2fs f2fs-tools f2fsck luci-app-acl luci-i18n-acl-ru luci-ssl luci-mod-rpc luci-mod-dashboard ttyd luci-app-ttyd luci-i18n-upnp-ru luci-i18n-wol-ru amneziawg-tools kmod-amneziawg luci-proto-amneziawg luci-i18n-amneziawg-ru"
