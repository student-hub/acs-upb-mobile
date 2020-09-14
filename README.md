# ACS UPB Mobile
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/IoanaAlexandru/acs_upb_mobile/blob/master/LICENSE.txt)
[![Tests](https://github.com/acs-upb-mobile/acs-upb-mobile/workflows/Tests/badge.svg)](https://github.com/acs-upb-mobile/acs-upb-mobile/actions?query=workflow%3ATests)
[![codecov](https://codecov.io/gh/acs-upb-mobile/acs-upb-mobile/branch/master/graph/badge.svg)](https://codecov.io/gh/acs-upb-mobile/acs-upb-mobile)

A mobile application for students at [ACS UPB](http://acs.pub.ro/). For now, you can try it out by
accessing [https://acs-upb-mobile.web.app/](https://acs-upb-mobile.web.app/). Android users can also
download the apk from the latest [release](https://github.com/acs-upb-mobile/acs-upb-mobile/releases).

Please note that some features may not work perfectly in the web version, as
[Flutter web support](https://flutter.dev/web) is currently still in beta. However, please feel free
to [create an issue](https://github.com/acs-upb-mobile/acs-upb-mobile/issues/new?&template=bug_report.md)
if you encounter any problem.

If you would like to contribute and don't know where to start, or you have any questions about this
project, feel free to [join us on Slack](https://join.slack.com/t/acs-upb-mobile/shared_invite/zt-gz48csbn-iVYTE04sFaawINPTlV4oew)
and ask anything on the **#ama** channel.

## Screenshots

<img src=screenshots/app/light_login_ro.png height=500><img src=screenshots/app/dark_login_en.png height=500>

<img src=screenshots/app/light_settings_ro.png height=500><img src=screenshots/app/dark_settings_en.png height=500>

<img src=screenshots/app/light_portal_ro.png height=500><img src=screenshots/app/dark_portal_en.png height=500>

## Contributors
* [Ioana Alexandru](https://github.com/IoanaAlexandru)
* [Andrei-Constantin Mirciu](https://github.com/andreicmirciu)
* [Adrian Mărgineanu](https://github.com/AdrianMargineanu)
* [Alex Conțiu](https://github.com/AlexContiu)
* [Eric Postolache](https://github.com/ericpostolache)

## Building from source with Android Studio

### Prerequisites

* Install Flutter as per the instructions [here](https://flutter.dev/docs/get-started/install).
* Open Android Studio.
* Make sure you have the [Flutter plugin](https://plugins.jetbrains.com/plugin/9212-flutter)
installed, as well as the [Dart plugin](https://plugins.jetbrains.com/plugin/6351-dart) dependency.
Restart the IDE if necessary.
* Use the *Check out project from Version Control* option (or *File > New > Project from Version
Control*) to clone the repository from https://github.com/IoanaAlexandru/acs_upb_mobile.
* If the plugins are installed, Android Studio should automatically recognise it as being a Flutter
project, so you should be able to just click *Next* on everything and create a new project.
* When prompted, set up the Flutter SDK (the location is the `flutter/` folder you downloaded when
you installed it) and Dart SDK (it comes bundled with Flutter at `flutter/bin/cache/dart-sdk/`).
* Open the project terminal and switch to the Beta Flutter channel in order to enable web support:
```
flutter channel beta
flutter upgrade
flutter config --enable-web
```
* Install all of the required packages:
```
flutter pub get
```
* You may need to restart the IDE for the changes to take effect.

### Building for Android

* Install and run an emulator in Android Studio (using AVD Manager), or connect a physical Android
device (make sure USB debugging is enabled).
* Select your device from the dropdown list and hit the play button (*Shift+F10* / *^R*).

### Building for iOS (MacOS only)

* Make sure you have Xcode installed and up to date (it is free on the App Store).
* Connect a physical iOS device or select *Open iOS Simulator* from the device drop-down menu to
power on Xcode's simulator.
* Select your device from the dropdown list and hit the play button (*Shift+F10* / *^R*).

### Building for Web 

* You need to have *Chrome* installed in order to be able to run the web version of the app.
* Select *Chrome* from the dropdown list and hit the play button (*Shift+F10* / *^R*).

### Not working?

Possible fixes could be:
* Run `flutter doctor` and fix any issues that may come up.
* Run `flutter clean` to delete the `build` directory and then build again.
* Restart Android Studio using *File > Invalidate Caches / Restart*.

Test your setup by creating and running a new Flutter project (Android Studio provides a sample). If
that works but this project doesn't, feel free to
[open an issue](https://github.com/IoanaAlexandru/acs_upb_mobile/issues/new) and describe the
problem.

## License  

This project is under the
[MIT License](https://github.com/IoanaAlexandru/acs_upb_mobile/blob/master/LICENSE.txt), which means
that you can do whatever you want with it, as long as you add a copy of the original MIT license and
copyright notice to your work.
