import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/widget/widget.dart';



class HomeScreen extends StatelessWidget {
  
  static const name = 'home-screen';

  final StatefulNavigationShell currentChild;

  const HomeScreen({super.key, required this.currentChild});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: currentChild,
      bottomNavigationBar: location.startsWith('/movie') ? null : CusttomBottomNavegation( currentChild: currentChild,),
    );
  }
}

