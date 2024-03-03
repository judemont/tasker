import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _displayedTabIndex = 0;

  void setDisplayedTab(int index) {
    setState(() {
      if (_displayedTabIndex == index) {
        _displayedTabIndex = 0;
      } else {
        _displayedTabIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              selected: _displayedTabIndex == 1,
              onTap: () {
                setDisplayedTab(1);
              },
              title: const Text("Import"),
            ),
            Visibility(
              visible: _displayedTabIndex == 1,
              child: const Column(
                children: [
                  ListTile(
                    title: Text("Option 1"),
                  ),
                ],
              ),
            ),
            ListTile(
              selected: _displayedTabIndex == 2,
              onTap: () {
                setDisplayedTab(2);
              },
              title: const Text("Export"),
            ),
            Visibility(
              visible: _displayedTabIndex == 2,
              child: const Column(
                children: [
                  ListTile(
                    title: Text("Option 2"),
                  ),
                ],
              ),
            ),
            ListTile(
              selected: _displayedTabIndex == 3,
              onTap: () {
                setDisplayedTab(3);
              },
              title: const Text("About"),
            ),
            Visibility(
              visible: _displayedTabIndex == 3,
              child: const Column(
                children: [
                  ListTile(
                    title: Text("Option 3"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
