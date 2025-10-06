import 'package:proyecto/screens/screens.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mi aplicacion",
      initialRoute: "/",
      routes: AppRoutes.routes,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext builder) => HomePage());
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade400,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
