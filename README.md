# ACS UPB Mobile  
  
A mobile application for students at ACS UPB.  
  
## Want to contribute?  
  
### Building from source  with Android Studio

#### Prerequisites
* Open Android Studio. 
* Make sure you have the [Flutter plugin]([https://plugins.jetbrains.com/plugin/9212-flutter](https://plugins.jetbrains.com/plugin/9212-flutter)) installed, as well as the [Dart plugin]([https://plugins.jetbrains.com/plugin/6351-dart](https://plugins.jetbrains.com/plugin/6351-dart)) dependency. Restart the IDE if necessary.
* Use the *Check out project from Version Control* option (or *File > New > Project from Version Control*) to clone the repository from https://github.com/IoanaAlexandru/acs_upb_mobile.
* If the plugins are installed, Android Studio should automatically recognise it as being a Flutter project, so you should be able to just click *Next* on everything and create a new project.
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

* Install and run an emulator in Android Studio (using AVD Manager), or connect a physical Android device (make sure USB debugging is enabled).
* Select your device from the dropdown list and hit the play button (*Shift+F10*).

#### Building for iOS

*TODO*

#### Building for Web

* You need to have *Chrome* installed in order to be able to run the web version of the app.
* Select *Chrome* from the dropdown list and hit the play button (*Shift+F10*).
  
### Style guide  
  
This project uses [the official Dart style guide](https://dart.dev/guides/language/effective-dart/style)  with the following mentions:  
  
* Android Studio (IntelliJ) with the `dartfmt` tool is used to automatically format the code,  including the order of imports.  
* For consistency, the `new` keyword (which is optional in Dart) should **not** be used.  
* Where necessary, comments should use Markdown formatting (e.g. backticks - ` - for code snippets).  
  
### License  
  
This project is under the **MIT License**, which means that you can do whatever you want with it, as long as you add a copy of the original MIT license and copyright notice to your work.