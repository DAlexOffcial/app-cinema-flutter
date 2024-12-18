import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CusttomBottomNavegation  extends StatelessWidget {
  final StatefulNavigationShell currentChild;

  const CusttomBottomNavegation ({super.key, required this.currentChild});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: currentChild.currentIndex,
      onTap: (index) => currentChild.goBranch(index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon( Icons.home_max),
          label: 'Inicio'
        ),
/*         BottomNavigationBarItem(
          icon: Icon( Icons.label_outline),
          label: 'Categorias'
        ), */
        BottomNavigationBarItem(
          icon: Icon( Icons.favorite_outline),
          label: 'Favoritos'
        ),
      ]
    );
  }
}