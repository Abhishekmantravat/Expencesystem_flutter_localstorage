import 'package:expencesystem/views/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();

await Hive.initFlutter();
await Hive.openBox('shopping_box');  


  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expence system',
    
      home:  homepage(),
    );
  }
}

