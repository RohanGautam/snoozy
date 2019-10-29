# snoozy

A web and mobile app that helps you improve sleep quality by suggesting times to wake and sleep at, based on sleep cycles. Inspired by https://sleepyti.me/


#  screenshots
<img src = "https://user-images.githubusercontent.com/17317792/67737475-4859a500-fa46-11e9-8de3-8d113e6a78b6.jpeg" width = 450>

# Dog animation link
Made on flare by 2Dimensions, available [here.](https://www.2dimensions.com/a/rohangautam/files/flare/dog-animation). Assets used in animation are available in `assets/`

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

* You change the state, it will cause the widget to be rebuilt
* http://soundbible.com/tags-thunder.html

* [Shading/ fading out an image](https://stackoverflow.com/questions/55102880/flutter-image-fade-out-at-bottom-gradient)

* [Card with image AND rounded border](https://stackoverflow.com/questions/53866481/flutter-how-to-create-card-with-background-image)

* [making listview scrollable inside column](https://stackoverflow.com/questions/45669202/how-to-add-a-listview-to-a-column-in-flutter)

* [changing properties of RaisedButton](https://stackoverflow.com/questions/50293503/how-to-set-the-width-of-a-raisedbutton-in-flutter)

* [changing app icon](https://stackoverflow.com/questions/43928702/how-to-change-the-application-launcher-icon-on-flutter)

* [if you wanna change it's name](https://stackoverflow.com/questions/46694153/changing-the-project-name)

* [Flaticon](https://www.flaticon.com) for icons
