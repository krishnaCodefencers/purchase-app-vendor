import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchase_vendor/helper/toast_helper.dart';
import 'package:purchase_vendor/modules/auth/forgot_password/forgot_password_screen.dart';
import 'package:purchase_vendor/modules/new_design/presentation/new_design_screen.dart';
import 'package:purchase_vendor/utils/app_colors.dart';
import 'package:purchase_vendor/utils/appconfig.dart';
import 'package:purchase_vendor/utils/appvalidator.dart';
import 'package:purchase_vendor/utils/country_utils.dart';
import 'package:purchase_vendor/widgets/custom_text_field.dart';
import 'package:purchase_vendor/widgets/round_button.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var selectedCountry = Country.parse('IN');
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;

  final bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.redColor1,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'key_login_first_discription'.tr,
                  style: const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(
                  height: 9,
                ),
                Text(
                  'key_discrption_name'.tr,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
                ),
                SizedBox(
                  height: 124,
                ),
                Text(
                  'key_log_in'.tr,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w300, color: AppColors.whiteColor.withOpacity(0.8)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: !isFirstSubmit ? AutovalidateMode.always : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildPhoneNumber(),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildPasswordWidget(),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildForgotPassword(),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildLoginButton()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          child: Text(
            'key_forgot_password'.tr,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: AppColors.whiteColor),
          ),
          onTap: () {
            Get.to(ForgotPasswordScreen());
          },
        ),
      ],
    );
  }

  RoundButton _buildLoginButton() {
    return RoundButton(
      buttonLabel: 'key_submit'.tr,
      isLoading: _isLoading,
      onTap: () async {
        setState(() {
          isFirstSubmit = false;
        });

        if (_formKey.currentState!.validate()) {
          if (_emailOrPhoneController.text == AppConfig.defMob && _passwordController.text == AppConfig.defPass) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('email', _emailOrPhoneController.text);
            Get.to(const NewDesignScreen());
          } else {
            showToast.toastMessage('Invalid Credentials');
          }
          Get.to(const NewDesignScreen());
        }
        print("done");
      },
      borderColor: AppColors.greyColor0,
      color: AppColors.redColor1,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      fontFamily: 'Lato',
    );
  }

  _buildPasswordWidget() {
    return TextFieldWidget(
      textController: _passwordController,
      isReadOnly: false,
      keyboardType: TextInputType.text,
      isObscureText: true,
      hintText: 'key_enter_password'.tr,
      validator: Validation().passwordValidation,
    );
  }

  Container _buildPhoneNumber() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          buildCountryPicker(context),
          const SizedBox(
            width: 30,
            height: 30,
            child: VerticalDivider(
              color: AppColors.greyColor6,
            ),
          ),
          Expanded(
            child: TextFieldWidget(
              textController: _emailOrPhoneController,
              isReadOnly: false,
              keyboardType: TextInputType.text,
              isObscureText: false,
              hintText: 'key_enter_number'.tr,
              validator: Validation().emailAndPhoneValidation,
            ),
          )
        ],
      ),
    );
  }

  InkWell buildCountryPicker(BuildContext context) {
    return InkWell(
      onTap: () {
        // showCountryPicker(
        //   countryFilter: [
        //     "IN",
        //   ],
        //   countryListTheme:
        //       CountryListThemeData(borderRadius: BorderRadius.circular(15)),
        //   context: context,
        //   showPhoneCode:
        //       true, // optional. Shows phone code before the country name.
        //   onSelect: (Country country) {
        //     setState(() {
        //       selectedCountry = country;
        //     });
        //   },
        // );
      },
      child: Row(
        children: [
          Text(
            CountryUtils.countryCodeToEmoji(selectedCountry.countryCode),
          ),
          SizedBox(
            width: 10,
          ),
          // const Icon(Icons.keyboard_arrow_down),
          Center(child: Text('+${selectedCountry.phoneCode}')),
        ],
      ),
    );
  }

  bool isPasswordValid(String password) => password.length <= 8;
  bool isEmailValid(String email) {
    String patternNum = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regexnum = RegExp(patternNum);
    return regexnum.hasMatch(email);
  }
}
