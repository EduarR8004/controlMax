import 'dart:io';
import 'package:controlmax/vistas/portada.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:controlmax/vistas/login/login.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



void main() async  {
   WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
   HttpOverrides.global = new MyHttpOverrides ();
  runApp(MyApp());
}
class CambiarTema extends InheritedWidget{
  const CambiarTema({Widget child,this.onTap,Key key}):super(child: child,key: key);
  final Function onTap;
  static CambiarTema of(BuildContext context)=>context.findAncestorWidgetOfExactType<CambiarTema>();
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget)=> false;
}
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool cambiarColor = true;
  String colores='';
  @override
  Widget build(BuildContext context) => OverlaySupport(
    child: CambiarTema(
      onTap: (color){  
        setState(() {
          colores=color;
        });
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Control Más',
        theme: temas(colores),
        home:
        portada(),
        //Login(false),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en','US'), // English
          const Locale('es','CO'), // Spanish
         // const Locale('fr'), // French
         // const Locale('zh'), // Chinese
        ],
      ),
    ),
  );
  ThemeData tema;
  Widget portada(){
    if(Platform.isAndroid){
      return Portada(editar: false,);
    }else{  
      return Login(false);
    }
  }

  ThemeData temas( String color){
    if(color=='Rojo'){
      tema=ThemeData(
        primarySwatch:Colors.red,
        primaryColor: Colors.red,
        accentColor: Colors.red,
      );
    }else if(color=='Azul'){
      tema=ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        accentColor: Colors.blue,
      );
    }else{
      tema=ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.blueGrey,
        accentColor: Colors.blueGrey,
      );
    }
    return tema;
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
  return super.createHttpClient(context)
  ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

