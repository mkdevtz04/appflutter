import 'package:flutter/material.dart';
import 'package:ticketbooking/services/admin_service.dart';
import 'package:ticketbooking/utils/app_styles.dart';
import 'package:gap/gap.dart';

class AddBusScreen extends StatefulWidget {
  const AddBusScreen({Key? key}) : super(key: key);

  @override
  State<AddBusScreen> createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  final _adminService = AdminService();
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
  late TextEditingController _imageController;

  bool _isLoading = false;

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
    _imageController = TextEditingController();
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
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _addBus() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
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
        image: _imageController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bus added successfully!')),
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
        title: const Text('Add New Bus'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _busNameController,
                decoration: InputDecoration(
                  labelText: 'Bus Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter bus name' : null,
              ),
              const Gap(15),
              TextFormField(
                controller: _busCompanyController,
                decoration: InputDecoration(
                  labelText: 'Bus Company',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter company name' : null,
              ),
              const Gap(15),
              TextFormField(
                controller: _departureController,
                decoration: InputDecoration(
                  labelText: 'Departure City',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter departure city' : null,
              ),
              const Gap(15),
              TextFormField(
                controller: _arrivalController,
                decoration: InputDecoration(
                  labelText: 'Arrival City',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter arrival city' : null,
              ),
              const Gap(15),
              TextFormField(
                controller: _departureTimeController,
                decoration: InputDecoration(
                  labelText: 'Departure Time (e.g., 08:00 AM)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter departure time' : null,
              ),
              const Gap(15),
              TextFormField(
                controller: _arrivalTimeController,
                decoration: InputDecoration(
                  labelText: 'Arrival Time (e.g., 02:00 PM)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter arrival time' : null,
              ),
              const Gap(15),
              TextFormField(
                controller: _routeController,
                decoration: InputDecoration(
                  labelText: 'Route',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter route' : null,
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
                controller: _seatsController,
                decoration: InputDecoration(
                  labelText: 'Available Seats',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter available seats' : null,
              ),
              const Gap(15),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(
                  labelText: 'Image URL (e.g., assets/images/im2.jpg)',
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
                  onPressed: _isLoading ? null : _addBus,
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
                          'Add Bus',
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
