import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lites/utils/routes.dart';
import 'package:lites/utils/string_app.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/essentialdialog_model.dart';
import 'AppConstants.dart';
import 'RequestPermissionManager.dart';
import 'colors_app.dart';
import 'dimen_app.dart';
import 'essentialdialog.dart';
import 'gpsService.dart';

class Constants {
  String classname = 'Constants';
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static bool EditAndAdd = true;
  static bool cholesterolAndBloodglucose = true;

  // final List<String> columnTitles;
  // final List<List<String>> rowData;
  /// true = portrait only or false = landscape and portrait
  bool landpor = true;
  static String version = '', imeinumber = '', refType = '', ostype = '';
  static double? latitude;
  static double? longitude;

  static Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getbasicdetails() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      AndroidDeviceInfo androidbuild;
      IosDeviceInfo iosbuild;

      // Check and request location permission
      await GPSLocatorService().getLatLong();
      if (Platform.isAndroid) {
        androidbuild = await deviceInfoPlugin.androidInfo;
        if (await Permission.phone.request().isGranted) {
          imeinumber = await getAndroidDeviceImei();
        }
        if(await RequestPermissionManager.checkPermissionStatus()){
          print("Permission granted successfully.");
        }else{
          await RequestPermissionManager.requestPermission();
        }

        if(await RequestPermissionManager.checkMultiplePermissionStatus()){
          print("Storage permission granted successfully.");
        }else{
          if(await RequestPermissionManager.requestMultiplePermission()){
            print("Storage permission granted successfully after requesting.");
          }
        }
        debugPrint(imeinumber);
        refType = 'ANDROID';
        ostype = androidbuild.version.release;
      } else if (Platform.isIOS) {
        iosbuild = await deviceInfoPlugin.iosInfo;
        imeinumber = iosbuild.identifierForVendor!;
        refType = 'IOS';
        ostype = iosbuild.systemVersion!;
      }
      version = packageInfo.version;
    } catch (ex) {
      print('exception---$ex');
    }
  }

  Future<String> getAndroidDeviceImei() async {
    String imei = "";
    try {
      const platform = MethodChannel('rti.flutter.dev');
      final result = await platform.invokeMethod<String>('getDeviceImei');
      imei = result ?? "";
    } on PlatformException catch (e) {
      debugPrint("Failed to get imei Number for android: '${e.message}'.");
      imei = "";
    }
    return imei;
  }

  Future<bool> ifWifiConnected() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }



  Future<void> moduleRedirect(BuildContext context) async {
    if (AppConstants.user?.authenticationResponse?[0].loginUserData?.roleName.toString() == "SA") {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes().citizenHomeScreen,
              (route) => false,
        );
      }
      else {
        EssentialDialogModel appDialog = EssentialDialogModel();
        appDialog.appTitle = String_App().appname;
        appDialog.appMessage =
        "Sorry you are not authorized \n to access this application\n Please contact support team";
        await EssentialDialogs().openOkDismissDialog(context, appDialog);

    }

    /*Navigator.pushNamedAndRemoveUntil(
      context,
      Routes().citizenHomeScreen,
      (route) => false,
    );*/
  }

  Widget buildRadioRow(String label, bool? selected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: selected,
                  onChanged: null, // Makes it read-only
                ),
                const Text('Yes'),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                Radio<bool>(
                  value: false,
                  groupValue: selected,
                  onChanged: null, // Makes it read-only
                ),
                const Text('No'),
              ],
            ),
          ],
        ),
      ],
    );
  }



  Widget buildSectionCard(List<Widget> children) {
    return Card(
      // margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors_App().main_color),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  /*Widget buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(label),
      ],
    );
  }*/

  Widget buildCheckbox(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Flexible(
          child: Text(label, overflow: TextOverflow.ellipsis, maxLines: 2),
        ),
      ],
    );
  }

  Widget buildSectionTitle(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.all(8),
      color: Colors.blue.shade100,
      width: double.infinity,
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  //fine
  /*Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }*/

  //without hint
  /*Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        keyboardType: TextInputType.number, // assuming case number is numeric
      ),
    );
  }*/
  Widget buildTextField(String label, TextEditingController controller, {String hint = '', TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The external label
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
            keyboardType:keyboardType ?? TextInputType.number,
          ),
        ],
      ),
    );
  }


  /*Widget buildTextFieldReadOnly(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        initialValue: value.isNotEmpty ? value : '-',
        readOnly: true,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          disabledBorder: const OutlineInputBorder(), // ensures border appears
        ),
        style: const TextStyle(color: Colors.black), // keeps text visible
      ),
    );
  }*/

  Widget buildTextFieldReadOnly(String label, String value) {
    final controller = TextEditingController(text: value.isNotEmpty ? value : '-');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label (outside the border, in black color)
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            readOnly: true,
            enabled: false,
            style: const TextStyle(color: Colors.grey), // Value in light grey
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              disabledBorder: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildAstrickTextField(String label) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      maxLines: Dimen_App().maxLines_1,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            Dimen_App().borderRadius_circular_5,
          ),
        ),

        label: RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Colors_App().blackcolor,
              fontSize: Dimen_App().fontSize_15,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors_App().redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ), // Adjust height here
        ),
        dropdownColor: Colors.white,
        style: TextStyle(color: Colors.black, fontSize: 14),
        // Optional: adjust font size
        items:
            [
              'Select',
              'Option 1',
              'Option 2',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (value) {},
      ),
    );
  }

  Widget buildSelectDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: 'Select',
        // <-- Default selected value
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        dropdownColor: Colors.white,
        items:
            [
              'Select',
              'Option 1',
              'Option 2',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (value) {
          // handle the new value
        },
      ),
    );
  }

  Widget buildAstrickDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                color: Colors.black, // Regular label color
                fontSize: Dimen_App().fontSize_15,
                // Font size of label
              ),
              children: [
                TextSpan(
                  text: ' *', // Asterisk indicating required field
                  style: TextStyle(
                    color: Colors.red, // Make the asterisk red
                    fontWeight: FontWeight.bold, // Make the asterisk bold
                  ),
                ),
              ],
            ),
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: null,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),
            ),
            dropdownColor: Colors.white,
            items:
                ['Select', 'Option 1', 'Option 2']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  Widget buildLitesSelectDropdown({
    required String label,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        isExpanded: true, // Ensures the dropdown takes full width
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
        ),
        dropdownColor: Colors.white,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option,
              overflow: TextOverflow.ellipsis, // Handles overflow
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }



  /* Widget _gender_textfield() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom label with red asterisk
        RichText(
          text: TextSpan(
            text: 'Gender',
            style: TextStyle(
              color: Colors.black, // Regular label color
              fontSize: Dimen_App().fontSize_15, // Font size of label
            ),
            children: [
              TextSpan(
                text: ' *',  // Asterisk indicating required field
                style: TextStyle(
                  color: Colors.red,  // Make the asterisk red
                  fontWeight: FontWeight.bold,  // Make the asterisk bold
                ),
              ),
            ],
          ),
        ),
        // Dropdown button for gender
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: null,  // Remove the labelText from here
            border: OutlineInputBorder(),
          ),
          isExpanded: true,
          value: selectedGender,
          focusNode: genderFocusNode,
          dropdownColor: Colors.white, // Optional: for dropdown background
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
  }*/

  void presentDatePicker(
    BuildContext context, {
    required Function(String) onDatePicked,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null) {
        final formatted = DateFormat('dd/MM/yyyy').format(pickedDate);
        onDatePicked(formatted);
      }
    });
  }
  void presentDatePickerDiffFormat(
      BuildContext context, {
        required Function(String) onDatePicked,
      }) {
    FocusManager.instance.primaryFocus?.unfocus();
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null) {
        final fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          11, 59, 34, 874,
        ).toUtc();

        final formatted = fullDateTime.toIso8601String();
        onDatePicked(formatted);
      }
    });
  }

  String isoUtcWithMillis(DateTime dt) {
    return dt.toUtc().toIso8601String().split('.').first + '.' +
        dt.millisecond.toString().padLeft(3, '0') + 'Z';
  }
 /* Widget buildDatePickerTile({
    required String label,
    required String? selectedDate,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors_App().deepGrey),
      ),
      child: ListTile(
        title: RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Colors_App().blackcolor,
              fontSize: Dimen_App().fontSize_12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        subtitle: Text(
          selectedDate ?? 'dd/mm/yyyy',
          style: TextStyle(fontSize: Dimen_App().fontSize_14),
        ),
        trailing: Icon(
          Icons.calendar_month,
          color: Colors_App().main_color,
          size: 15,
        ),
        onTap: onTap,
      ),
    );
  }*/

  Widget buildDatePickerTile({
    required String label,
    required String? selectedDate,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Dimen_App().fontSize_16,
              fontWeight: FontWeight.w500,
              color: Colors_App().blackcolor,
            ),
          ),
          const SizedBox(height: 4),
          // The container with the date value
          InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors_App().deepGrey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate ?? 'dd/mm/yyyy',
                    style: TextStyle(fontSize: Dimen_App().fontSize_16),
                  ),
                  Icon(
                    Icons.calendar_month,
                    color: Colors_App().main_color,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // without title
  /*Widget buildCustomDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.symmetric(
          inside: BorderSide(width: 1, color: Colors.grey.shade300),
          outside: BorderSide(width: 1, color: Colors.grey),
        ),
        columnWidths: const {
          0: FixedColumnWidth(80),
          1: FixedColumnWidth(180),
          2: FixedColumnWidth(100),
          3: FixedColumnWidth(100),
          4: FixedColumnWidth(200),
        },
        children: [
          // Header Row
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade200),
            children: [
              _buildCell('Sr. No', isHeader: true),
              _buildCell('Activity', isHeader: true),
              _buildCell('Date', isHeader: true),
              _buildCell('Number', isHeader: true),
              _buildCell('Remarks', isHeader: true),
            ],
          ),
          // Data Row
          TableRow(
            children: [
              _buildCell('1'),
              _buildCell('Application submitted'),
              _buildCell('15/03/24'),
              _buildCell('542134'),
              _buildCell('Info submitted'),
            ],
          ),
          TableRow(
            children: [
              _buildCell('2'),
              _buildCell('Application not submitted'),
              _buildCell('25/03/25'),
              _buildCell('5811234'),
              _buildCell('Info not recieved'),
            ],
          ),
          // Add more rows as needed
        ],
      ),
    );
  }

  Widget _buildCell(String text, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }*/

  //without icon
  /*Widget buildCustomDataTable({
    required List<String> columnTitles,
    required List<List<String>> rowData,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.symmetric(
          inside: const BorderSide(width: 1, color: Colors.grey),
          outside: const BorderSide(width: 1, color: Colors.black),
        ),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          // Header
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade300),
            children:
                columnTitles
                    .map((title) => _buildCell(title, isHeader: true))
                    .toList(),
          ),
          // Rows
          ...rowData.map((row) {
            return TableRow(
              children: row.map((cell) => _buildCell(cell)).toList(),
            );
          }).toList(),
        ],
      ),
    );
  }*/

  // with  icon
  Widget buildCustomDataTableWithIcon({
    required List<String> columnTitles,
    required List<List<String>> rowData,
    Map<int, IconData>? iconColumns, // Optional: column index to icon
    void Function(int rowIndex, int columnIndex)? onIconPressed,
    void Function(int rowIndex, String cnr)? onCnrPressed,
  })
  {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.symmetric(
          inside: const BorderSide(width: 1, color: Colors.grey),
          outside: const BorderSide(width: 1, color: Colors.black),
        ),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          // Header
          TableRow(
            decoration: BoxDecoration(color: Colors.blue.shade100),
            children:
            columnTitles.map((title) => _buildCell(title, isHeader: true)).toList(),
          ),
          // Rows
          ...rowData.asMap().entries.map((entry) {
            final rowIndex = entry.key;
            final row = entry.value;
            return TableRow(
              children: List.generate(row.length, (colIndex) {
                if (iconColumns != null && iconColumns.containsKey(colIndex)) {
                  return _buildIconCell(
                    icon: iconColumns[colIndex]!,
                    onPressed: () {
                      if (onIconPressed != null) {
                        onIconPressed(rowIndex, colIndex);
                      }
                    },
                  );
                } else if (colIndex == 0 && onCnrPressed != null) {

                  return GestureDetector(
                    onTap: () {
                        onCnrPressed(rowIndex, row[colIndex]);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        row[colIndex],
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else {
                  return _buildCell(row[colIndex]);
                }
              }),
            );
          }).toList(),
        ],
      ),
    );
  }

  //working fine but no text column is clickable
/*  Widget buildCustomDataTable({
    required String screenTitle,
    required List<List<String>> rowData,
    Map<int, IconData>? iconColumns,
    void Function(int rowIndex, int columnIndex)? onIconPressed,
  })
  {
    List<String> columnTitles = getColumnTitlesForScreen(screenTitle);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.symmetric(
          inside: const BorderSide(width: 1, color: Colors.grey),
          outside: const BorderSide(width: 1, color: Colors.black),
        ),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade300),
            children: columnTitles.map((title) => _buildCell(title, isHeader: true)).toList(),
          ),
          // Data Rows
          ...rowData.asMap().entries.map((entry) {
            final rowIndex = entry.key;
            final row = entry.value;
            return TableRow(
              children: List.generate(row.length, (colIndex) {
                if (iconColumns != null && iconColumns.containsKey(colIndex)) {
                  return _buildIconCell(
                    icon: iconColumns[colIndex]!,
                    onPressed: () {
                      if (onIconPressed != null) {
                        onIconPressed(rowIndex, colIndex);
                      }
                    },
                  );
                } else {
                  return _buildCell(row[colIndex]);
                }
              }),
            );
          }).toList(),
        ],
      ),
    );
  }*/

  Widget buildCustomDataTable({
    required String screenTitle,
    required List<List<String>> rowData,
    Map<int, IconData>? iconColumns,
    Set<int>? clickableColumns, // 👈 NEW: Optional set of clickable column indexes
    void Function(int rowIndex, int columnIndex)? onIconPressed,
  }) {
    List<String> columnTitles = getColumnTitlesForScreen(screenTitle);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.symmetric(
          inside: const BorderSide(width: 1, color: Colors.grey),
          outside: const BorderSide(width: 1, color: Colors.black),
        ),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          // Table Header
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade300),
            children: columnTitles.map((title) => _buildCell(title, isHeader: true)).toList(),
          ),

          // Table Rows
          ...rowData.asMap().entries.map((entry) {
            final rowIndex = entry.key;
            final row = entry.value;

            return TableRow(
              children: List.generate(row.length, (colIndex) {
                final cellValue = row[colIndex];

                // Icon cell
                if (iconColumns != null && iconColumns.containsKey(colIndex)) {
                  return _buildIconCell(
                    icon: iconColumns[colIndex]!,
                    onPressed: () {
                      onIconPressed?.call(rowIndex, colIndex);
                    },
                  );
                }

                // Clickable logic
                if (clickableColumns?.contains(colIndex) == true) {
                  final parts = cellValue.split(' /');
                  final number = parts[0];
                  final date = parts.length > 1 ? parts[1] : '';

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            onIconPressed?.call(rowIndex, colIndex);
                          },
                          child: Text(
                            number,
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        if (date.isNotEmpty) Text(' /$date'),
                      ],
                    ),
                  );
                }

                // Default: non-clickable
                return _buildCell(cellValue);
              }),
            );
          }).toList(),
        ],
      ),
    );
  }


  Widget _buildIconCell({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors_App().main_color),
        onPressed: onPressed,
      ),
    );
  }

  List<String> getColumnTitlesForScreen(String screenTitle) {
    switch (screenTitle) {
      case 'Case List':
        return [
          'Sr No',
          'Case No',
          'Abbreviation',
          'Case Year',
          'Court Name, Court Place',
          'Performa/Main',
          'CNR No',
          'Action',
        ];
      case 'AlertBox':
        return ['Sr. No', 'Information'];
      default:
        return ['Sr. No', 'Application No.', 'Applicant Name', 'Submit Date', 'District Name', 'Department Name', 'Office Name',
    'Life/Liberty', 'Application Submitted To', 'Status'];
    }
  }


  Widget _buildCell(String text, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget buildFinalDropdownField<T>({
    required String label,
    required List<T> options,
    required T? selectedValue,
    required ValueChanged<T?> onChanged,
    required String Function(T) labelExtractor,
    String selectHint = 'Select',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: selectedValue,
              hint: Text(selectHint),
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              onChanged: onChanged,
              items: [
                DropdownMenuItem<T>(
                  value: null,
                  child: Text('-- $selectHint --'),
                ),
                ...options.map<DropdownMenuItem<T>>((T value) {
                  return DropdownMenuItem<T>(
                    value: value,
                    child: Text(labelExtractor(value)),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

}
