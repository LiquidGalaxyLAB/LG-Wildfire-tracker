import 'dart:async';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wildfiretracker/entities/lg_settings_model.dart';
import 'package:wildfiretracker/services/local_storage_service.dart';
import 'package:wildfiretracker/services/nasa/nasa_service.dart';
import 'package:wildfiretracker/utils/storage_keys.dart';
import 'package:wildfiretracker/utils/theme.dart';
import 'package:wildfiretracker/widgets/button.dart';
import 'package:wildfiretracker/widgets/input.dart';

import '../services/lg_service.dart';
import '../services/lg_settings_service.dart';
import '../services/nasa/nasa_service_settings.dart';
import '../utils/snackbar.dart';
import '../widgets/confirm_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  LGSettingsService get _settingsService => GetIt.I<LGSettingsService>();

  LGService get _lgService => GetIt.I<LGService>();

  NASAService get _nasaService => GetIt.I<NASAService>();

  LocalStorageService get _localStorageService =>
      GetIt.I<LocalStorageService>();

  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _pwController = TextEditingController();
  final _screensController = TextEditingController();

  late final _nasaApiController = TextEditingController();

  late TabController _tabController;

  bool show = false;
  bool isAuthenticated = true;
  bool _loading = false;
  bool _canceled = false;

  bool _settingRefresh = false;
  bool _resetingRefresh = false;
  bool _clearingKml = false;
  bool _rebooting = false;
  bool _relaunching = false;
  bool _shuttingDown = false;

  //final ScrollController _scrollController = ScrollController();
  //bool _showTextInAppBar = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initNetworkState();
  }

  @override
  void dispose() {
    //_scrollController.removeListener(_scrollListener);
    //_scrollController.dispose();
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
    //super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  /*void _scrollListener() {
    if (_scrollController.position.pixels >= 45) {
      setState(() {
        _showTextInAppBar = true;
      });
    } else {
      setState(() {
        _showTextInAppBar = false;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        shadowColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          splashRadius: 24,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.build_rounded),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ThemeColors.primaryColor,
          labelColor: ThemeColors.primaryColor,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(
              icon: Icon(Icons.connected_tv_rounded),
              text: 'Connection',
            ),
            Tab(
              icon: Icon(Icons.public),
              text: 'Liquid Galaxy',
            ),
            Tab(
              icon: Icon(Icons.settings),
              text: 'Settings',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConnectionSettings(),
          _buildLGSettings(),
          _buildSettings(),
        ],
      ),
    );
  }

  /// Builds the connection settings/form.
  Widget _buildConnectionSettings() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Establish connection to the system',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                isAuthenticated ? 'Connected' : 'Disconnected',
                style: TextStyle(
                  color:
                      isAuthenticated ? ThemeColors.success : ThemeColors.alert,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Input(
                controller: _usernameController,
                label: 'Username',
                hint: 'lg',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.person_rounded, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Input(
                controller: _pwController,
                label: 'Password',
                hint: 'lg',
                obscure: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.key_rounded, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Input(
                controller: _ipController,
                label: 'IP',
                hint: '192.168.1.26',
                type: TextInputType.number,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.router_rounded, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Input(
                controller: _portController,
                label: 'Port',
                hint: '22',
                type: TextInputType.number,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.account_tree_rounded, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Input(
                controller: _screensController,
                label: 'Number of Screens',
                hint: '3',
                type: TextInputType.number,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.tv, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Button(
                label: 'Connect',
                width: 170,
                height: 48,
                loading: _loading,
                icon: Icon(
                  Icons.connected_tv_rounded,
                  color: ThemeColors.backgroundColor,
                ),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    //_showTextInAppBar = false;
                  });
                  _localStorageService.setItem(StorageKeys.lgScreens,
                      _screensController.text.toString());
                  _onConnect();
                  Timer(const Duration(seconds: 3), () async {
                    if (isAuthenticated) {
                      await _lgService.setLogos();
                    } else {
                      showSnackbar(context, 'Connection failed');
                    }
                    setState(() {
                      _loading = false;
                    });
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the settings.
  Widget _buildSettings() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Setup NASA custom API key',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Input(
                controller: _nasaApiController,
                label: 'NASA API Key',
                hint: NASAServiceSettings.nasaApiKey,
                type: TextInputType.text,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.key, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Button(
                label: 'Save',
                width: 130,
                height: 48,
                icon: Icon(
                  Icons.save,
                  color: ThemeColors.backgroundColor,
                ),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  _localStorageService.setItem(StorageKeys.nasaApiKey,
                      _nasaApiController.text.toString());
                  _nasaService.nasaApiCountryLiveFire.apiKey =
                      _nasaApiController.text.toString();
                  showSnackbar(context, 'Saved');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the Liquid Galaxy tasks.
  Widget _buildLGSettings() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Control your system',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                isAuthenticated ? 'Connected' : 'Disconnected',
                style: TextStyle(
                  color:
                      isAuthenticated ? ThemeColors.success : ThemeColors.alert,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            _buildLGTaskButton(
              'SET SLAVES REFRESH',
              Icons.av_timer_rounded,
              () async {
                if (_settingRefresh) {
                  return;
                }

                showDialog(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    title: 'Are you sure?',
                    message:
                        'The slaves solo KMLs will start to refresh each 2 seconds and all screens will be rebooted.',
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    onConfirm: () async {
                      Navigator.of(context).pop();

                      setState(() {
                        _settingRefresh = true;
                      });

                      try {
                        await _lgService.setRefresh();
                      } finally {
                        setState(() {
                          _settingRefresh = false;
                        });
                      }
                    },
                  ),
                );
              },
              loading: _settingRefresh,
            ),
            _buildLGTaskButton(
              'RESET SLAVES REFRESH',
              Icons.timer_off_rounded,
              () async {
                if (_resetingRefresh) {
                  return;
                }

                showDialog(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    title: 'Are you sure?',
                    message:
                        'The slaves will stop refreshing and all screens will be rebooted.',
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    onConfirm: () async {
                      Navigator.of(context).pop();

                      setState(() {
                        _resetingRefresh = true;
                      });

                      try {
                        await _lgService.resetRefresh();
                      } finally {
                        setState(() {
                          _resetingRefresh = false;
                        });
                      }
                    },
                  ),
                );
              },
              loading: _resetingRefresh,
            ),
            _buildLGTaskButton(
              'Clear KML + logos',
              Icons.cleaning_services_rounded,
              () async {
                if (_clearingKml) {
                  return;
                }

                setState(() {
                  _clearingKml = true;
                });

                try {
                  await _lgService.clearKml(keepLogos: false);
                } finally {
                  setState(() {
                    _clearingKml = false;
                  });
                }
              },
              loading: _clearingKml,
            ),
            _buildLGTaskButton(
              'Relaunch',
              Icons.reset_tv_rounded,
              () {
                if (_relaunching) {
                  return;
                }

                showDialog(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    title: 'Are you sure?',
                    message: 'All screens will be relaunched.',
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    onConfirm: () async {
                      Navigator.of(context).pop();

                      setState(() {
                        _relaunching = true;
                      });

                      try {
                        await _lgService.relaunch();
                      } finally {
                        setState(() {
                          _relaunching = false;
                        });
                      }
                    },
                  ),
                );
              },
              loading: _relaunching,
            ),
            _buildLGTaskButton(
              'Reboot',
              Icons.restart_alt_rounded,
              () {
                if (_rebooting) {
                  return;
                }

                showDialog(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    title: 'Are you sure?',
                    message: 'The system will be fully rebooted.',
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    onConfirm: () async {
                      Navigator.of(context).pop();

                      setState(() {
                        _rebooting = true;
                      });

                      try {
                        await _lgService.reboot();
                      } finally {
                        setState(() {
                          _rebooting = false;
                        });
                      }
                    },
                  ),
                );
              },
              loading: _rebooting,
            ),
            _buildLGTaskButton(
              'Power off',
              Icons.power_settings_new_rounded,
              () {
                if (_shuttingDown) {
                  return;
                }

                showDialog(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    title: 'Are you sure?',
                    message: 'The system will shutdown.',
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    onConfirm: () async {
                      Navigator.of(context).pop();

                      setState(() {
                        _shuttingDown = true;
                      });

                      try {
                        await _lgService.shutdown();
                        setState(() {
                          isAuthenticated = false;
                        });
                      } finally {
                        setState(() {
                          _shuttingDown = false;
                        });
                      }
                    },
                  ),
                );
              },
              loading: _shuttingDown,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the tasks button.
  Widget _buildLGTaskButton(
    String label,
    IconData icon,
    Function() onPressed, {
    bool loading = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Button(
        label: label,
        width: 330,
        height: 48,
        color: isAuthenticated ? ThemeColors.primaryColor : Colors.grey,
        loading: loading,
        onPressed: () {
          if (!isAuthenticated || loading) {
            return;
          }

          onPressed();
        },
        icon: Icon(
          icon,
          color: ThemeColors.backgroundColor,
        ),
      ),
    );
  }

  Widget _getConnection() {
    if (isAuthenticated) {
      setState(() {
        _loading = false;
      });
    }
    return Text(isAuthenticated ? 'Connected' : 'Disconnected',
        style: TextStyle(
            color: isAuthenticated ? ThemeColors.success : ThemeColors.alert,
            fontSize: 30));
  }

  Widget _getTitle(String title) {
    return Text(title,
        style: TextStyle(color: ThemeColors.textSecondary, fontSize: 20));
  }

  /// Initializes and sets the network connection form.
  void _initNetworkState() async {
    final settings = _settingsService.getSettings();

    _localStorageService.setItem(StorageKeys.lgConnection, "not");
    setState(() {
      _usernameController.text = settings.username;
      _portController.text = settings.port.toString();
      _pwController.text = settings.password;
      _ipController.text = settings.ip;
      if (_localStorageService.hasItem(StorageKeys.lgScreens)) {
        _screensController.text =
            _localStorageService.getItem(StorageKeys.lgScreens);
      }
      if (_localStorageService.hasItem(StorageKeys.lgCurrentConnection)) {
        isAuthenticated =
            _localStorageService.getItem(StorageKeys.lgCurrentConnection);
      }
      _nasaApiController.text = _nasaService.nasaApiCountryLiveFire.apiKey;
    });

    /*_onConnect();
    Timer(const Duration(seconds: 3), () async {
      if (isAuthenticated) {
        await _lgService.setLogos();
      } else {
        showSnackbar(context, 'Connection failed');
        _localStorageService.setItem(StorageKeys.lgConnection, "not");
      }
      setState(() {
        _loading = false;
      });
    });*/
  }

  /// Checks and sets the connection status according to the form info.
  Future<void> _checkConnection() async {
    SSHClient? _client;

    try {
      if (_ipController.text.isEmpty ||
          _usernameController.text.isEmpty ||
          _pwController.text.isEmpty ||
          _screensController.text.isEmpty ||
          _portController.text.isEmpty) {
        showSnackbar(context, 'Please enter all details');
      }

      final settings = _settingsService.getSettings();
      try {
        final socket = await SSHSocket.connect(settings.ip, settings.port);
        String? password;
        _client = SSHClient(socket,
            username: settings.username,
            onPasswordRequest: () {
              password = settings.password;
              return password;
            },
            keepAliveInterval: const Duration(seconds: 3600),
            onAuthenticated: () {
              setState(() {
                isAuthenticated = true;
                _localStorageService.setItem(
                    StorageKeys.lgConnection, "connected");
                _localStorageService.setItem(
                    StorageKeys.lgCurrentConnection, true);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Connected successfully.',
                    style: TextStyle(color: ThemeColors.snackBarTextColor),
                  ),
                  backgroundColor: ThemeColors.success,
                ));
              });
            });
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  /// Connects to the a machine according to the form info.
  void _onConnect() async {
    _localStorageService.setItem(StorageKeys.lgConnection, "not");
    setState(() {
      isAuthenticated = false;
      _loading = true;
    });

    await _settingsService.setSettings(
      LGSettingsEntity(
          ip: _ipController.text,
          password: _pwController.text,
          port: int.parse(_portController.text),
          username: _usernameController.text),
    );

    await _checkConnection();
  }
}
