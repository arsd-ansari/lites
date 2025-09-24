import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/assets_app.dart';
import '../../utils/colors_app.dart';
import '../../utils/routes.dart';
import '../../utils/storageService.dart';
import '../../utils/string_app.dart';

class SplashPage extends StatefulWidget {
  String routeName = '/SplashPage';
  SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
  //  await Constants().getbasicdetails();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () async {
        if (!mounted) return;

        await _checkLogin();
      });
    });
  }

  Future<void> _checkLogin() async {
    final authToken = await SecureStorageService.read(key: 'authToken');
    final timestampString = await SecureStorageService.read(key: 'tokenTimestamp');
    final expiresInString = await SecureStorageService.read(key: 'tokenExpiresIn');

    if (authToken == null || timestampString == null || expiresInString == null) {
      Navigator.of(context).pushReplacementNamed(Routes().loginPage);
      return;
    }

    final receivedTime = DateTime.parse(timestampString);
    final expiresIn = int.parse(expiresInString);
    final secondsElapsed = DateTime.now().difference(receivedTime).inSeconds;

    if (secondsElapsed < expiresIn) {
      Navigator.of(context).pushReplacementNamed(Routes().citizenHomeScreen);
    } else {
      await SecureStorageService.deleteAll();
      Navigator.of(context).pushReplacementNamed(Routes().loginPage);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors_App().whitecolor,
        body: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetsApp().appLogo,
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    String_App().appname,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

