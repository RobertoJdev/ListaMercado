import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_mercado/my_theme.dart';
import 'package:lista_mercado/widgets/alerts/confirm_exit_list.dart';
import 'package:lista_mercado/widgets/calculator.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  static const platform = MethodChannel('openCalculator');
  final String? title;
  final String defaultTitle;
  final bool screenReturn;
  final bool showShareButton;
  final Function()? onSharePressed;
  final Function? onSave;
  final Function(String)? onSearchChanged;

  const CustomAppBar({
    super.key,
    this.title,
    this.defaultTitle = 'Lista de Mercado',
    this.screenReturn = false,
    this.showShareButton = true,
    this.onSharePressed,
    this.onSave,
    this.onSearchChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  //final Function(String)? onSearchChanged;
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode(); // Defina o FocusNode

  @override
  void dispose() {
    searchFocusNode.dispose(); // Não se esqueça de liberar o foco ao destruir o widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple,
            Colors.deepPurpleAccent,
          ],
          begin: Alignment.center,
          end: Alignment.bottomCenter,
        ),
      ),
      child: AppBar(
        //toolbarHeight: 50, // Reduz altura total da AppBar
        titleSpacing: 0, // Remove espaçamento padrão do título
        //iconTheme: MyTheme.iconBarTheme,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: widget.screenReturn
            ? IconButton(
                padding: const EdgeInsets.all(0),
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  final shouldSave = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return const ConfirmExitDialog();
                    },
                  );
                  if (shouldSave == true && widget.onSave != null) {
                    widget.onSave!(true);
                  } else {
                    widget.onSave!(false);
                  }
                },
              )
            : null,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isSearching
              ? AnimatedContainer(
                  //margin: EdgeInsets.zero, // Remove margem externa
                  //padding: EdgeInsets.zero, // Remove padding interno
                  //padding: EdgeInsets.zero,
                  //margin: EdgeInsets.zero,
                  duration: const Duration(milliseconds: 300),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 40,
                  child: TextField(
                    controller: searchController,
                    focusNode: searchFocusNode, // Adicione o FocusNode aqui
                    onChanged: widget.onSearchChanged,
                    decoration: InputDecoration(
                      //margin: EdgeInsets.zero
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      hintText: 'Pesquisar...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                )
              : Text(
                  widget.title ?? widget.defaultTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
        ),
        actions: [
          if (widget.showShareButton)
            IconButton(
              padding: const EdgeInsets.only(left: 8),
              visualDensity: VisualDensity.compact,
              icon: Icon(isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    searchController.clear();
                    if (widget.onSearchChanged != null) {
                      widget.onSearchChanged!(''); // Passar uma string vazia para resetar a pesquisa
                    }
                    searchFocusNode.unfocus();
                  } else {
                    searchFocusNode.requestFocus();
                  }
                  isSearching = !isSearching;
                });
              },
            ),
          if (widget.showShareButton)
            IconButton(
              //padding: const EdgeInsets.only(right: 4),
              visualDensity: VisualDensity.compact,
              onPressed: widget.onSharePressed,
              icon: const Icon(
                Icons.share,
              ),
            ),
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.only(right: 8),
            onPressed: () => calculator(context),
            icon: const Icon(
              Icons.calculate_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
