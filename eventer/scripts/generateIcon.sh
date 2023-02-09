#!/bin/bash

dir_root="$(pwd)/$(dirname $0)/.."

cd ${dir_root}
flutter pub get
flutter packages pub run flutter_launcher_icons:main
cd -