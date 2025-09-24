import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/essentialdialog_model.dart';
import '../../utils/colors_app.dart';
import '../../utils/constants.dart';
import '../../utils/dimen_app.dart';
import '../../utils/essentialdialog.dart';
import '../../utils/routes.dart';
import '../../utils/string_app.dart';


class UpdateProfile extends StatefulWidget {
  String routeName = '/UpdateProfile';
  UpdateProfile({Key? key}) : super(key: key);
  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  EssentialDialogModel appDialog = EssentialDialogModel();
  String? selectedDob;
  String? selectedDistrict;
  String? selectedCategory;
  String? selectedGender;
  final List<String> districts = ['Jaipur', 'Alwar'];
  final List<String> category = ['Rural', 'Urban'];
  final List<String> genderList = ['Female', 'Male', 'Other'];
  TextEditingController _applicant_controller = TextEditingController();
  TextEditingController _spouse_controller = TextEditingController();
  TextEditingController _aadhar_controller = TextEditingController();
  TextEditingController _email_controller = TextEditingController();
  TextEditingController _address_controller = TextEditingController();
  TextEditingController _pincode_controller = TextEditingController();
  TextEditingController _mobilenumber_controller = TextEditingController();
  late FocusNode applicantFocusNode;
  late FocusNode spouseFocusNode;
  late FocusNode aadharFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode addressFocusNode;
  late FocusNode pincodeFocusNode;
  late FocusNode mobilenumberFocusNode;
  late FocusNode districtFocusNode;
  late FocusNode dobFocusNode;
  late FocusNode categoryFocusNode;
  late FocusNode genderFocusNode;

  String classname = 'UpdateProfile';


