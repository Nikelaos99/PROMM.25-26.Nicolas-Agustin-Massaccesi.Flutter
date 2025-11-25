import 'package:proyecto/screens/screens.dart';
import 'package:intl/intl.dart';

class Formulario2 extends StatelessWidget {
  const Formulario2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavegacionDrawer(),
      appBar: AppBar(title: Text('Formulario Dinamico')),
      body: FormularioDinamico(),
    );
  }
}

class FormularioDinamico extends StatefulWidget {
  @override
  _FormularioDinamicoState createState() => _FormularioDinamicoState();
}

class _FormularioDinamicoState extends State<FormularioDinamico> {
  bool esFormularioResidencia = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();
  bool tieneHijos = false;
  int numeroHijos = 0;
  List<int?> edadHijos = [null, null, null];
  String? ciudadSeleccionada;
  List<String> aficiones = ['Deporte', 'Lectura', 'Música', 'Viajes', 'Cine'];
  List<String> aficionesSeleccionadas = [];
  String? sexoSeleccionado;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
  }

  // Widget principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SwitchListTile(
                title: Text('Tipo Formulario'),
                subtitle: Text(
                  esFormularioResidencia ? 'Residencia' : 'Personal',
                ),
                value: esFormularioResidencia,
                onChanged: (bool value) {
                  setState(() {
                    esFormularioResidencia = value;
                  });
                },
              ),
              if (esFormularioResidencia)
                ..._construirFormularioResidencia()
              else
                ..._construirFormularioPersonal(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Formulario Enviado')),
                    );
                  }
                },
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Construye el formulario personal
  List<Widget> _construirFormularioPersonal() {
    return [
      // Nombre completo
      TextFormField(
        keyboardType: TextInputType.name,
        controller: _nombreController,
        decoration: InputDecoration(
          labelText: 'Nombre Completo',
          icon: Icon(Icons.abc),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingresa tu nombre completo';
          } else if (!RegExp(r'^[a-zA-ZÁÉÍÓÚáéíóú\s]+$').hasMatch(value)) {
            return 'Por favor, ingresa un nombre válido';
          }
          return null;
        },
      ),

      // E-mail
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'E-mail',
          icon: Icon(Icons.mail),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingresa tu correo electrónico';
          } else if (!RegExp(
            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
          ).hasMatch(value)) {
            return 'Por favor, ingresa un correo electrónico válido';
          }
          return null;
        },
      ),

      // Telefono
      TextFormField(
        controller: _telefonoController,
        decoration: InputDecoration(
          labelText: 'Teléfono',
          icon: Icon(Icons.phone),
        ),
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingresa tu número de teléfono';
          } else if (!RegExp(r'^\d{9}$').hasMatch(value)) {
            return 'Por favor, ingresa un número de teléfono válido';
          }
          return null;
        },
      ),
      // Checkbox que pregunta si tiene hijos o no
      CheckboxListTile(
        title: Text('¿Tienes hijos?'),
        value: tieneHijos,
        onChanged: (bool? value) {
          setState(() {
            tieneHijos = value!;
            if (!tieneHijos) {
              numeroHijos = 0;
              edadHijos = [null, null, null];
            }
          });
        },
      ),
      if (tieneHijos) ..._construirCamposHijos(),
    ];
  }

  // Construye los campos con la cantidad de hijos
  List<Widget> _construirCamposHijos() {
    return [
      DropdownButtonFormField<int>(
        decoration: InputDecoration(labelText: 'Número de hijos'),
        value: numeroHijos,
        items: List.generate(
          4,
          (index) => DropdownMenuItem(value: index, child: Text('$index')),
        ),
        onChanged: (int? newValue) {
          setState(() {
            numeroHijos = newValue!;
          });
        },
        validator: (value) {
          if (value == null || value < 1 || value > 3) {
            return 'Selecciona un número de hijos válido (0-3)';
          }
          return null;
        },
      ),
      for (int i = 0; i < numeroHijos; i++)
        TextFormField(
          decoration: InputDecoration(labelText: 'Edad del hijo ${i + 1}'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa la edad de tu hijo ${i + 1}';
            } else if (!RegExp(r'^\d+$').hasMatch(value) ||
                int.parse(value) < 0 ||
                int.parse(value) > 100) {
              return 'Ingresa una edad válida (0-100)';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              edadHijos[i] = int.tryParse(value);
            });
          },
        ),
    ];
  }

  // Construye el formulario de residencia
  List<Widget> _construirFormularioResidencia() {
    return [
      TextFormField(
        controller: _fechaNacimientoController,
        decoration: InputDecoration(
          labelText: 'Fecha de Nacimiento',
          icon: Icon(Icons.event),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? fechaSeleccionada = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (fechaSeleccionada != null) {
            setState(() {
              _fechaNacimientoController.text = DateFormat(
                'dd/MM/yyyy',
              ).format(fechaSeleccionada);
            });
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingresa tu fecha de nacimiento';
          }
          return null;
        },
      ),
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Ciudad de Andalucía',
          icon: Icon(Icons.map),
        ),
        value: ciudadSeleccionada,
        items:
            [
                  'Sevilla',
                  'Málaga',
                  'Córdoba',
                  'Granada',
                  'Huelva',
                  'Almería',
                  'Jaén',
                  'Cádiz',
                ]
                .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                .toList(),
        onChanged: (String? newValue) {
          setState(() {
            ciudadSeleccionada = newValue;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, selecciona una ciudad';
          }
          return null;
        },
      ),
      SizedBox(height: 16),

      // Aficiones
      Text('Aficiones', style: TextStyle(fontSize: 16)),
      for (String aficion in aficiones)
        CheckboxListTile(
          title: Text(aficion),
          value: aficionesSeleccionadas.contains(aficion),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                aficionesSeleccionadas.add(aficion);
              } else {
                aficionesSeleccionadas.remove(aficion);
              }
            });
          },
        ),
      if (aficionesSeleccionadas.length < 1)
        Text(
          'Por favor selecciona al menos 1 afición',
          style: TextStyle(color: Colors.red),
        ),
      SizedBox(height: 16),

      // Sexo
      Text('Sexo', style: TextStyle(fontSize: 16)),
      ListTile(
        title: Text('Hombre'),
        leading: Radio<String>(
          value: 'Hombre',
          groupValue: sexoSeleccionado,
          onChanged: (String? value) {
            setState(() {
              sexoSeleccionado = value;
            });
          },
        ),
      ),
      ListTile(
        title: Text('Mujer'),
        leading: Radio<String>(
          value: 'Mujer',
          groupValue: sexoSeleccionado,
          onChanged: (String? value) {
            setState(() {
              sexoSeleccionado = value;
            });
          },
        ),
      ),
      ListTile(
        title: Text('Prefiero no contestar'),
        leading: Radio<String>(
          value: 'Prefiero no contestar',
          groupValue: sexoSeleccionado,
          onChanged: (String? value) {
            setState(() {
              sexoSeleccionado = value;
            });
          },
        ),
      ),
    ];
  }
}
