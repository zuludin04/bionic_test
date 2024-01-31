import 'package:bionic_test/contact.dart';
import 'package:bionic_test/cubit/contact_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                hintText: 'Name',
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
            const SizedBox(height: 8),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Phone',
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
                var name = nameController.text;
                var phone = phoneController.text;

                if (name.isNotEmpty && phone.isNotEmpty) {
                  var contact = Contact(name: name, phone: phone);
                  context.read<ContactCubit>().addContact(contact);
                  nameController.clear();
                  phoneController.clear();
                }
              },
              child: const Text('Input'),
            ),
            Expanded(
              child: BlocBuilder<ContactCubit, ContactState>(
                builder: (context, state) {
                  switch (state.status) {
                    case ContactStatus.initial:
                      return const Center(child: Text('Input Contact Data'));
                    case ContactStatus.loaded:
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(state.contacts[index].name),
                            subtitle: Text(state.contacts[index].phone),
                            leading: const Icon(Icons.person),
                          );
                        },
                        itemCount: state.contacts.length,
                      );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
