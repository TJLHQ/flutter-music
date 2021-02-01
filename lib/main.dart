import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './routes/index.dart';
import 'providers/playProvider.dart';
import 'components/color.dart';
void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(
              builder: (_)=>PlayProvider(),
            )
          ],
          child: MyApp()
      )
  );
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'music',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: MyColors.bgColor,
            platform: TargetPlatform.iOS
        ),
        initialRoute: '/',
        onGenerateRoute: onGenerateRoute
    );
  }
}

