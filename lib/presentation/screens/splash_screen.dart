import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async{
    await Future.delayed(const Duration(seconds:3));
    if(!mounted) return;

    final authProvider = context.read<AuthProvider>();

    authProvider.checkAuthStatus();

    if(authProvider.user != null){
      context.go('/home');
    }
    else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 1. CHANGED: Using SVG instead of Icon
            SvgPicture.asset(
              'assets/images/logo.svg',
              height: 230,
            ),

            const SizedBox(height: 20),


            const SizedBox(height: 20),

            const CircularProgressIndicator(color: Color(0xFF1DB954)),
          ],
        ),
      ),
    );
  }
}