part of 'contact_cubit.dart';

enum ContactStatus { initial, loaded }

final class ContactState extends Equatable {
  final List<Contact> contacts;
  final ContactStatus status;

  const ContactState({
    this.contacts = const [],
    this.status = ContactStatus.initial,
  });

  ContactState copyWith({List<Contact>? contacts, ContactStatus? status}) {
    return ContactState(
      contacts: contacts ?? this.contacts,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [contacts, status];
}
