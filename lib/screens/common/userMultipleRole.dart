import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lites/utils/colors_app.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserRole {
  final int srNo;
  final String roleName;
  final String name;
  final String departmentName;
  final String hodUnitName;
  final String officeName;

  UserRole({
    required this.srNo,
    required this.roleName,
    required this.name,
    required this.departmentName,
    required this.hodUnitName,
    required this.officeName,
  });
}

//  UserRoleDataSource
class UserRoleDataSource extends DataGridSource {
  List<DataGridRow> _userRolesDataGridRows = [];
  final ValueChanged<UserRole> onLoginPressed;

  UserRoleDataSource({required List<UserRole> userRoles, required this.onLoginPressed}) {
    _userRolesDataGridRows = userRoles.map<DataGridRow>((userRole) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'Sr No', value: userRole.srNo),
        DataGridCell<String>(columnName: 'Role Name', value: userRole.roleName),
        DataGridCell<String>(columnName: 'Name', value: userRole.name),
        DataGridCell<String>(columnName: 'Department Name', value: userRole.departmentName),
        DataGridCell<String>(columnName: 'HoD/Unit Name', value: userRole.hodUnitName),
        DataGridCell<String>(columnName: 'Office Name', value: userRole.officeName),
        DataGridCell<UserRole>(columnName: 'Action', value: userRole),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _userRolesDataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          if (dataGridCell.columnName == 'Action') {
            final UserRole userRole = dataGridCell.value as UserRole;
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: () => onLoginPressed(userRole),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors_App().main_color,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text('Login', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
              ),
            );
          }
          return Container(
            alignment: (dataGridCell.columnName == 'Sr No')
                ? Alignment.center
                : Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              dataGridCell.value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList());
  }
}

class UserRoleSelectionScreen extends StatefulWidget {
  const UserRoleSelectionScreen({super.key});

  @override
  State<UserRoleSelectionScreen> createState() => _UserRoleSelectionScreenState();
}

class _UserRoleSelectionScreenState extends State<UserRoleSelectionScreen> {
  late UserRoleDataSource _userRoleDataSource;
  List<UserRole> _userRoles = [];

  @override
  void initState() {
    super.initState();
    _populateUserRoles();
    _userRoleDataSource = UserRoleDataSource(
      userRoles: _userRoles,
      onLoginPressed: _onLoginButtonPressed,
    );
  }

  void _populateUserRoles() {
    _userRoles = [
      UserRole(
          srNo: 1,
          roleName: 'SA',
          name: 'Super Admin',
          departmentName: '',
          hodUnitName: '',
          officeName: ''),
      UserRole(
          srNo: 2,
          roleName: 'Department',
          name: 'Unit User',
          departmentName: 'Administrative Reforms and Co-ordination Department, Jaipur',
          hodUnitName: '',
          officeName: ''),
      UserRole(
          srNo: 3,
          roleName: 'Unit',
          name: 'Unit User',
          departmentName: 'Animal Husbandry, Fisheries and Dairy Development Department, Jaipur',
          hodUnitName: 'Animal Husbandry, Jaipur',
          officeName: ''),
      UserRole(
          srNo: 4,
          roleName: 'Unit',
          name: 'Unit',
          departmentName: 'Finance Department, Jaipur',
          hodUnitName: 'Commercial Taxes Department, Jaipur',
          officeName: ''),
      UserRole(
          srNo: 5,
          roleName: 'Office',
          name: 'Deputy Director SI&PF Jaisalmer',
          departmentName: 'Finance Department, Jaipur',
          hodUnitName: 'State insurance and Provident Fund Department, Jaipur',
          officeName: 'Deputy Director Jaisalmer'),
      UserRole(
          srNo: 6,
          roleName: 'Office',
          name: 'Office User',
          departmentName: 'Agriculture Department',
          hodUnitName: 'Agriculture Department, Jaipur',
          officeName: 'Joint Director Agriculture Jaipur'),
      UserRole(
          srNo: 7,
          roleName: 'Office',
          name: 'Suresh Kumar Sharma',
          departmentName: 'Agriculture Department',
          hodUnitName: 'JOJOBA PLANTATION',
          officeName: 'Agri Department'),
    ];
  }

  void _onLoginButtonPressed(UserRole role) {
    if(kDebugMode){

      print('Logging in with Role: ${role.roleName} - Name: ${role.name}');
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logging in as ${role.name} (${role.roleName})...')),
    );

    // Example navigation (replace with your actual navigation logic)
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => DashboardScreen(selectedRole: role)),
    // );
  }

  List<GridColumn> _buildUserRoleGridColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'Sr No',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text('Sr No', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        width: 60,
      ),
      GridColumn(
        columnName: 'Role Name',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text('Role Name', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        columnWidthMode: ColumnWidthMode.fitByColumnName,
      ),
      GridColumn(
        columnName: 'Name',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        columnWidthMode: ColumnWidthMode.fill, // Takes remaining space
      ),
      GridColumn(
        columnName: 'Department Name',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text('Department Name', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        columnWidthMode: ColumnWidthMode.fill,
      ),
      GridColumn(
        columnName: 'HoD/Unit Name',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text('HoD/Unit Name', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        columnWidthMode: ColumnWidthMode.fill,
      ),
      GridColumn(
        columnName: 'Office Name',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text('Office Name', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        columnWidthMode: ColumnWidthMode.fill,
      ),
      GridColumn(
        columnName: 'Action',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        width: 100, // Fixed width for the button column
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select User To Login'),
        backgroundColor: Theme.of(context).primaryColor, // Use your app's primary color
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select User To Login.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SfDataGrid(
                source: _userRoleDataSource,
                columns: _buildUserRoleGridColumns(),
                columnWidthMode: ColumnWidthMode.auto, // Adjust column widths automatically
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                rowHeight: 48, // Standard row height
                headerRowHeight: 42, // Standard header row height
              ),
            ),
            const SizedBox(height: 16),
            // Pagination controls (simulated based on your image)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: '10', // Default items per page
                  items: <String>['10', '25', '50', '100'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if(kDebugMode){
                      print('Items per page: $newValue');

                    }
                  },
                ),
                Row(
                  children: [
                    const Text('Total Records : '),
                    Text('${_userRoles.length}'), // Display total based on loaded data
                    const SizedBox(width: 20),
                    // Simulated page numbers (1 2 3 4 5)
                    _buildPageNumberButton('1', true),
                    _buildPageNumberButton('2', false),
                    _buildPageNumberButton('3', false),
                    _buildPageNumberButton('4', false),
                    _buildPageNumberButton('5', false),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageNumberButton(String pageNumber, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade100 : Colors.transparent,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: () {
          // Handle page change
          print('Page $pageNumber selected');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            pageNumber,
            style: TextStyle(
              color: isSelected ? Colors.blue.shade900 : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}