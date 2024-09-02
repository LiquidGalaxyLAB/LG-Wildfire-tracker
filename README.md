<div align="center">
    <img alt="Wildfire Tracker for Liquid Galaxy" src="./assets/images/logo_gsoc24_round.png" width="40%" />
    <h1 style="margin-top: -5px;" align="center">Wildfire Tracker for Liquid Galaxy</h1>

</div>


<p align="center">
  <img alt="License" src="https://img.shields.io/github/license/LiquidGalaxyLAB/LG-Wildfire-tracker?color=%23FFC857">
  <img alt="Top language" src="https://img.shields.io/github/languages/top/LiquidGalaxyLAB/LG-Wildfire-tracker?color=%230090C1">
  <img alt="Languages" src="https://img.shields.io/github/languages/count/LiquidGalaxyLAB/LG-Wildfire-tracker?color=%234CFA72">
  <img alt="Repository size" src="https://img.shields.io/github/repo-size/LiquidGalaxyLAB/LG-Wildfire-tracker?color=%2375DEFF">
  <img alt="Latest tag" src="https://img.shields.io/github/v/tag/LiquidGalaxyLAB/LG-Wildfire-tracker?color=%23DE6EFD">
</p>

### Summary

- [About](#about)
- [Getting Started](#getting-started)
- [Building the app](#building-the-app)
- [Connecting to the Liquid Galaxy](#connecting-to-the-liquid-galaxy)
- [Setting up the rig](#setting-up-the-rig)
- [License](#license)

### About
The project will be a responsive Flutter application designed for tablets, which
through an SSH connection and API calls, we will be able to represent the desired
information on the LG. Additionally, the application will be autonomous, and
without being connected to the LG, it will be able to represent and display
information on the mobile device itself. The project will consist of two parts:

The first part is intended to represent past forest fires, to see all the affected
areas, the development of the forest fire, and all the information represented on
the Liquid Galaxy.

The second part will be to visualize real-time fires, whether they are forest fires or
house fires, on the Liquid Galaxy and see their information.

In the third part of the project, what is dealt with is to represent the risks of forest fires in the United States area.

The Liquid Galaxy is a cluster of screens with Google Earth that synchronize with
each other to create the sensation of a single screen, depending on the
configuration it can be panoramic, vertical, curved, etc. Through this tool, we will
be able to represent fires and see the impacts in an interactive and easy-to-see
detail. Additionally, we will have many important data about the fire, such as the
extent, emitted gases, possible victims, key points, extinguishing techniques,
possible improvements, front speed, fire score, type of smoke column, smoke
data, etc. All those data that we can extract from our API.



### Getting started

Before continuing, make sure to have installed in your machine [Git](https://git-scm.com/) and [Flutter](https://flutter.dev). Read [Flutter documentation](https://docs.flutter.dev) for further information.

Then, clone the project:

```bash
$ git clone https://github.com/LiquidGalaxyLAB/LG-Wildfire-tracker.git
$ cd LG-Wildfire-tracker
```

With the project cloned, run it by using the following command:

> ❗ You must have a mobile device connected or an android emulator running in order to run the app.

```bash
$ flutter run --no-sound-null-safety
```

> The `--no-sound-null-safety` flag is necessary due to the `ssh` package.

### Building the app

In order to have a installed version of the app, you may [download the APK](https://github.com/LiquidGalaxyLAB/LG-Wildfire-tracker/releases/) in this repository or run the command below:

```bash
$ flutter build apk --no-sound-null-safety
```

> The `--no-sound-null-safety` flag is necessary due to the `ssh` package.

Once done, the APK file may be found into the `/build/app/outputs/flutter-apk/` directory, named `app-release.apk`.

### Connecting to the Liquid Galaxy

With the app opened, a cog button (⚙️) may be seen into the home page toolbar (top right corner). When clicked, it will lead you to the settings page, in which a form may be found.

Fill it up with the Liquid Galaxy host name, password, IP address and SSH connection port (change it only if the system `22` default SSH port was changed).

After done, click into the `Connect` button and check whether there's a `Connected` green label above the form, in case it doesn't, there's something wrong with the given information or your device connection.

Once connected, head back to the home page and use the app as you wish. Note that all of the data is kept into the local storage after the first load. To update it with the database data, tap the `SYNC` button into the toolbar, next to the cog button (⚙️).

### Setting up the rig

An important step to take is configure the slave screens for refreshing when setting solo KMLs.

To set it up, head to the settings page by hitting the cog button (⚙️) and go to the Liquid Galaxy tab.

In the button list, you shall see a button `SET SLAVES REFRESH` and `RESET SLAVES REFRESH`. The first one will setup your slave screens to refresh its solo KML every 2 seconds. The second one will make your slaves stop refreshing.

> ❗ _Both actions will **reboot** your Liquid Galaxy, so the changes may be applied._

### License

The Wildfire Tracker for Liquid Galaxy is licensed under the [MIT license](https://opensource.org/licenses/MIT).