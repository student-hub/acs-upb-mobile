#!/bin/bash

# ./run-ios-bash.sh prod - runs the Firebase prod configuration
# ./run-ios-bash.sh dev	- runs the Firebase dev configuration

flavor=$1

if [ "$flavor" == "prod" ]; then
	cd ./ios/Runner || exit
	rm GoogleService-Info.plist || true
	cp ../config/prod/GoogleService-Info.plist . || exit
	flutter run
else
	cd ./ios/Runner || exit
  	rm GoogleService-Info.plist || true
  	cp ../config/dev/GoogleService-Info.plist . || exit
  	flutter run
fi

