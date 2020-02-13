# ACS UPB Mobile
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/IoanaAlexandru/acs_upb_mobile/blob/master/LICENSE.txt)

A mobile application for students at ACS UPB.  

## Want to contribute?  

### Building from source with Android Studio

#### Prerequisites

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

#### Building for Android

* Install and run an emulator in Android Studio (using AVD Manager), or connect a physical Android
device (make sure USB debugging is enabled).
* Select your device from the dropdown list and hit the play button (*Shift+F10*/*^R*).

#### Building for iOS (MacOS only)

* Make sure you have Xcode installed and up to date (it is free on the App Store).
* Connect a physical iOS device or select *Open iOS Simulator* from the device drop-down menu to
power on Xcode's simulator.
* Select your device from the dropdown list and hit the play button (*Shift+F10*/*^R*).

#### Building for Web

* You need to have *Chrome* installed in order to be able to run the web version of the app.
* Select *Chrome* from the dropdown list and hit the play button (*Shift+F10*/*^R*).

#### Not working?

Possible fixes could be:
* Run `flutter doctor` and fix any issues that may come up.
* Run `flutter clean` to delete the `build` directory and then build again.
* Restart Android Studio using `File > Invalidate Caches / Restart`.

Test your setup by creating and running a new Flutter project (Android Studio provides a sample). If
that works but this project doesn't, feel free to
[open an Issue](https://github.com/IoanaAlexandru/acs_upb_mobile/issues/new) and describe the
problem.

### Development tips

* Make sure you have the *Project* view open in the *Project* tab on the left in Android Studio (not
*Android*).
* Flutter comes with *Hot Reload* (the lightning icon, or *Ctrl+\\*/*⌘\\*), which allows you to load
changes in the code quickly into an already running app, without you needing to reinstall it. It's a
very handy feature, but it doesn't work all the time - if you change the code, use Hot Reload but
don't see the expected changes, or see some weird behaviour, you may need to close and restart the
app (or even reinstall).
* If running on web doesn't give the expected results after changing some code, you may need to
clear the cache (in *Chrome*: *Ctrl+Shift+C*/*⌘+Shift+C* to open the Inspect menu, then right-click
the *Refresh* button, and select *Empty cache and Hard reload*.)

### Style guide  

This project uses
[the official Dart style guide](https://dart.dev/guides/language/effective-dart/style)  with the
following mentions:  

* Android Studio (IntelliJ) with the `dartfmt` tool is used to automatically format the code,
including the order of imports.  
* For consistency, the `new` keyword (which is optional in Dart) should **not** be used.  
* Where necessary, comments should use Markdown formatting (e.g. backticks - ` - for code snippets).
* Use only single apostrophes - ' - for strings (e.g. `'hello'` instead of `"hello"`)
* All strings that are visible to the user should be internationalised and set in the corresponding
`.arb` files within the `l10n` folder. The
[Flutter Intl](https://plugins.jetbrains.com/plugin/13666-flutter-intl) Android Studio plugin does
all the hard work for you if you set it up, it generates the code when you save an `.arb` file.
Strings can then be accessed using `S.of(context).stringID`.

### License  

This project is under the **MIT License**, which means that you can do whatever you want with it, as
long as you add a copy of the original MIT license and copyright notice to your work.