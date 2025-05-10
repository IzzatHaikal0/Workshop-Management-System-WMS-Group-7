import 'package:flutter/material.dart';

class WorkshopOwnerProfilePage extends StatefulWidget {
  // ignore: use_super_parameters
  const WorkshopOwnerProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WorkshopOwnerProfilePageState createState() =>
      _WorkshopOwnerProfilePageState();
}

class _WorkshopOwnerProfilePageState extends State<WorkshopOwnerProfilePage> {
  final _formKey = GlobalKey<FormState>();

  String workshopOwnerID = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String workshopName = '';
  String workshopAddress = '';
  String workshopPhone = '';
  String workshopEmail = '';
  String workshopProfilePicture = '';
  String workshopOperationHour = '';
  String workshopDetail = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workshop Owner Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'WorkshopOwnerID'),
                onChanged: (value) => setState(() => workshopOwnerID = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'First Name'),
                onChanged: (value) => setState(() => firstName = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last Name'),
                onChanged: (value) => setState(() => lastName = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => setState(() => email = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                onChanged: (value) => setState(() => phoneNumber = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Workshop Name'),
                onChanged: (value) => setState(() => workshopName = value),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Workshop Address'),
                onChanged: (value) => setState(() => workshopAddress = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Workshop Phone'),
                onChanged: (value) => setState(() => workshopPhone = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Workshop Email'),
                onChanged: (value) => setState(() => workshopEmail = value),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Workshop Profile Picture'),
                onChanged: (value) =>
                    setState(() => workshopProfilePicture = value),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Workshop Operation Hour'),
                onChanged: (value) =>
                    setState(() => workshopOperationHour = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Workshop Detail'),
                onChanged: (value) => setState(() => workshopDetail = value),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text('Add')),
                  ElevatedButton(onPressed: () {}, child: const Text('Edit')),
                  ElevatedButton(onPressed: () {}, child: const Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