  @override
  void initState() {
    super.initState();
    _applicant_controller = TextEditingController();
    _spouse_controller = TextEditingController();
    applicantFocusNode = FocusNode();
    spouseFocusNode = FocusNode();
    aadharFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    addressFocusNode = FocusNode();
    pincodeFocusNode = FocusNode();
    mobilenumberFocusNode = FocusNode();
    districtFocusNode = FocusNode();
    dobFocusNode = FocusNode();
    categoryFocusNode = FocusNode();
    genderFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _applicant_controller.dispose();
    _spouse_controller.dispose();
    applicantFocusNode.dispose();
    spouseFocusNode.dispose();
    aadharFocusNode.dispose();
    emailFocusNode.dispose();
    addressFocusNode.dispose();
    pincodeFocusNode.dispose();
    mobilenumberFocusNode.dispose();
    districtFocusNode.dispose();
    dobFocusNode.dispose();
    categoryFocusNode.dispose();
    genderFocusNode.dispose();
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
        appBar:AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors_App().main_color,
          elevation: 5.0,
          shadowColor: Colors.black,
          toolbarHeight: 74,
          title: Center(
            child: Text(
              String_App().personalInfo,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),


          centerTitle: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(Dimen_App().borderRadius_circular_25),
              bottomRight: Radius.circular(Dimen_App().borderRadius_circular_25),
            ),
          ),

        ),

        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(Dimen_App().margin_edgeinsets_20),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                SizedBox(height: Dimen_App().sizedbox_height_10),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Text(
                    "Welcome User",
                    style: TextStyle(color: Colors_App().main_color, fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: Dimen_App().sizedbox_height_20),
                Constants().buildAstrickTextField(String_App().applicantName),
                SizedBox(height: Dimen_App().sizedbox_height_20),
                Constants().buildAstrickTextField(String_App().fatherName),
                SizedBox(height: Dimen_App().sizedbox_height_20),
                _gender_textfield(),
                SizedBox(height: Dimen_App().sizedbox_height_20),
                _aadhar_textfield(),
                SizedBox(height: Dimen_App().sizedbox_height_20),
                Constants().buildDatePickerTile(
                  label: 'Date Of Birth',
                  selectedDate: selectedDob,
                  onTap: () {
                    Constants().presentDatePicker(context, onDatePicked: (date) {
                      setState(() => selectedDob = date);
                    });
                  },
                ),
                SizedBox(height: Dimen_App().sizedbox_height_20),
                Constants().buildAstrickTextField(String_App().emailId),
                SizedBox(height: Dimen_App().sizedbox_height_20),
                Constants().buildAstrickTextField(String_App().address),
                SizedBox(height: Dimen_App().sizedbox_height_20),
                _pincode_textfield(),
                SizedBox(height: Dimen_App().sizedbox_height_20),
                _mobilenumber_textfield(),
                SizedBox(height: Dimen_App().sizedbox_height_20),
                Constants().buildDropdown(String_App().district),
                SizedBox(height: Dimen_App().sizedbox_height_20),
                Constants().buildDropdown(String_App().selectCategory),
                SizedBox(height: Dimen_App().sizedbox_height_20),
                _submitbutton(),
                SizedBox(height: Dimen_App().sizedbox_height_20),
              ],
            ),
          ),
        ),
      ),
    );
  }
  /// Widget Section

  Widget _gender_textfield() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Gender',
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimen_App().fontSize_15,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: null,
            border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10)
          ),
          isExpanded: true,
          value: selectedGender,
          focusNode: genderFocusNode,
          dropdownColor: Colors.white,
          onChanged: (String? newValue) {
            setState(() {
              selectedGender = newValue!;
            });
          },
          items: genderList.map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _aadhar_textfield() {
    return TextField(
      maxLength: Dimen_App().maxlength_12,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      maxLines: Dimen_App().maxLines_1,
      focusNode: aadharFocusNode,
      controller: _aadhar_controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(Dimen_App().borderRadius_circular_5),
        ),
        label: RichText(
          text: TextSpan(
              text: String_App().aadharNumber,
              style: TextStyle(
                  color: Colors_App().blackcolor,
                  fontSize: Dimen_App().fontSize_15,
                  fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: ' ',
                  style: TextStyle(
                    color: Colors_App().redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ]),
        ),
      ),
    );
  }

  Widget _pincode_textfield() {
    return TextField(
      maxLength: Dimen_App().maxlength_6,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      maxLines: Dimen_App().maxLines_1,
      focusNode: pincodeFocusNode,
      controller: _pincode_controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(Dimen_App().borderRadius_circular_5),
        ),

        label: RichText(
          text: TextSpan(
              text: String_App().pincode,
              style: TextStyle(
                  color: Colors_App().blackcolor,
                  fontSize: Dimen_App().fontSize_15,
                  fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: ' ',
                  style: TextStyle(
                    color: Colors_App().redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ]),
        ),
      ),
    );
  }

  Widget _mobilenumber_textfield() {
    return TextField(
      maxLength: Dimen_App().maxlength_10,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      maxLines: Dimen_App().maxLines_1,
      focusNode: mobilenumberFocusNode,
      controller: _mobilenumber_controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(Dimen_App().borderRadius_circular_5),
        ),
        label: RichText(
          text: TextSpan(
              text: String_App().mobileNo,
              style: TextStyle(
                  color: Colors_App().blackcolor,
                  fontSize: Dimen_App().fontSize_15,
                  fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors_App().redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ]),
        ),
      ),
    );
  }

  Widget _submitbutton() {
    return SizedBox(
      width: Dimen_App().sizedbox_width_300,
      height: Dimen_App().sizedbox_height_50,
      child: ElevatedButton(
        onPressed: () async => {
        await saveResponse()
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors_App().whitecolor,
          backgroundColor: Colors_App().main_color,
          //change text color of button
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(Dimen_App().borderRadius_circular_35),
          ),
          elevation: 15.0,
        ),
        child: Padding(
          padding: EdgeInsets.all(Dimen_App().padding_edgeinsets_15),
          child: Text(
            String_App().submit,
          ),
        ),
      ),
    );
  }

  /// Validation Section
  Future<bool> _validationBeforeSubmit() async {
    appDialog = EssentialDialogModel();
    if (_applicant_controller.text.toString().trim().isEmpty) {
      appDialog.appMessage = String_App().updateName;
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
      applicantFocusNode.requestFocus();
      return false;
    } else if (_spouse_controller.text.toString().trim().isEmpty) {
      appDialog.appMessage = String_App().updateFName;
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
      spouseFocusNode.requestFocus();
      return false;
    }else if (selectedGender == null) {
      appDialog.appMessage = String_App().updateGender;
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
      genderFocusNode.requestFocus();
      return false;
    }else if (selectedDob == null) {
      appDialog.appMessage = String_App().updateDob;
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
      dobFocusNode.requestFocus();
      return false;
    }else if (_email_controller.text.toString().trim().isEmpty) {
      appDialog.appMessage = String_App().updateEmail;
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
      emailFocusNode.requestFocus();
      return false;
    }else if (_address_controller.text.toString().trim().isEmpty) {
      appDialog.appMessage = String_App().updateAddress;
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
      addressFocusNode.requestFocus();
      return false;
    }else if (_mobilenumber_controller.text.toString().trim().isEmpty) {
      appDialog.appMessage = String_App().updateMobNo;
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
      mobilenumberFocusNode.requestFocus();
      return false;
    }else if ( selectedDistrict == null) {
      appDialog.appMessage = String_App().updateDistrict;
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
      districtFocusNode.requestFocus();
      return false;
    }else if (selectedCategory == null) {
      appDialog.appMessage = String_App().updateCategory;
      await EssentialDialogs().openOkDismissDialog(context, appDialog);
      categoryFocusNode.requestFocus();
      return false;
    }
    return true;
  }

  Future saveResponse() async {

    await Constants().moduleRedirect(context);
    Navigator.pushNamed(
      context,
      Routes().citizenHomeScreen,
    );

  }

}
