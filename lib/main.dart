import 'package:flutter/material.dart';
import 'package:tp_mod_11/db/database.dart';
import 'package:tp_mod_11/model/users.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UsersDb usersDb = UsersDb.instance;

  List<Users> users = [];

  refreshUser() {
    usersDb.getUsers().then((val) {
      setState(() {
        users = val;
      });
    });
  }

  @override
  void initState() {
    refreshUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Of Users"),
      ),
      body: Container(
        child: users.isEmpty
            ? const Center(
                child: Text("Tidak ada data"),
              )
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => _buildDialog(context, true, users[index]),
                    leading: const CircleAvatar(),
                    title: Text(users[index].name!),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          usersDb.deleteUsers(users[index].id!);
                          refreshUser();
                        });
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _buildDialog(context, false, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  _buildDialog(BuildContext context, bool isEdit, Users? user) {
    TextEditingController nameController = TextEditingController();
    TextEditingController updateController =
        TextEditingController(text: user?.name);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: !isEdit ? const Text("Add User") : const Text("Edit User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: !isEdit ? nameController : updateController,
                decoration: const InputDecoration(labelText: "Nama"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: !isEdit
                    ? () {
                        setState(() {
                          usersDb.insertUsers(Users(name: nameController.text));
                          refreshUser();
                          Navigator.pop(context);
                        });
                      }
                    : () {
                        setState(() {
                          usersDb.updateUsers(
                              Users(id: user?.id, name: updateController.text));
                          refreshUser();
                          Navigator.pop(context);
                        });
                      },
                child: !isEdit ? const Text("Save") : const Text("Update"),
              ),
            ],
          ),
        );
      },
    );
  }
}
