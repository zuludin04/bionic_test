import 'package:bionic_test/hive/data_session.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  late Box<DataSession> dataBox;
  final TextEditingController dataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataBox = Hive.box('data_session');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data')),
      body: Column(
        children: [
          TextField(
            controller: dataController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Data',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.black,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  width: 3,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              var data = dataController.text;
              if (data.isNotEmpty) {
                var contact = DataSession(data: data);
                dataBox.add(contact);
                dataController.clear();
                setState(() {});
              }
            },
            child: const Text('Input'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataBox.length,
              itemBuilder: (context, index) {
                DataSession note = dataBox.getAt(index)!;
                return ListTile(
                  title: Text(note.data),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      dataBox.deleteAt(index);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
