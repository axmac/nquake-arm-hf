#!/bin/sh
# Build an armhf distributable for an nQuake server install.
#
# Downloads from 'latest'.
# Requires zip tool.
# Creates './dist/sv-bin-armhf.zip'

wget="wget -q --no-hsts"

error() {
  printf "ERROR: %s\n" "$*"
  exit 1
}

get_packages() {
  # mvdsv
  source="https://builds.quakeworld.nu/mvdsv/releases/latest/linux/armhf"

  ${wget} -O ./build/mvdsv ${source}/mvdsv || error "Failed to download ${source}/mvdsv"
  [ ! -s "./build/mvdsv" ] && error "Downloaded mvdsv but file is empty?!"

  ${wget} -O ./build/mvdsv.md5 ${source}/mvdsv.md5 || error "Failed to download ${source}/mvdsv.md5"
  [ ! -s "./build/mvdsv.md5" ] && error "Downloaded mvdsv.md5 but file is empty?!"

  md5sum -c ./build/mvdsv.md5 || error "MD5 sum does not match: mvdsv"

  # qwprogs
  source="https://builds.quakeworld.nu/ktx/releases/latest/linux/armhf"

  ${wget} -O ./build/qwprogs.so ${source}/qwprogs.so || error "Failed to download ${source}/qwprogs.so"
  [ ! -s "./build/qwprogs.so" ] && error "Downloaded qwprogs.so but file is empty?!"

  ${wget} -O ./build/qwprogs.md5 ${source}/qwprogs.md5 || error "Failed to download ${source}/qwprogs.md5"
  [ ! -s "./build/qwprogs.md5" ] && error "Downloaded qwprogs.md5 but file is empty?!"

  md5sum -c ./build/qwprogs.md5 || error "MD5 sum does not match: qwprogs.so"

  # qtv
  source="https://builds.quakeworld.nu/qtv/releases/latest/linux/armhf"

  ${wget} -O ./build/qtv ${source}/qtv || error "Failed to download ${source}/qtv"
  [ ! -s "./build/qtv" ] && error "Downloaded qtv but file is empty?!"

  ${wget} -O ./build/qtv.md5 ${source}/qtv.md5 || error "Failed to download ${source}/qtv.md5"
  [ ! -s "./build/qtv.md5" ] && error "Downloaded qtv.md5 but file is empty?!"

  cd build; md5sum -c qtv.md5 || error "MD5 sum does not match: qtv"; cd -

  # qwfwd
  source="https://builds.quakeworld.nu/qwfwd/releases/latest/linux/armhf"

  ${wget} -O ./build/qwfwd ${source}/qwfwd || error "Failed to download ${source}/qwfwd"
  [ ! -s "./build/qwfwd" ] && error "Downloaded qwfwd but file is empty?!"

  ${wget} -O ./build/qwfwd.md5 ${source}/qwfwd.md5 || error "Failed to download ${source}/qwfwd.md5"
  [ ! -s "./build/qwfwd.md5" ] && error "Downloaded qwfwd.md5 but file is empty?!"

  cd build; md5sum -c qwfwd.md5 || error "MD5 sum does not match: qwfwd"; cd -
}

make_dist() {

  mkdir -p dist/ktv
  mkdir -p dist/qtv
  mkdir -p dist/qwfwd

  cp build/mvdsv dist/mvdsv
  cp build/qwprogs.so dist/ktv/qwprogs.so
  cp build/qtv dist/qtv/qtv.bin
  cp build/qwfwd dist/qwfwd/qwfwd.bin

  cd dist
  zip -r sv-bin-armhf.zip mvdsv ktv qtv qwfwd
  cd -
}

get_packages
make_dist
