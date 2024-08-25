
# Universal Organizer

CS50 2024 Final Project by Alexander Maykl Mychlo Dolinin

## CS50 Final Project Video

<video controls>
  <source src="resources/final_project.mp4" type="video/mp4">
</video>

## Runs on:

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)

## Author

- [@alexmmych](https://github.com/alexmmych)


## FAQ

#### What does this software do?

This software has the utility of a calendar and notekeeper app that is cross-compatible between different Desktop platforms.


#### Why Flutter

I used Flutter not necessarily because it can also build for mobile because I can't really test for those platforms well (No Android phone or MacOS) but because it's easily compatible with desktop platforms like Windows and Linux, which is important because I switch on the daily between those two.


## Screenshots

![App Screenshot](resources/screenshot.png)
![App Screenshot](resources/screenshot_01.png)


## In-depth explanation

### Design choices

#### Flutter vs. Kotlin

The first design choice I've ever debated was whether to use Kotlin for this application or Flutter, I decided to go with Flutter in the end because Kotlin was a bit more obtuse from what I gathered and had less documentation and support by the community.

On the other hand Flutter has a lot of documentation made by Google, and it has a lot of widget and package support from the community, many of which I've used like [syncfusion_flutter_calendar](https://pub.dev/packages/syncfusion_flutter_calendar) and or [animated_list_plus](https://pub.dev/packages/animated_list_plus)

Another benefit of Flutter ended up being a centralized code for all platforms, not that I needed it that much since I mainly focused on Desktop and Web, but it's a nice thing to have overall as it makes it simpler to build independently of the machine you're in.

#### Hive vs. Firebase

When I decided to go for Flutter, once I got into the stage of deciding what to use to store user information, I went with Hive since it's the simpler solution, where Firebase is more complicated but more customizable.

Hive just served the purpose I wanted to use it for.

### File structure

Flutter creates this type of file structure:
```
.
├── analysis_options.yaml
├── android
├── build
├── devtools_options.yaml
├── ios
├── lib
├── linux
├── macos
├── pubspec.lock
├── pubspec.yaml
├── web
└── windows
```

As you can see it creates a folder for each possible platform, but because of Flutter's characteristics the only code I needed to modify to create this project was the "lib" folder, which contains most of the files:

```
lib
├── main.dart
├── providers
│   ├── moving_provider
│   │   ├── moving_provider.dart
│   │   ├── nav_provider.dart
│   │   └── settings_provider.dart
│   └── theme_provider.dart
└── widgets
    ├── main_widgets
    │   ├── base_class.dart
    │   ├── google_calendar.dart
    │   ├── notes.dart
    │   └── top_bar.dart
    ├── moving_container
    │   ├── moving_container.dart
    │   ├── nav_rail.dart
    │   └── settings.dart
    └── reusable_widgets
        ├── button.dart
        ├── file.dart
        └── generated
            └── file.g.dart
```

The structure is not needed, all that matters is that the .dart files are located in the lib folder, everything else I did to organize myself, here's the basic explanation

- [providers](lib/providers): contains classes which extend from ChangeNotifier, in order to transfer state variables through files
- [providers/moving_provider](lib/providers/moving_provider/): subclass of providers which are related to the custom MovingClass, used to animate containers, mainly done to reuse code.
- [widgets](lib/widgets): all the widgets used in the code
- [widgets/main_widgets](lib/widgets/main_widgets/): widgets which contain other smaller widgets and usually are created as a Scaffold when they override build.
- [widgets/moving_container](lib/widgets/moving_container/): widgets which inherit from MovingContainer in order to re-use code
- [widgets/reusable_widgets](lib/widgets/reusable_widgets/): smaller widgets which are used throughout other widgets (things like buttons, notes, generated files, etc.)

- [main.dart](lib/main.dart): main file which initializes all of the Hive boxes and starts the app

#### Providers

The providers are bit interesting since I wanted to have something akin to universally accessible values, and I wanted to use other methods like using Builders, but then the complexity surged through the roof for me, so I decided to use simple ChangeNotifier classes, which are able to be called in any of the widgets, provided that there is a build context like this:

```
import '../../providers/theme_provider.dart';
import '../../providers/moving_provider/nav_provider.dart';
import '../../providers/moving_provider/settings_provider.dart';


final themeProvider = Provider.of<ThemeProvider>(context);
final navProvider = Provider.of<NavProvider>(context);
final settingsProvider = Provider.of<SettingsProvider>(context);
```

What this essentially means, is that they can be called within build method, which is Flutter's function for creating the widget itself and almost every widget has it, making it almost universally available.

- **MovingProvider:** Superclass which allows for the inheritors of this widget to be shown or unshown, this is only used for the navigation rail and settings widget as they can be shown or hidden.

- **ThemeProvider:** Allows apps to access the current theme, this is important because the user can change between Light and Dark theme at any time, and thus it's needed for consistency in color throughout the app.

- **NavProvider:** Allows to see which is the currently selected NavigationRail object. In other words, this determines whether to display the calendar or the notes app inside of BaseClass

- **SettingsProvider:** Gets Google user's name and profile picture in order to display on the settings and controls whether the user is logged in or not currently.

All of these save their necessary variables in their respective HiveBox so the user can come back to the app in the same state as they left it in after closing it and reopening.

### Widgets

These are all the widgets that are used within the app in order to display data and allow the user to interact with the app. Here's an overview of each file:

- **main.dart:** Initializes Hive (Local Flutter database), opens its boxes, and creates a BaseClass widget.

- **main_widgets/base_class.dart:** Creates a Scaffold with a TopBar object and esentially displays the whole app, TopBar is the part that goes on top to control the app, it stores the MovingContainers so they can be shown accordingly if need be and it shows the current desired app by the user based on the navigation rail

- **main_widgets/top_bar.dart:** Widget hich contains the app name, and buttons to show the NavigationRail and or Settings MovingContainers and to toggle between Dark/Light theme.

- **main_widgets/google_calendar.dart:** The most line heavy file out of the project as it contains the logic to request Google Calendar API ID and Secret, signing in, connection, scope requests, calendar events gathering and displaying through SyncFusion calendar plugin.

- **main_widgets/notes.dart:** Widget which allows the user to create, store, save, edit and delete notes in the Hive box, so it's stored after exiting, and allows to reorder the list using the animated_list_plus plugin.


These are the main widgets, here are the secondary ones which aren't as complex:

- **moving_containers**: Widgets which can be either hidden or shown, in nav_rail.dart the NavigationRail widget is used to determine whether to use google_calendar.dart or notes.dart, and settings.dart is used for displaying the Google user's name and profile picture, and provides a way to log out from Google, erasing any stored data within.

- **reusable_widgets**: Widgets which can be reused or are small enough not warranting to be placed in main_widgets, button.dart is responsible for creating the buttons on the top of TopBar, and file.dart is responsible for storing the notes that you can create in Hive. The generated folder was created automatically as a translation layer in order to be able to store it in a Hive box.

## Main Features

- Light/dark mode toggle
- Cross compatibility between Windows and Linux
- Google Calendar synchronization
- Notes taking
- Saving the application state in Hive so user doesn't have to log in again or change their preferred theme


## Acknowledgements

 - [Add Google Event Calendar to Flutter Event Calendar (SyncFusion)](https://github.com/SyncfusionExamples/add-google-event-calendar-to-flutter-event-calendar)
 - [Electronics icons created by xnimrodx - Flaticon](https://www.flaticon.com/free-icons/electronics)
 - [readme.so](https://readme.so/)


## 🔗 Links
[![Github](https://img.shields.io/badge/github-12100E?style=for-the-badge&logo=github&logoColor=white)](https://github.com/alexmmych/)
[![LinkedIn](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/)

