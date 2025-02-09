import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:lista_mercado/screens/screen_listas_mercado.dart';
import 'package:lista_mercado/screens/novidades_screen.dart';
import 'package:lista_mercado/util/app_info.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAppInfo();
  }

  Future<void> _initializeAppInfo() async {
    await AppInfo.initializeAppInfo();
    _checkVersionAndNavigate();
  }

  Future<void> _checkVersionAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    String? lastVersion = prefs.getString('last_version');

    // Se for uma nova versão, exibe as novidades
    if (lastVersion == null || lastVersion != currentVersion) {
      await prefs.setString('last_version', currentVersion);
      _navigateTo(const NovidadesScreen());
    } else {
      _navigateTo(const ScreenListasMercado());
    }
  }

  void _navigateTo(Widget screen) {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Image.asset('assets/images/app_logo.png', width: 100, height: 100),
            const SizedBox(height: 20),
            const Text(
              'Lista de Mercado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Expanded(child: Container()),
            Text(AppInfo.version),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Desenvolvido por: ',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'Roberto J.',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




/* 
import 'package:flutter/material.dart';
import 'package:lista_mercado/screens/screen_listas_mercado.dart';
import 'package:lista_mercado/util/app_info.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAppInfo();
  }

  Future<void> _initializeAppInfo() async {
    await AppInfo.initializeAppInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
        );
      },
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(),
            ),
            Image.asset('assets/images/app_logo.png', width: 100, height: 100),
            const SizedBox(height: 20),
            const Text(
              'Lista de Mercado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Text(AppInfo.version),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Desenvolvido por: ',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'Roberto J.',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 */