import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:wildfiretracker/entities/settings_entity.dart';
import 'package:wildfiretracker/services/local_storage_service.dart';
import 'package:wildfiretracker/utils/storage_keys.dart';

/// Service that deals with the settings management.
class SettingsService {
  /// Property that defines the local storage service.
  LocalStorageService get _localStorageService =>
      GetIt.I<LocalStorageService>();

  /// Sets the given [settings] into the local storage.
  Future<void> setSettings(SettingsEntity settings) async {
    await _localStorageService.setItem(StorageKeys.settings, settings.toMap());
  }

  /// Gets the local storage settings.
  SettingsEntity getSettings() {
    String? settings = _localStorageService.getItem(StorageKeys.settings);

    return settings != null
        ? SettingsEntity.fromMap(json.decode(settings))
        : SettingsEntity();
  }
}
