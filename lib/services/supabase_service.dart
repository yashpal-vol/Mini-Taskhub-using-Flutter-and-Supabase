import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> tasks = [];
  bool _isSignedOut = false;

  SupabaseService() {
    _supabase.auth.onAuthStateChange.listen((state) {
      print(
          'Auth state changed to: ${state.event} - User: ${state.session?.user.email}');
      _isSignedOut = state.event == AuthChangeEvent.signedOut;
      if (!_isSignedOut) {
        _resetAndLoadTasks();
      } else {
        tasks = [];
        notifyListeners();
      }
    });
    if (!_isSignedOut) _loadTasks();
  }

  Future<void> _resetAndLoadTasks() async {
    tasks = [];
    await _loadTasks();
  }

  Future<void> _loadTasks() async {
    if (_isSignedOut) {
      print('Skipping task load due to signed out state');
      tasks = [];
      notifyListeners();
      return;
    }
    final user = await _supabase.auth.getUser();
    final userId = user.user?.id;
    print(
        'Loading tasks for userId: $userId (refreshed) - User: ${user.user?.email}');
    if (userId != null) {
      try {
        final response = await _supabase
            .from('tasks')
            .select()
            .eq('user_id', userId)
            .order('id');
        tasks = List<Map<String, dynamic>>.from(response);
        print('Tasks loaded: $tasks');
        notifyListeners();
      } catch (e) {
        print('Error loading tasks: $e');
        tasks = [];
        notifyListeners();
      }
    } else {
      print('No user logged in or session missing');
      tasks = [];
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    final user = await _supabase.auth.getUser();
    final userId = user.user?.id;
    print(
        'Adding task for userId: $userId (refreshed) - User: ${user.user?.email} with title: $title');
    if (userId != null) {
      try {
        final response = await _supabase
            .from('tasks')
            .insert({'title': title, 'user_id': userId}).select();
        if (response.isNotEmpty) {
          print(
              'Task added with id: ${response[0]['id']} and user_id: ${response[0]['user_id']} - User: ${user.user?.email}');
        }
        await _loadTasks();
      } catch (e) {
        print('Error adding task: $e');
      }
    }
  }

  Future<void> editTask(String id, String newTitle) async {
    final user = await _supabase.auth.getUser();
    final userId = user.user?.id;
    print(
        'Editing task with id: $id to title: $newTitle for userId: $userId (refreshed) - User: ${user.user?.email}');
    if (userId != null) {
      try {
        await _supabase
            .from('tasks')
            .update({'title': newTitle})
            .eq('id', id)
            .eq('user_id', userId);
        await _loadTasks();
      } catch (e) {
        print('Error editing task: $e');
      }
    }
  }

  Future<void> deleteTask(String id) async {
    final user = await _supabase.auth.getUser();
    final userId = user.user?.id;
    print(
        'Deleting task with id: $id for userId: $userId (refreshed) - User: ${user.user?.email}');
    if (userId != null) {
      try {
        await _supabase
            .from('tasks')
            .delete()
            .eq('id', id)
            .eq('user_id', userId);
        await _loadTasks();
      } catch (e) {
        print('Error deleting task: $e');
      }
    }
  }
}
