#!/bin/bash

dir_root="$(pwd)/$(dirname $0)/.."

cd ${dir_root}
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
cd -