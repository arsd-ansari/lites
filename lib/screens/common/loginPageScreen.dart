import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/essentialdialog_model.dart';
import '../../models/responses/common/LoginModel.dart';
import '../../repository/masterApi/authClient.dart';
import '../../utils/AppConstants.dart';
import '../../utils/EncryptionHelper.dart';
import '../../utils/IpHelper.dart';
import '../../utils/assets_app.dart';
import '../../utils/colors_app.dart';
import '../../utils/constants.dart';
import '../../utils/dimen_app.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/storageService.dart';
import '../../utils/string_app.dart';
import 'dart:math';

class LoginPage extends StatefulWidget {
  String routeName = '/LoginPage';
   LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  EssentialDialogModel appDialog = EssentialDialogModel();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobilenumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late bool _isObscure;
  late FocusNode usernameFocusNode;
  late FocusNode passwordFocusNode;

  late String _generatedCaptcha;
  String _enteredCaptcha = '';
  bool _isCaptchaEditing = true;

  String classname = 'LoginPage';

  @override
  void initState() {
    super.initState();
    _isObscure = true;
    usernameFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    final rand = Random();
    _generatedCaptcha = List.generate(5, (_) => rand.nextInt(10).toString()).join();
    _enteredCaptcha = '';
    _isCaptchaEditing = true;
    setState(() {});
  }

  @override
  void dispose() {
    _mobilenumberController.dispose();
    _passwordController.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(Dimen_App().margin_edgeinsets_20),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                SizedBox(height: Dimen_App().sizedbox_height_10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Text(
                    String_App().rajDepartment,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Image.asset(
                  AssetsApp().appLogo,
                  height: 200,
                  width: 340,
                ),
                SizedBox(height: Dimen_App().sizedbox_height_50),
                _userNameTextField(),
                SizedBox(height: Dimen_App().sizedbox_height_10),
                _passwordTextField(),
                SizedBox(height: Dimen_App().sizedbox_height_10),
                _buildCaptchaSection(),
                SizedBox(height: Dimen_App().sizedbox_height_20),
                _loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _userNameTextField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      focusNode: usernameFocusNode,
      controller: _mobilenumberController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimen_App().borderRadius_circular_30),
        ),
        prefixIcon: const Icon(Icons.account_circle),
        hintText: String_App().login_05,
        labelText: String_App().login_06,
      ),
    );
  }

  Widget _passwordTextField() {
    return TextField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.deny(RegExp(" ")),
      ],
      obscureText: _isObscure,
      maxLength: Dimen_App().maxlength_25,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      controller: _passwordController,
      focusNode: passwordFocusNode,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimen_App().borderRadius_circular_30),
        ),
        prefixIcon: const Icon(Icons.lock),
        hintText: String_App().login_07,
        labelText: String_App().login_08,
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
    );
  }

  Widget _buildCaptchaSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 350;

        return isNarrow
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildCaptchaBox(),
                const SizedBox(width: 8),
                _buildRefreshIcon(),
              ],
            ),
            const SizedBox(height: 8),
            _buildCaptchaInput(),
          ],
        )
            : Row(
          children: [
            _buildCaptchaBox(),
            const SizedBox(width: 12),
            Expanded(child: _buildCaptchaInput()),
            const SizedBox(width: 8),
            _buildRefreshIcon(),
          ],
        );
      },
    );
  }


  Widget _buildCaptchaBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _generatedCaptcha,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 10,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildCaptchaInput() {
    return TextField(
      keyboardType: TextInputType.number,
      maxLength: 5,
      decoration: const InputDecoration(
        hintText: 'Enter CAPTCHA',
        counterText: '',
        border: UnderlineInputBorder(),
      ),
      onChanged: (value) {
        _enteredCaptcha = value;
      },
    );
  }

  Widget _buildRefreshIcon() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      tooltip: 'Reload CAPTCHA',
      onPressed: _generateCaptcha,
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: Dimen_App().sizedbox_width_300,
      height: Dimen_App().sizedbox_height_50,
      child: ElevatedButton(
        onPressed: () async {
          final isValid = await _validationPassword();
          if (isValid) {
            final hasConnection = await Constants.checkConnectivity();
            if (hasConnection) {
              await login();
            } else {
              appDialog = EssentialDialogModel();
              appDialog.appMessage = String_App().nointernet;
              await EssentialDialogs().showNoInternetDialog(context, appDialog);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors_App().whitecolor,
          backgroundColor: Colors_App().main_color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimen_App().borderRadius_circular_35),
          ),
          elevation: 15.0,
        ),
        child: Padding(
          padding: EdgeInsets.all(Dimen_App().padding_edgeinsets_15),
          child: Text(
            String_App().login_04,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _validationPassword() async {
    appDialog = EssentialDialogModel();

    if (_mobilenumberController.text.trim().isEmpty) {
      appDialog.appTitle = String_App().appname;
      appDialog.appMessage = String_App().login_00;
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
      usernameFocusNode.requestFocus();
      return false;
    } else if (_passwordController.text.trim().isEmpty) {
      appDialog.appTitle = String_App().appname;
      appDialog.appMessage = String_App().login_02;
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
      passwordFocusNode.requestFocus();
      return false;
    } else if (_enteredCaptcha != _generatedCaptcha) {
      appDialog.appTitle = String_App().appname;
      appDialog.appMessage = "CAPTCHA does not match. Please try again.";
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
      _generateCaptcha();
      return false;
    }

    return true;
  }

  Future<void> login() async {
    try {
      EssentialDialogs().showProgressHud(context, true);
      AuthClient client = await ApiServiceAuthclient.createService();

      final ip = await IpHelper.getIpForLogin();
      LoginReqModel req = LoginReqModel()
        ..username = _mobilenumberController.text.trim()
        ..password = _passwordController.text.trim()
        ..ipAddress = ip;

      if (kDebugMode) {
        print('Login Request: ${jsonEncode(req.toJson())}');
      }

      final encryptedData = await EncryptionHelper.encryptData(req.toJson());
      final encryptedRequest = {"data": encryptedData};
      final encryptedResponse = await client.login(encryptedRequest);
      final responseJson = jsonDecode(encryptedResponse);
      final decryptedMap =await EncryptionHelper.decryptData(responseJson["Data"]);

      final response = LoginResModel.fromJson( decryptedMap);
      EssentialDialogs().showProgressHud(context, false);

      if (response.status == true) {
        final authData = response.authenticationResponse!.first;
        await AppConstants.saveToken(authData.authToken ?? '');
        await SecureStorageService.write(key: 'authToken', value: authData.authToken ?? '');
        await SecureStorageService.write(key: 'tokenTimestamp', value: DateTime.now().toIso8601String());
        await SecureStorageService.write(key: 'tokenExpiresIn', value: authData.expiresIn?.toString() ?? '86399');
        AppConstants.user = response;

        if (!mounted) return;
        await Constants().moduleRedirect(context);
      } else {
        final appDialog = EssentialDialogModel()
          ..appTitle = String_App().appname
          ..appMessage = response.message ?? "Something went wrong.";
        await EssentialDialogs().openOkDismissDialog(context, appDialog);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Login Error: $e');
        print(stackTrace);
      }
      EssentialDialogs().showProgressHud(context, false);
      final appDialog = EssentialDialogModel()
        ..appTitle = String_App().appname
        ..appMessage = "An unexpected error occurred.";
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
    }
  }
}
