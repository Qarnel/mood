#!/bin/bash

dir_root="$(pwd)/$(dirname $0)/.."

cd ${dir_root}
flutter clean
rm pubspec.lock
flutter pub cache repair
flutter run --verbose
cd -