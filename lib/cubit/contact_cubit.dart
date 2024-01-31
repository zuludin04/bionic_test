import 'package:bionic_test/contact.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(const ContactState());

  Future<void> addContact(Contact contact) async {
    var currentContacts = <Contact>[];
    currentContacts.addAll(state.contacts);
    currentContacts.add(contact);
    emit(state.copyWith(
      contacts: currentContacts,
      status: ContactStatus.loaded,
    ));
  }
}
