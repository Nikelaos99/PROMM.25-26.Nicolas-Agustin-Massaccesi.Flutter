import 'package:proyecto/screens/screens.dart';

class Piramide extends StatelessWidget {
  const Piramide({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: const NavegacionDrawer(),
    appBar: AppBar(title: const Text('Pirámide')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/piramide/capybara.jpg',
                    width: 100,
                    height: 100,
                  ),
                  Text('Capybara'),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/piramide/conejo.jpg',
                    width: 100,
                    height: 100,
                  ),
                  Text('Conejo'),
                ],
              ),
              SizedBox(width: 10),
              Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/piramide/huron.jpg',
                    width: 100,
                    height: 100,
                  ),
                  Text('Hurón'),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/piramide/perro.jpg',
                    width: 100,
                    height: 100,
                  ),
                  Text('Perro'),
                ],
              ),
              SizedBox(width: 10),
              Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/piramide/cacatua.jpg',
                    width: 100,
                    height: 100,
                  ),
                  Text('Cacatúa'),
                ],
              ),
              SizedBox(width: 10),
              Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/piramide/gato.jpg',
                    width: 100,
                    height: 100,
                  ),
                  Text('Gato'),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
