import 'package:flutter/material.dart';

class ForemanProfilePage extends StatefulWidget {
  // ignore: use_super_parameters
  const ForemanProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForemanProfilePageState createState() => _ForemanProfilePageState();
}

class _ForemanProfilePageState extends State<ForemanProfilePage> {
  final _formKey = GlobalKey<FormState>();

  String foremanID = '';
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String email = '';
  String foremanAddress = '';
  String foremanProfilePicture = '';
  String foremanSkills = '';
  String foremanWorkExperience = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foreman Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'ForemanID'),
                onChanged: (value) => setState(() => foremanID = value),
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
                decoration: const InputDecoration(labelText: 'Phone Number'),
                onChanged: (value) => setState(() => phoneNumber = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => setState(() => email = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Foreman Address'),
                onChanged: (value) => setState(() => foremanAddress = value),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Foreman Profile Picture'),
                onChanged: (value) =>
                    setState(() => foremanProfilePicture = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Foreman Skills'),
                onChanged: (value) => setState(() => foremanSkills = value),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Foreman Work Experience'),
                onChanged: (value) =>
                    setState(() => foremanWorkExperience = value),
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
