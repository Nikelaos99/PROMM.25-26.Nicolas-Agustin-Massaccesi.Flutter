import 'package:proyecto/screens/screens.dart';

class Piramide extends StatelessWidget {
  const Piramide({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: const NavegacionDrawer(),
    appBar: AppBar(title: const Text('Pirámide')),
    body: Center(
      child: Builder(
        builder: (context) {
          final screenWidth = MediaQuery.of(context).size.width;

          double imageSize;
          double fontSize;

          if (screenWidth < 600) {
            imageSize = 80;
            fontSize = 14;
          } else if (screenWidth < 1200) {
            imageSize = 100;
            fontSize = 16;
          } else {
            imageSize = 120;
            fontSize = 18;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/piramide/capybara.jpg',
                        width: imageSize,
                        height: imageSize,
                      ),
                      Text('Capybara', style: TextStyle(fontSize: fontSize)),
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
                        width: imageSize,
                        height: imageSize,
                      ),
                      Text('Conejo', style: TextStyle(fontSize: fontSize)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/piramide/huron.jpg',
                        width: imageSize,
                        height: imageSize,
                      ),
                      Text('Hurón', style: TextStyle(fontSize: fontSize)),
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
                        width: imageSize,
                        height: imageSize,
                      ),
                      Text('Perro', style: TextStyle(fontSize: fontSize)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/piramide/cacatua.jpg',
                        width: imageSize,
                        height: imageSize,
                      ),
                      Text('Cacatúa', style: TextStyle(fontSize: fontSize)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/piramide/gato.jpg',
                        width: imageSize,
                        height: imageSize,
                      ),
                      Text('Gato', style: TextStyle(fontSize: fontSize)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}
