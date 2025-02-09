import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:lista_mercado/screens/screen_listas_mercado.dart';

class NovidadesScreen extends StatefulWidget {
  const NovidadesScreen({super.key});

  @override
  _NovidadesScreenState createState() => _NovidadesScreenState();
}

class _NovidadesScreenState extends State<NovidadesScreen> {
  late VideoPlayerController _controller;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> _novidades = [
    {
      "titulo": "Compartilhamento de Listas",
      "descricao":
          "Agora você pode compartilhar suas listas com outros usuários!",
      "video": "assets/videos/compartilhar.mp4"
    },
    {
      "titulo": "Filtragem de Itens",
      "descricao":
          "Encontre rapidamente os itens que deseja comprando por categoria.",
      "video": "assets/videos/filtragem.mp4"
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadVideo(_novidades[_currentPage]["video"]!);
  }

  void _loadVideo(String path) {
    _controller = VideoPlayerController.asset(path)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  void _changePage(int newIndex) {
    if (newIndex < 0 || newIndex >= _novidades.length) return;

    setState(() {
      _currentPage = newIndex;
    });

    _loadVideo(_novidades[_currentPage]["video"]!);
    _pageController.animateToPage(
      newIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finalizar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ScreenListasMercado()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _novidades.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return

                        /*                   Padding(
  padding: const EdgeInsets.all(16.0),
  child: Text(
    'Novidades da Versão',
    style: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white, // Título em branco para destacar do fundo
      shadows: [
        Shadow(
          offset: Offset(2.0, 2.0),
          blurRadius: 6.0,
          color: Colors.black.withOpacity(0.6), // Sombra escura
       */
                        Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _novidades[index]["titulo"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 6.0,
                                    color: Colors.deepPurple,
                                  )
                                ]),
                          ),
                          const SizedBox(height: 20),
                          if (_controller.value.isInitialized)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              ),
                            )
                          else
                            const CircularProgressIndicator(),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              _novidades[index]["descricao"]!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.deepPurple),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      if (_currentPage > 0)
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.deepPurple),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white),
                          ),
                          onPressed: () => _changePage(_currentPage - 1),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10),
                            child: Text("Anterior"),
                          ),
                        ),
                      Spacer(), // Isso empurra o próximo botão para a direita
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.deepPurple),
                          foregroundColor: WidgetStateProperty.all(Colors.white),
                        ),
                        onPressed: _currentPage < _novidades.length - 1
                            ? () => _changePage(_currentPage + 1)
                            : _finalizar,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10),
                          child: Text(_currentPage < _novidades.length - 1
                              ? "Próximo"
                              : "Entendi"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
