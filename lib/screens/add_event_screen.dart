import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticketbooking/services/admin_service.dart';
import 'package:ticketbooking/services/image_upload_service.dart';
import 'package:ticketbooking/utils/app_styles.dart';
import 'package:ticketbooking/widgets/image_picker_widget.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _adminService = AdminService();
  final _imageUploadService = ImageUploadService();
  late TextEditingController _eventNameController;
  late TextEditingController _locationController;
  late TextEditingController _venueController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _ticketsController;
  XFile? _selectedImage;
  String? _uploadedImageUrl;
  String _selectedType = 'Cinema';
  bool _isLoading = false;
  bool _isUploadingImage = false;

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
    super.dispose();
  }

  Future<void> _addEvent() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }
    if (_uploadedImageUrl == null && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      String imageUrl = _uploadedImageUrl ?? '';
      if (_selectedImage != null && _uploadedImageUrl == null) {
        setState(() => _isUploadingImage = true);
        imageUrl = await _imageUploadService.uploadImage(
          imageFile: File(_selectedImage!.path),
          bucket: 'events',
          folderPath: 'events',
        );
        setState(() => _isUploadingImage = false);
      }
      await _adminService.addEvent(
        eventName: _eventNameController.text.trim(),
        eventType: _selectedType,
        location: _locationController.text.trim(),
        venue: _venueController.text.trim(),
        date: _dateController.text.trim(),
        time: _timeController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        availableTickets: int.tryParse(_ticketsController.text.trim()) ?? 0,
        image: imageUrl,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Event added successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e')),
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
        title: const Text('Add Event'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ImagePickerWidget(
                label: 'Event Image',
                onImageSelected: (XFile? image) {
                  setState(() => _selectedImage = image);
                  if (image != null) _uploadedImageUrl = null;
                },
              ),
              const Gap(20),
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  hintText: 'e.g., Avatar 3D',
                  prefixIcon: const Icon(Icons.event),
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
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: ['Cinema', 'Club', 'Concert', 'Sports', 'Theater', 'Other']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedType = value);
                },
              ),
              const Gap(15),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location (City)',
                  hintText: 'e.g., Dar es Salaam',
                  prefixIcon: const Icon(Icons.location_on),
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
                  hintText: 'e.g., Cinemax Downtown',
                  prefixIcon: const Icon(Icons.place),
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
                  labelText: 'Date',
                  hintText: 'YYYY-MM-DD (e.g., 2025-12-25)',
                  prefixIcon: const Icon(Icons.calendar_today),
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
                  labelText: 'Time',
                  hintText: 'e.g., 07:00 PM',
                  prefixIcon: const Icon(Icons.access_time),
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
                  hintText: 'Enter event description',
                  prefixIcon: const Icon(Icons.description),
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
                  hintText: '15000',
                  prefixIcon: const Icon(Icons.money),
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
                  hintText: '200',
                  prefixIcon: const Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter available tickets' : null,
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
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            ),
                            const Gap(12),
                            Text(
                              _isUploadingImage ? 'Uploading Image...' : 'Adding Event...',
                              style: Styles.headLineStyle3.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Add Event',
                          style: Styles.headLineStyle3.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
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