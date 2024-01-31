import 'package:bionic_test/cubit/contact_cubit.dart';
import 'package:bionic_test/hive/data_session.dart';
import 'package:bionic_test/ui/contact_screen.dart';
import 'package:bionic_test/ui/data_screen.dart';
import 'package:bionic_test/ui/map_screen.dart';
import 'package:bionic_test/ui/media_screen.dart';
import 'package:bionic_test/ui/user_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(DataSessionAdapter());
  await Hive.openBox<DataSession>('data_session');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Menu')),
      body: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title: Text(_menuData()[index].title),
          leading: Icon(_menuData()[index].icon),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => _menuData()[index].nextScreen));
          },
        ),
        itemCount: _menuData().length,
      ),
    );
  }

  List<MenuItem> _menuData() {
    var menu = <MenuItem>[];
    menu.add(MenuItem('User', Icons.person, const UserScreen()));
    menu.add(MenuItem('Map', Icons.map, const MapScreen()));
    menu.add(
      MenuItem(
        'Contact',
        Icons.contact_page,
        BlocProvider<ContactCubit>(
          create: (_) => ContactCubit(),
          child: const ContactScreen(),
        ),
      ),
    );
    menu.add(MenuItem('Media', Icons.image, const MediaScreen()));
    menu.add(
        MenuItem('Data', Icons.data_saver_off_outlined, const DataScreen()));
    return menu;
  }
}

class MenuItem {
  String title;
  IconData icon;
  Widget nextScreen;

  MenuItem(this.title, this.icon, this.nextScreen);
}
