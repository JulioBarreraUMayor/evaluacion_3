import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/providers.dart';
import '../ui/input_decorations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              CardContainer(
                  child: Column(children: [
                const SizedBox(height: 10),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 30),
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: LoginForm(),
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'add_user'),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(StadiumBorder())),
                  child: const Text('¿No tienes una cuenta?, creala'),
                ),
                TextButton(
                  onPressed: () =>
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Color.fromARGB(255, 49, 49, 49),
                            title: Text('Escriba su Correo', style: TextStyle(color: Colors.white)),
                            actions: <Widget>[
                              TextFormField(
                                autocorrect: false,
                                keyboardType: TextInputType.text,
                                decoration: InputDecortions.authInputDecoration(
                                  hinText: 'Ingrese su correo',
                                  labelText: 'Email',
                                  prefixIcon: Icons.people,
                                ),
                                validator: (value) {
                                  return (value != null && value.length >= 4)
                                      ? null
                                      : 'El usuario no puede estar vacio';
                                },
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.green,
                                        title: Text('Un link será enviado a su correo electronico si el servicio esta en linea.', style: TextStyle(color: Colors.white)),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK', style: TextStyle(color: Colors.white)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text('ACEPTAR', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          );
                        },
                      ),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(StadiumBorder())),
                  child: const Text('¿Se te olvidó tu contraseña?'),
                )
              ])),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
        key: LoginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: InputDecortions.authInputDecoration(
              hinText: 'Ingrese su correo',
              labelText: 'Email',
              prefixIcon: Icons.people,
            ),
            onChanged: (value) => LoginForm.email = value,
            validator: (value) {
              return (value != null && value.length >= 4)
                  ? null
                  : 'El usuario no puede estar vacio';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecortions.authInputDecoration(
              hinText: '************',
              labelText: 'Password',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => LoginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 4)
                  ? null
                  : 'La contraseña no puede estar vacio';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            color: Colors.orange,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
              child: Text(
                'Ingresar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            elevation: 0,
            onPressed: LoginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final authService =
                        Provider.of<AuthService>(context, listen: false);
                    if (!LoginForm.isValidForm()) return;
                    LoginForm.isLoading = true;
                    final String? errorMessage = await authService.login(
                        LoginForm.email, LoginForm.password);
                    if (errorMessage == null) {
                      Navigator.pushNamed(context, 'list');
                    } else {
                      print(errorMessage);
                    }
                    LoginForm.isLoading = false;
                  },
          )
        ]),
      ),
    );
  }
}
