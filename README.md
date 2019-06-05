# snoozy_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.


# References
* [Dynamic theme changer](https://github.com/Norbert515/dynamic_theme), [article](https://proandroiddev.com/how-to-dynamically-change-the-theme-in-flutter-698bd022d0f0)

* [Audioplayers repo](https://github.com/luanpotter/audioplayers)

* https://stackoverflow.com/questions/49439047/how-to-preserve-widget-states-in-flutter-when-navigating-using-bottomnavigation

* https://stackoverflow.com/questions/51195114/flutter-persistent-state-between-pages

* [initializing sharedPreferences on creation](https://flutter.institute/run-async-operation-on-widget-creation/)
* [guide on using sharedpreferences](https://medium.com/@studymongolian/saving-and-reading-data-in-flutter-with-sharedpreferences-bb4238d3105)

* [sharing data](https://medium.com/flutter-community/simple-ways-to-pass-to-and-share-data-with-widgets-pages-f8988534bd5b). A mix of sending and recieving was used.
* When ou have to pass a function which has params you have to pass, instead of nesting another function inside it, do this(example):
```
() => funk(param1, param2, ..)
// in use
onClick: () => funk(param1, param2, ..)
```


