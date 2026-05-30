// lib/providers/profile_provider.dart

import 'package:flutter/material.dart';
import '../data/models/user_profile.dart';
import '../data/repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repo = ProfileRepository();
  UserProfile _profile = UserProfile.defaultProfile;

  UserProfile get profile => _profile;
  bool get isDarkMode => _profile.darkMode;

  Future<void> load() async {
    _profile = await _repo.get();
    notifyListeners();
  }

  Future<void> save(UserProfile profile) async {
    _profile = profile;
    await _repo.save(profile);
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _profile = _profile.copyWith(darkMode: value);
    await _repo.save(_profile);
    notifyListeners();
  }

  Future<void> clearData() async {
    await _repo.clear();
    _profile = UserProfile.defaultProfile;
    notifyListeners();
  }
}
