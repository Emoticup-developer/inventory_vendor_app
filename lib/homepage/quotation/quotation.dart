import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendors/bloc/my_bloc.dart';
import 'package:vendors/homepage/quotation/create_quotation.dart';

class QuotationPage extends StatefulWidget {
  const QuotationPage({super.key});

  @override
  State<QuotationPage> createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  final AppBloc myBloc = AppBloc(
    "${baseUrl}/vendor/vendor_quotation/",
    "${baseUrl}/vendor/vendor_quotation/",
    "${baseUrl}/vendor/vendor_quotation/",
    "${baseUrl}/vendor/vendor_quotation/",
  );
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return myBloc..add(FetchRequested());
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateQuotationPage(),
              ),
            );
          },
          label: Text("New Quotation"),
          icon: Icon(Icons.add),
        ),
        appBar: AppBar(centerTitle: true, title: Text("Quotation")),
        body: BlocBuilder<AppBloc, AppState>(
          builder: (BuildContext context, AppState state) {
            if (state is AppLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AppError) {
              return Center(child: Text(state.message));
            } else if (state is AppLoaded) {
              if (state.data.isEmpty) {
                return Center(child: Text("No Data Found"));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  final item = state.data[index];

                  String status;

                  if (item['is_validated'] == true) {
                    status = "Approved";
                  } else if (item['is_validated'] == false) {
                    status = "Rejected";
                  } else {
                    status = "In Progress";
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Quotation Number
                          Text(
                            "Quotation: Q${item['quotation_number']}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// Date
                          Text("Date: ${item['date_of_quotation']}"),

                          const SizedBox(height: 4),

                          /// Quantity
                          // Text(
                          //   "Quantity: ${item['quantity'] ?? 'Not Provided'}",
                          // ),
                          const SizedBox(height: 4),

                          /// Lead Time
                          Text("Lead Time: ${item['lead_time_days']} Days"),

                          const SizedBox(height: 8),

                          /// Status
                          Text(
                            "Status: $status",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),

                          const SizedBox(height: 8),
                          CupertinoButton(
                            child: Text("Download"),
                            onPressed: () async {
                              final url = "${baseUrl}${item['quotation']}";
                              final uri = Uri.parse(url);
                              await launchUrl(uri);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
