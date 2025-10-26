import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Buttons/icon_button.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Buttons/icon_text_button.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Buttons/m3_icon_text_b.dart';
import 'package:goiabeira/2_State_layer/settings/settings_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<String, bool> _settingsOptionsVisibility = {
    'Backup Data': false,
    'Restore Data': false,
    'Clear All Data': false,
    'About App': false,
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SettingsBloc>().add(InitializeSettings());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _buildSettingsOptions().length,
      itemBuilder: (context, index) {
        return _buildSettingsOptions()[index];
      },
    );
  }

  void _exportStockItemsToCSV(BuildContext context) {
    // Implement export logic here
    context.read<SettingsBloc>().add(ExportStockItemToCSV());
  }

  List<Widget> _buildSettingsOptions() {
    return [
      Column(
        children: [
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup Data'),
            onTap: () {
              setState(() {
                _settingsOptionsVisibility['Backup Data'] =
                    !_settingsOptionsVisibility['Backup Data']!;
              });
            },
          ),
          const Divider(),
          Visibility(
            visible: _settingsOptionsVisibility['Backup Data']!,
            child: _backupSection(),
          ),
        ],
      ),
      ListTile(
        leading: const Icon(Icons.restore),
        title: const Text('Restore Data'),
        onTap: () {
          // Handle restore action
        },
      ),
      ListTile(
        leading: const Icon(Icons.delete),
        title: const Text('Clear All Data'),
        onTap: () {
          // Handle clear data action
        },
      ),
      ListTile(
        leading: const Icon(Icons.info),
        title: const Text('About App'),
        onTap: () {
          // Handle about action
        },
      ),
    ];
  }

  Widget _backupSection() {
    return Column(
      children: [
        M3IconButton(
          icon: Icons.file_download,
          //backgroundColor: Colors.blue,
          //iconColor: Colors.white,
          onPressed: () => _exportStockItemsToCSV(context),
          text: 'Export Inventory to CSV',
        ),
        const SizedBox(height: 10),
        M3IconButton(
          icon: Icons.file_download,
          onPressed: () {
            context.read<SettingsBloc>().add(ExportSoldItemToCSV());
          },
          text: 'Export Sales to CSV',
        ),
      ],
    );
  }
}
