import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendors/bloc/my_bloc.dart';

class CoreDataVendor extends StatefulWidget {
  const CoreDataVendor({super.key});

  @override
  State<CoreDataVendor> createState() => _CoreDataVendorState();
}

class _CoreDataVendorState extends State<CoreDataVendor> {
  
  final AppBloc myBloc = AppBloc(
    "${baseUrl}/vendor/vendor_account_data/",
    "${baseUrl}/vendor/vendor_account_data/",
    "${baseUrl}/vendor/vendor_account_data/",
    "${baseUrl}/vendor/vendor_account_data/",
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return myBloc..add(FetchRequested());
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Core Data"), centerTitle: true),
        body: BlocBuilder<AppBloc, AppState>(
          builder: (BuildContext context, AppState state) {
            if (state is AppLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AppError) {
              return Center(child: Text(state.message));
            } else if (state is AppLoaded) {
              if (state.data.isEmpty) {
                return const Center(child: Text("No Data Found"));
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: state.data.map<Widget>((item) {
                    Map<String, dynamic> data = Map<String, dynamic>.from(item);

                    final Map<String, dynamic> displayData = {
                      "Vendor Name": data["vendor_name"],
                      "Vendor Code": data["vendor_code"],
                      "Short Name": data["short_name"],
                      "Contact Person": data["contact_person"],
                      "Email": data["email"],
                      "Mobile": data["mobile"],
                      "Website": data["website"],
                      "Billing Address": data["billing_address"],
                      "Postal Code": data["postal_code"],
                      "Lead Time (Days)": data["default_lead_time_days"],
                      "Minimum Order Value": data["minimum_order_value"],
                      "Remarks": data["remarks"],
                    };

                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                        },
                        border: TableBorder.all(color: Colors.grey, width: 1),
                        children: displayData.entries.map((entry) {
                          return TableRow(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Text(entry.value?.toString() ?? ""),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              );
            } else {
              return const Center(child: Text("No Data Found"));
            }
          },
        ),
      ),
    );
  }
}
