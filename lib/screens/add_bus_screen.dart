import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticketbooking/services/admin_service.dart';
import 'package:ticketbooking/services/image_upload_service.dart';
import 'package:ticketbooking/utils/app_styles.dart';
import 'package:gap/gap.dart';
import 'package:ticketbooking/widgets/image_picker_widget.dart';
import 'dart:io';

class AddBusScreen extends StatefulWidget {
  const AddBusScreen({Key? key}) : super(key: key);

  @override
  State<AddBusScreen> createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  final _adminService = AdminService();
  final _imageUploadService = ImageUploadService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _busNameController;
  late TextEditingController _busCompanyController;
  late TextEditingController _departureController;
  late TextEditingController _arrivalController;
  late TextEditingController _departureTimeController;
  late TextEditingController _arrivalTimeController;
  late TextEditingController _routeController;
  late TextEditingController _priceController;
  late TextEditingController _seatsController;

  XFile? _selectedImage;
  bool _isLoading = false;
  bool _isUploadingImage = false;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    _busNameController = TextEditingController();
    _busCompanyController = TextEditingController();
    _departureController = TextEditingController();
    _arrivalController = TextEditingController();
    _departureTimeController = TextEditingController();
    _arrivalTimeController = TextEditingController();
    _routeController = TextEditingController();
    _priceController = TextEditingController();
    _seatsController = TextEditingController();
  }

  @override
  void dispose() {
    _busNameController.dispose();
    _busCompanyController.dispose();
    _departureController.dispose();
    _arrivalController.dispose();
    _departureTimeController.dispose();
    _arrivalTimeController.dispose();
    _routeController.dispose();
    _priceController.dispose();
    _seatsController.dispose();
    super.dispose();
  }

  Future<void> _addBus() async {
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
      // Upload image if not already uploaded
      String imageUrl = _uploadedImageUrl ?? '';
      if (_selectedImage != null && _uploadedImageUrl == null) {
        setState(() => _isUploadingImage = true);
        imageUrl = await _imageUploadService.uploadImage(
          imageFile: File(_selectedImage!.path),
          bucket: 'buses',
          folderPath: 'buses',
        );
        setState(() => _isUploadingImage = false);
      }

      // Add bus to database
      await _adminService.addBus(
        busName: _busNameController.text,
        busCompany: _busCompanyController.text,
        departure: _departureController.text,
        arrival: _arrivalController.text,
        departureTime: _departureTimeController.text,
        arrivalTime: _arrivalTimeController.text,
        route: _routeController.text,
        price: double.parse(_priceController.text),
        availableSeats: int.parse(_seatsController.text),
        image: imageUrl,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Bus added successfully!')),
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
        title: const Text('Add Bus'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Image Picker Widget
              ImagePickerWidget(
                label: 'Bus Image',
                onImageSelected: (XFile? image) {
                  setState(() => _selectedImage = image);
                  if (image != null) {
                    setState(() => _uploadedImageUrl = null);
                  }
                },
              ),
              const Gap(25),

              // Bus Name
              TextFormField(
                controller: _busNameController,
                decoration: InputDecoration(
                  labelText: 'Bus Name',
                  hintText: 'e.g., Express 101',
                  prefixIcon: const Icon(Icons.directions_bus),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter bus name' : null,
              ),
              const Gap(15),

              // Bus Company
              TextFormField(
                controller: _busCompanyController,
                decoration: InputDecoration(
                  labelText: 'Bus Company',
                  hintText: 'e.g., Dar Express',
                  prefixIcon: const Icon(Icons.business),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter company name' : null,
              ),
              const Gap(15),

              // Departure City
              TextFormField(
                controller: _departureController,
                decoration: InputDecoration(
                  labelText: 'Departure City',
                  hintText: 'e.g., Dar es Salaam',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter departure city' : null,
              ),
              const Gap(15),

              // Arrival City
              TextFormField(
                controller: _arrivalController,
                decoration: InputDecoration(
                  labelText: 'Arrival City',
                  hintText: 'e.g., Dodoma',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter arrival city' : null,
              ),
              const Gap(15),

              // Departure Time
              TextFormField(
                controller: _departureTimeController,
                decoration: InputDecoration(
                  labelText: 'Departure Time',
                  hintText: '08:00 AM',
                  prefixIcon: const Icon(Icons.access_time),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter departure time' : null,
              ),
              const Gap(15),

              // Arrival Time
              TextFormField(
                controller: _arrivalTimeController,
                decoration: InputDecoration(
                  labelText: 'Arrival Time',
                  hintText: '02:00 PM',
                  prefixIcon: const Icon(Icons.access_time_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter arrival time' : null,
              ),
              const Gap(15),

              // Route
              TextFormField(
                controller: _routeController,
                decoration: InputDecoration(
                  labelText: 'Route Code',
                  hintText: 'DAR-DDM',
                  prefixIcon: const Icon(Icons.route),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter route' : null,
              ),
              const Gap(15),

              // Price
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price (TZS)',
                  hintText: '25000',
                  prefixIcon: const Icon(Icons.money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter price' : null,
              ),
              const Gap(15),

              // Available Seats
              TextFormField(
                controller: _seatsController,
                decoration: InputDecoration(
                  labelText: 'Available Seats',
                  hintText: '50',
                  prefixIcon: const Icon(Icons.event_seat),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter available seats' : null,
              ),
              const Gap(30),

              // Add Bus Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addBus,
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
                              _isUploadingImage ? 'Uploading Image...' : 'Adding Bus...',
                              style: Styles.headLineStyle3.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Add Bus',
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
