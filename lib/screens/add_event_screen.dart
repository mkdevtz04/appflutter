import 'package:flutter/material.dart';
import 'package:ticketbooking/services/admin_service.dart';
import 'package:ticketbooking/utils/app_styles.dart';
import 'package:gap/gap.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _adminService = AdminService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _eventNameController;
  late TextEditingController _locationController;
  late TextEditingController _venueController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _ticketsController;
  late TextEditingController _imageController;

  bool _isLoading = false;
  String _selectedType = 'Cinema';

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController();
    _locationController = TextEditingController();
    _venueController = TextEditingController();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _ticketsController = TextEditingController();
    _imageController = TextEditingController();
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _locationController.dispose();
    _venueController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _ticketsController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _addEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _adminService.addEvent(
        eventName: _eventNameController.text,
        eventType: _selectedType,
        location: _locationController.text,
        venue: _venueController.text,
        date: _dateController.text,
        time: _timeController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        availableTickets: int.parse(_ticketsController.text),
        image: _imageController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event added successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        backgroundColor: Styles.primaryColor,
        title: const Text('Add New Event'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter event name' : null,
              ),
              const Gap(15),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Event Type',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: ['Cinema', 'Club', 'Concert', 'Sports', 'Theater']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value ?? 'Cinema'),
              ),
              const Gap(15),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location (City)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter location' : null,
              ),
              const Gap(15),
              TextFormField(
                controller: _venueController,
                decoration: InputDecoration(
                  labelText: 'Venue Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter venue' : null,
              ),
              const Gap(15),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter date' : null,
              ),
              const Gap(15),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Time (e.g., 07:00 PM)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter time' : null,
              ),
              const Gap(15),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 4,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter description' : null,
              ),
              const Gap(15),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price (TZS)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter price' : null,
              ),
              const Gap(15),
              TextFormField(
                controller: _ticketsController,
                decoration: InputDecoration(
                  labelText: 'Available Tickets',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter available tickets' : null,
              ),
              const Gap(15),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(
                  labelText: 'Image URL (e.g., assets/images/im3.jpg)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter image URL' : null,
              ),
              const Gap(30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                        )
                      : Text(
                          'Add Event',
                          style: Styles.headLineStyle3.copyWith(color: Colors.white, fontSize: 18),
                        ),
                ),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
