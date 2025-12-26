import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

class BookingForm extends StatefulWidget {
  final Function(
    String name,
    String email,
    String phone,
    String practiceArea,
    String? message,
    bool gdpr,
  ) onSubmit;
  final bool isLoading;

  const BookingForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  String? _selectedPracticeArea;
  bool _gdprConsent = false;

  // Static list for MVP. In real app, fetch from PracticeAreaRepo.
  final List<Map<String, String>> _practiceAreas = [
    {'name': 'Family Law', 'slug': 'family-law'},
    {'name': 'Criminal Defense', 'slug': 'criminal-defense'},
    {'name': 'Corporate Law', 'slug': 'corporate-law'},
    {'name': 'Real Estate', 'slug': 'real-estate'},
    {'name': 'Immigration', 'slug': 'immigration'},
    {'name': 'Personal Injury', 'slug': 'personal-injury'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _gdprConsent && _selectedPracticeArea != null) {
      widget.onSubmit(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _phoneController.text.trim(),
        _selectedPracticeArea!,
        _messageController.text.trim().isEmpty ? null : _messageController.text.trim(),
        _gdprConsent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full Name *', prefixIcon: Icon(Icons.person_outline)),
            validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email *', prefixIcon: Icon(Icons.email_outlined)),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your email';
              if (!value.contains('@')) return 'Please enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone (Internal) *', prefixIcon: Icon(Icons.phone_outlined)),
            // Optional but good to have rudimentary validation or just required
            validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null, 
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedPracticeArea,
            decoration: const InputDecoration(labelText: 'Practice Area *', prefixIcon: Icon(Icons.gavel_outlined)),
            items: _practiceAreas.map((area) {
              return DropdownMenuItem(
                value: area['slug'],
                child: Text(area['name']!),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedPracticeArea = value;
              });
            },
            validator: (value) => value == null ? 'Please select a topic' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _messageController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Message (Optional)', prefixIcon: Icon(Icons.message_outlined)),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: _gdprConsent,
            onChanged: (value) {
              setState(() {
                _gdprConsent = value ?? false;
              });
            },
            title: const Text(
              'I consent to the processing of my personal data for the purpose of this appointment request.',
              style: TextStyle(fontSize: 12),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
          if (!_gdprConsent)
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                'Required',
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submit,
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Confirm Booking'),
            ),
          ),
        ],
      ),
    );
  }
}
