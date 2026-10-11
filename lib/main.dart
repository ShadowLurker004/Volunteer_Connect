import 'package:flutter/material.dart';
import 'app/volunteer_connect_app.dart';
import 'state/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const AppStateScope(
      child: GoodNeighborApp(),
    ),
  );
}


