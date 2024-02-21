import 'dart:async';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../entities/ssh_entity.dart';
import '../utils/storage_keys.dart';
import 'lg_settings_service.dart';
import 'local_storage_service.dart';

/// Service that deals with the SSH management.
class SSHService {
  LGSettingsService get _settingsService => GetIt.I<LGSettingsService>();

  /*LocalStorageService get _localStorageService =>
      GetIt.I<LocalStorageService>();*/

  /// Property that defines the SSH client instance.
  SSHClient? _client;

  /// Property that defines the SSH client instance.
  SSHClient? get client => _client;

  //bool isAuthenticated = false;

  /// Sets a client with the given [ssh] info.
  Future<bool?> setClient(SSHEntity ssh) async {
    try {
      final socket = await SSHSocket.connect(ssh.host, ssh.port, timeout: const Duration(seconds: 4));
      String? password;
      _client = SSHClient(socket,
        username: ssh.username,
        onPasswordRequest: () => password = ssh.passwordOrKey,
        //keepAliveInterval: const Duration(seconds: 5),
        //onAuthenticated: () async {}
      );
      if (kDebugMode) {
        print(
            'IP: ${ssh.host}, port: ${ssh.port}, username: ${ssh.username}, password: ${ssh.passwordOrKey}');
      }
      return true;
      // await Future.delayed(const Duration(seconds: 10));
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('Failed to connect: $e');
      }
      return false;
    }
  }

  Future<bool?> init() {
    // _localStorageService.setItem(StorageKeys.lgConnection, "not");
    final settings = _settingsService.getSettings();
    return setClient(SSHEntity(
      username: settings.username,
      host: settings.ip,
      passwordOrKey: settings.password,
      port: settings.port,
    ));
  }

  /// Connects to the current client, executes a command into it and then disconnects.
  Future<SSHSession?> execute(String command) async {
    await connect();
    SSHSession? execResult;
    execResult = await _client?.execute(command);
    disconnect();
    return execResult;
  }

  /// Connects to a machine using the current client.
  Future<void> connect() async {
    final settings = _settingsService.getSettings();
    await setClient(SSHEntity(
      username: settings.username,
      host: settings.ip,
      passwordOrKey: settings.password,
      port: settings.port,
    ));
  }

  /// Disconnects from the a machine using the current client.
  SSHClient? disconnect() {
    _client?.close();
    return _client;
  }

  /// Connects to the current client through SFTP, uploads a file into it and then disconnects.
  upload(File inputFile, String filename) async {
    await connect();
    Future.delayed(const Duration(seconds: 3));
    try {
      bool uploading = true;
      final sftp = await _client?.sftp();
      final file = await sftp?.open('/var/www/html/$filename',
          mode: SftpFileOpenMode.truncate |
          SftpFileOpenMode.create |
          SftpFileOpenMode.write);
      var fileSize = await inputFile.length();
      file?.write(inputFile.openRead().cast(), onProgress: (progress) {
        if(fileSize == progress){
          uploading = false;
        }
      });
      // print(file);
      if(file==null){
        print('null');
        return;
      }
      await waitWhile(() => uploading);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    disconnect();
  }

  Future waitWhile(bool Function() test,
      [Duration pollInterval = Duration.zero]) {
    var completer = Completer();
    check() {
      if (!test()) {
        completer.complete();
      } else {
        Timer(pollInterval, check);
      }
    }
    check();
    return completer.future;
  }
}
