import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendors/bloc/my_bloc.dart';

class VendorDeclaration extends StatefulWidget {
  const VendorDeclaration({super.key});

  @override
  State<VendorDeclaration> createState() => _VendorDeclarationState();
}

class _VendorDeclarationState extends State<VendorDeclaration> {
  final AppBloc myBloc = AppBloc(
    "${baseUrl}/vendor/vendor_declaration_vendor/",
    "${baseUrl}/vendor/vendor_declaration_vendor/",
    "${baseUrl}/vendor/vendor_declaration_vendor/",
    "${baseUrl}/vendor/vendor_declaration_vendor/",
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return myBloc..add(FetchRequested());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Vendor Declaration"),
          centerTitle: true,
        ),
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

                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                        },
                        border: TableBorder.all(color: Colors.grey, width: 1),
                        children: [
                          TableRow(
                            children: [
                              _buildCell("Declared By Name", isHeader: true),
                              _buildCell(
                                data["declared_by_name"]?.toString() ?? "",
                              ),
                            ],
                          ),

                          TableRow(
                            children: [
                              _buildCell("Designation", isHeader: true),
                              _buildCell(
                                data["declared_by_designation"]?.toString() ??
                                    "",
                              ),
                            ],
                          ),

                          TableRow(
                            children: [
                              _buildCell("Place", isHeader: true),
                              _buildCell(data["place"]?.toString() ?? ""),
                            ],
                          ),

                          TableRow(
                            children: [
                              _buildCell("Declaration Date", isHeader: true),
                              _buildCell(
                                data["declaration_date"]?.toString() ?? "",
                              ),
                            ],
                          ),

                          TableRow(
                            children: [
                              _buildCell("Signature File", isHeader: true),
                              GestureDetector(
                                onTap: () async {
                                  final url = "${baseUrl}${item['signature']}";
                                  final uri = Uri.parse(url);
                                  await launchUrl(uri);
                                },
                                child: _buildCell(
                                  data["signature"]?.toString() ?? "",
                                ),
                              ),
                            ],
                          ),

                          TableRow(
                            children: [
                              _buildCell("Accepted", isHeader: true),
                              _buildCell(
                                data["accepted"] == true ? "Yes" : "No",
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildCell(String text, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
