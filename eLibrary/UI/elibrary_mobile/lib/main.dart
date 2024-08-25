import 'dart:async';

import 'package:elibrary_mobile/layouts/citalac2_homepage_screen.dart';
import 'package:elibrary_mobile/providers/auth_provider.dart';
import 'package:elibrary_mobile/providers/autori_provider.dart';
import 'package:elibrary_mobile/providers/biblioteka_knjiga_provider.dart';
import 'package:elibrary_mobile/providers/biblioteka_provider.dart';
import 'package:elibrary_mobile/providers/ciljne_grupe_provider.dart';
import 'package:elibrary_mobile/providers/citalac_knjiga_log_provider.dart';
import 'package:elibrary_mobile/providers/citaoci_provider.dart';
import 'package:elibrary_mobile/providers/clanarine_provider.dart';
import 'package:elibrary_mobile/providers/izdavac_provider.dart';
import 'package:elibrary_mobile/providers/jezici_provider.dart';
import 'package:elibrary_mobile/providers/kanton_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_autori_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_ciljna_grupa_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_provider.dart';
import 'package:elibrary_mobile/providers/knjiga_vrste_sadrzaja_provider.dart';
import 'package:elibrary_mobile/providers/korisnik_sacuvana_knjiga_provider.dart';
import 'package:elibrary_mobile/providers/obavijesti_provider.dart';
import 'package:elibrary_mobile/providers/penali_provider.dart';
import 'package:elibrary_mobile/providers/pozajmice_provider.dart';
import 'package:elibrary_mobile/providers/produzenje_pozajmice_provider.dart';
import 'package:elibrary_mobile/providers/rezervacije_provider.dart';
import 'package:elibrary_mobile/providers/tip_clanarine_biblioteka_provider.dart';
import 'package:elibrary_mobile/providers/tip_uplate_provider.dart';
import 'package:elibrary_mobile/providers/upiti_provider.dart';
import 'package:elibrary_mobile/providers/uplate_provider.dart';
import 'package:elibrary_mobile/providers/uvez_provider.dart';
import 'package:elibrary_mobile/providers/valute_provider.dart';
import 'package:elibrary_mobile/providers/vrsta_grade_provider.dart';
import 'package:elibrary_mobile/providers/vrste_sadrzaja_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      print("ON error error: ${errorDetails.exception.toString()}");
    };
    await dotenv.load(fileName: ".env");
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => KnjigaProvider()),
      ChangeNotifierProvider(create: (_) => BibliotekaKnjigaProvider()),
      ChangeNotifierProvider(create: (_) => JezikProvider()),
      ChangeNotifierProvider(create: (_) => VrstaGradeProvider()),
      ChangeNotifierProvider(create: (_) => IzdavacProvider()),
      ChangeNotifierProvider(create: (_) => UvezProvider()),
      ChangeNotifierProvider(create: (_) => AutoriProvider()),
      ChangeNotifierProvider(create: (_) => VrsteSadrzajaProvider()),
      ChangeNotifierProvider(create: (_) => CiljneGrupeProvider()),
      ChangeNotifierProvider(create: (_) => TipClanarineBibliotekaProvider()),
      ChangeNotifierProvider(create: (_) => ValutaProvider()),
      ChangeNotifierProvider(create: (_) => CitaociProvider()),
      ChangeNotifierProvider(create: (_) => PozajmiceProvider()),
      ChangeNotifierProvider(create: (_) => RezervacijeProvider()),
      ChangeNotifierProvider(create: (_) => KantonProvider()),
      ChangeNotifierProvider(create: (_) => UplataProvider()),
      ChangeNotifierProvider(create: (_) => PozajmiceProvider()),
      ChangeNotifierProvider(create: (_) => RezervacijeProvider()),
      ChangeNotifierProvider(create: (_) => KnjigaAutoriProvider()),
      ChangeNotifierProvider(create: (_) => KnjigaVrsteSadrzajaProvider()),
      ChangeNotifierProvider(create: (_) => KnjigaCiljnaGrupaProvider()),
      ChangeNotifierProvider(create: (_) => ClanarineProvider()),
      ChangeNotifierProvider(create: (_) => PenaliProvider()),
      ChangeNotifierProvider(create: (_) => BibliotekaProvider()),
      ChangeNotifierProvider(create: (_) => KorisnikSacuvanaKnjigaProvider()),
      ChangeNotifierProvider(create: (_) => ObavijestiProvider()),
      ChangeNotifierProvider(create: (_) => CitalacKnjigaLogProvider()),
      ChangeNotifierProvider(create: (_) => ProduzenjePozajmiceProvider()),
      ChangeNotifierProvider(create: (_) => TipUplateProvider()),
      ChangeNotifierProvider(create: (_) => UpitiProvider()),
    ], child: const MyApp()));
  }, (error, stack) {
    print("Error from OUT_SUDE Framerwork");
    print("--------------------------------");
    print("Error : $error");
    // print("StackTrace : $stack");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.blue, primary: Colors.black),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 700, maxWidth: 400),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Dobrodošli na eLibrary",
                          style: Theme.of(context).textTheme.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Prijavite se na Vaš račun",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "Korisničko ime",
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Molim vas unesite korisničko ime.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: "Lozinka",
                            prefixIcon: const Icon(Icons.password_outlined),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: _obscurePassword
                                  ? const Icon(Icons.visibility_outlined)
                                  : const Icon(Icons.visibility_off_outlined),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Unesite lozinku!";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              var provider = CitaociProvider();
                              AuthProvider.username = _usernameController.text;
                              AuthProvider.password = _passwordController.text;

                              try {
                                //var data = await provider.get();
                                CitaociProvider cp = new CitaociProvider();
                                var citalac = await cp.login(
                                    AuthProvider.username!,
                                    AuthProvider.password!);
                                AuthProvider.citalacId = citalac.citalacId;
                                AuthProvider.ime = citalac.ime;
                                AuthProvider.prezime = citalac.prezime;
                                AuthProvider.kantonId = citalac.kantonId;
                                AuthProvider.institucija = citalac.institucija;
                                AuthProvider.telefon = citalac.telefon;
                                print("Authenticated!");

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HomePage2()));
                              } on Exception catch (e) {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: e.toString());
                              }
                            }
                          },
                          child: const Text("Login"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
