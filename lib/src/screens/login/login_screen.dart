import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tlm/src/screens/homescreen/home_screen.dart';
import 'package:tlm/src/screens/login/model/req_login.dart';
import 'package:tlm/src/screens/login/model/version_model.dart';
import 'package:tlm/src/utils/constants/color_constants.dart';
import 'package:tlm/src/utils/constants/common_function.dart';
import 'package:tlm/src/utils/constants/image_constants.dart';
import 'package:tlm/src/utils/constants/textstyle_constant.dart';
import 'package:tlm/src/utils/dialog_utils.dart';
import 'package:tlm/src/utils/http/data_utils.dart';
import 'package:tlm/src/utils/sharedpreference/shared_preferences_keys.dart';
import 'package:tlm/src/widget/custom_elevated_button.dart';
import 'package:tlm/src/widget/custom_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  late Version _version;
  final ValueNotifier<bool> _isUpdate = ValueNotifier(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);

  @override
  void initState() {
    getVersionInfo();
    getPassword();
    // _emailController.text = "admin@gmail.com";
    // _passController.text = "admin";
    super.initState();
  }

  Future<void> getVersionInfo() async {
    _isLoading.value = true;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;

    await dataUtils.version(context).then((value) {
      if (version != value.version) {
        _isUpdate.value = true;
        _version = value;
        setState(() {});
      } else {
        _isUpdate.value = false;
      }
    });
    _isLoading.value = false;
  }

  Future<void> getPassword() async {
    await readAndDecryptString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ValueListenableBuilder(
        valueListenable: _isLoading,
        builder: (context, isLoading, child) => isLoading
            ? const Center(
                child: CircularProgressIndicator(color: primaryButtonColor),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 50),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 50,
                        top: 0,
                        child: Image.asset(
                          icNorthStar,
                          width: 80,
                          height: 80,
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: ValueListenableBuilder(
                            valueListenable: _isUpdate,
                            builder: (context, value, child) => Column(
                              children: [
                                Image.asset(
                                  icTLM,
                                  width: 300,
                                  height: 300,
                                ),
                                const SizedBox(height: 20),
                                if (!value) ...[
                                  CustomTextField(
                                    controller: _emailController,
                                    focusNode: _emailFocus,
                                    title: 'Username',
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    controller: _passController,
                                    focusNode: _passFocus,
                                    title: 'Password',
                                    obscureText: true,
                                  ),
                                  const SizedBox(height: 30),
                                  CustomElevatedButton(
                                    width: MediaQuery.of(context).size.width,
                                    buttonLabel: "Sign In",
                                    onPressed: _login,
                                  ),
                                ],
                                if (value) ...[
                                  Text(
                                    _version.message!,
                                    style: styleSegoeBold(
                                        16, primaryTextColorLight),
                                  ),
                                  const SizedBox(height: 30),
                                  CustomElevatedButton(
                                    width: MediaQuery.of(context).size.width,
                                    buttonLabel: "Download",
                                    onPressed: () async {
                                      var url = Uri.parse("https://api.tlm.northstar.edu.in/download");
                                      if (!await launchUrl(url)) {
                                        throw Exception(
                                            'Could not launch $url');
                                      }
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  _login() async {
    try {
      var req = ReqLogin(
        password: _passController.text,
        email: _emailController.text,
      );
      await dataUtils.login(req, context).then((value) {
        if (value.token != null && value.user != null) {
          setUserToken(value.token);
          setUserId(value.user!.id);
          setUserName(value.user!.name);
          setUserEmail(value.user!.email);
          setUserEmpCode(value.user!.employeeCode);
          setUserRole(value.user!.role);
          setUserStatus(value.user!.status);

          if (value.status ?? false) {
            setLoggedIn(true);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                DialogUtils.displaySnackBar(
                    message: value.message ??
                        "Something went wrong, please try again."));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              DialogUtils.displaySnackBar(
                  message: value.message ??
                      "Something went wrong, please try again."));
        }
      });
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(DialogUtils.displaySnackBar(
          message: "Something went wrong, please try again."));
    }
  }
}
