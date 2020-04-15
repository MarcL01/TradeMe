class SearchSettings {
  Map<String, dynamic> _settings;

  Map<String, dynamic> _dirtySettings;
  bool _isDirty;

  SearchSettings() {
    _settings = {"withinMiles": 50};
    _dirtySettings = {};
    _isDirty = false;
  }

  dynamic getDirtyOrClean(String setting) {
    if (_dirtySettings.containsKey(setting)) {
      return _dirtySettings[setting];
    }
    return _settings[setting];
  }

  dynamic getSetting(String setting) {
    return _settings[setting];
  }

  dynamic changeSetting(String setting, dynamic newVal) {
    if (_settings[setting] == newVal) {
      return;
    }
    _dirtySettings[setting] = newVal;
    _isDirty = true;
  }

  void saveSettings() {
    if (!_isDirty) {
      return;
    }
    _dirtySettings.forEach((key, val) {
      _settings[key] = val;
    });
    _dirtySettings.clear();
    _isDirty = false;
  }
}
