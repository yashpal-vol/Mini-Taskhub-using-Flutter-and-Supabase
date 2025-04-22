import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/login_screen.dart';
import '../services/supabase_service.dart';
import 'task_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _editController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _editController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
      }
    }
  }

  void _showEditDialog(Map<String, dynamic> task) {
    _editController.text = task['title'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Edit Task',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: _editController,
          decoration: const InputDecoration(
              hintText: 'Enter new title', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.teal)),
          ),
          TextButton(
            onPressed: () {
              if (_editController.text.isNotEmpty) {
                final supabaseService = context.read<SupabaseService>();
                supabaseService.editTask(
                    task['id'].toString(), _editController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final supabaseService = Provider.of<SupabaseService>(context);

    // Simple search filter (case-insensitive)
    final searchQuery = _searchController.text.toLowerCase();
    final filteredTasks = supabaseService.tasks
        .where((task) => task['title'].toLowerCase().contains(searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search tasks...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.search, color: Colors.teal),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return TaskTile(
                          title: task['title'],
                          onEdit: () => _showEditDialog(task),
                          onDelete: () {
                            final supabaseService =
                                context.read<SupabaseService>();
                            supabaseService.deleteTask(task['id'].toString());
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final taskController = TextEditingController();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add New Task',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        print('Adding task from onSubmitted: $value');
                        final supabaseService = context.read<SupabaseService>();
                        supabaseService.addTask(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final taskName = taskController.text.trim();
                      print('Attempting to add task: $taskName');
                      if (taskName.isNotEmpty) {
                        final supabaseService = context.read<SupabaseService>();
                        print('Calling addTask with: $taskName');
                        supabaseService.addTask(taskName);
                        print('addTask called, popping sheet');
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Task name cannot be empty')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Add Task',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ).whenComplete(() => taskController.dispose());
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
