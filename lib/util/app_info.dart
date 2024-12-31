import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static String _version = '';
  static late String _buildNumber;
  static late String _buildSignature;
  static late String _appName;
  static late String _packageName;
  static late String _installerStore;

  static Future<void> initializeAppInfo() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
      _buildSignature = packageInfo.buildSignature;
      _appName = packageInfo.appName;
      _packageName = packageInfo.packageName;
      _installerStore = packageInfo.installerStore!;
    } catch (e) {
      print('Erro ao inicializar informações do aplicativo: $e');
      // Definindo valores padrão em caso de erro
      _version = 'Versão Não Encontrada';
      _buildNumber = 'Número de Build Não Encontrado';
      _buildSignature = 'Assinatura da Build Não Encontrada';
      _appName = 'Nome do App Não Encontrado';
      _packageName = 'Pacote do App Não Encontrado';
      _installerStore = 'Loja de Instalação Não Encontrada';
    }
  }

  static String get version => _version;
  static String get buildNumber => _buildNumber;
  static String get buildSignature => _buildSignature;
  static String get appName => _appName;
  static String get packageName => _packageName;
  static String get installerStore => _installerStore;
}
