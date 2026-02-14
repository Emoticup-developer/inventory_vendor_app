import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vendors/bloc/my_bloc.dart';

class CreateQuotationPage extends StatefulWidget {
  const CreateQuotationPage({super.key});

  @override
  State<CreateQuotationPage> createState() => _CreateQuotationPageState();
}

class _CreateQuotationPageState extends State<CreateQuotationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _quotationNumberController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _leadTimeController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final AppBloc myBloc = AppBloc(
    "${baseUrl}/vendor/vendor_quotation/",
    "${baseUrl}/vendor/vendor_quotation/",
    "${baseUrl}/vendor/vendor_quotation/",
    "${baseUrl}/vendor/vendor_quotation/",
  );
  PlatformFile? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return myBloc;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("New Quotation"), centerTitle: true),
        body: BlocListener<AppBloc, AppState>(
          listener: (BuildContext context, AppState state) {
            if (state is AppError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is AppSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              Navigator.pop(context);
            } else if (state is AppLoaded) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.data.toString())));
              Navigator.pop(context);
            } else {
              print(state.toString());
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  /// Date Picker
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Date of Quotation",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    onTap: _pickDate,
                    validator: (value) => value == null || value.isEmpty
                        ? "Date is required"
                        : null,
                  ),

                  const SizedBox(height: 20),

                  /// Quantity
                  // _textField(
                  //   controller: _quantityController,
                  //   label: "Quantity",
                  //   keyboardType: const TextInputType.numberWithOptions(
                  //     decimal: true,
                  //   ),
                  // ),

                  // const SizedBox(height: 20),

                  /// Lead Time
                  _textField(
                    controller: _leadTimeController,
                    label: "Lead Time (Days)",
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),

                  /// File Picker
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Upload Quotation File",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: _pickFile,
                        child: Text(
                          _selectedFile == null
                              ? "Select File"
                              : _selectedFile!.name,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        if (_selectedFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select a file"),
                            ),
                          );
                          return;
                        } else {
                          final data = FormData.fromMap({
                            "date_of_quotation": _dateController.text,
                            "lead_time_days": _leadTimeController.text,
                            "quotation": await MultipartFile.fromFile(
                              _selectedFile!.path!,
                              filename: _selectedFile!.name,
                            ),
                          });
                          myBloc.add(CreateRequested(data));
                        }
                      },
                      child: const Text("Submit Quotation"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable Text Field
  Widget _textField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) =>
          value == null || value.isEmpty ? "$label is required" : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  /// Date Picker
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  /// File Picker
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  /// Submit Logic

  @override
  void dispose() {
    _quotationNumberController.dispose();
    _dateController.dispose();
    _quantityController.dispose();
    _leadTimeController.dispose();
    _companyController.dispose();
    super.dispose();
  }
}
