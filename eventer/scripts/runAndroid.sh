#!/bin/bash

dir_root="$(pwd)/$(dirname $0)/.."

cd ${dir_root}
flutter run -d "SM A325F"
cd -