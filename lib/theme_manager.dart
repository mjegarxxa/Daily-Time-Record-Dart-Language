import 'package:flutter/material.dart';

// The "Brain" for Dark Mode
final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(false);

// The "Brain" for Notifications
final ValueNotifier<bool> isNotificationsNotifier = ValueNotifier<bool>(true);