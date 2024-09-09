import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/CustomBottomNavigationBar.dart';
import '../components/SettingsTab.dart';
import '../components/TaskCircle.dart';
import '../routes/routes_name.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<int> _tasks = List.generate(6, (index) => 23);
  // final List<int> _tasks = [22, 22, 22, 22, 22, 22];

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      _showSettingsModal();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _finishTask(int index) {
    setState(() {
      _tasks[index] = 0;
    });
    Get.toNamed(RouteName.pushTestScreen);
  }

  void _showSettingsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SettingsScreen(
              scrollController: scrollController,
              onClose: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = 0;
                });
              },
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        _selectedIndex = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("_tasks-->$_tasks");

    return Scaffold(
      appBar: AppBar(
        title: const Text('拼了', style: TextStyle(color: Colors.orange)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.purple),
            onPressed: () {
              Get.toNamed(RouteName.registerScreen);
            },
          ),
        ],
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Image.asset('assets/ninja.png', height: 150),
            const Center(
              child: FlutterLogo(
                size: 220,
                textColor: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Personal Wordbank and pass userId parameter
                    Get.toNamed(RouteName.personalWordBankScreen,
                        parameters: {"type": "personal", "userId": "1"});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Personal wordbank',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Built-in Wordbank without userId
                    Get.toNamed(RouteName.builtinWordBankScreen,
                        parameters: {"type": "builtin"});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Built-in wordbank',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 40.0), // Adjust the value as needed
                child: Text(
                  "Today's task",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _finishTask(index),
                    child: TaskCircle(
                      daysLeft: _tasks[index],
                      isFinish: _tasks[index] == 0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
