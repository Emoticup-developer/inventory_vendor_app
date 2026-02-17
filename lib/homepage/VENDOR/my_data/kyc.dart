import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendors/bloc/my_bloc.dart';

class VendorKYCPage extends StatefulWidget {
  const VendorKYCPage({super.key});

  @override
  State<VendorKYCPage> createState() => _VendorKYCPageState();
}

class _VendorKYCPageState extends State<VendorKYCPage> {
  final AppBloc myBloc = AppBloc(
    "${baseUrl}/vendor/vendor_kyc_vendor/",
    "${baseUrl}/vendor/vendor_kyc_vendor/",
    "${baseUrl}/vendor/vendor_kyc_vendor/",
    "${baseUrl}/vendor/vendor_kyc_vendor/",
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => myBloc..add(FetchRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Vendor KYC"),
          centerTitle: true,
        ),
        body: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AppError) {
              return Center(child: Text(state.message));
            }

            if (state is AppLoaded) {
              if (state.data.isEmpty) {
                return const Center(child: Text("No Data Found"));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: state.data.map<Widget>((item) {
                    final data = Map<String, dynamic>.from(item);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                        },
                        border: TableBorder.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        children: [

                          // BASIC
                          _row("Legal Name", data["legal_name"]),
                          _row("Trade Name", data["trade_name"]),
                          _row("Registration Number", data["registration_number"]),
                          _row("Incorporation Date", data["incorporation_date"]),

                          // FK (show only name)
                          _row("Vendor Type",
                              _fkValue(data["vendor_type"])),
                          _row("Country",
                              _fkValue(data["country_of_registration"])),

                          // TAX
                          _row("Tax ID", data["tax_id"]),
                          _fileRow("Tax Certificate", data["tax_certificate"]),
                          _row("MSME", _boolValue(data["is_msme"])),
                          _fileRow("MSME Certificate", data["msme_certificate"]),

                          // BANK
                          _row("Bank Name", data["bank_name"]),
                          _row("Account Holder", data["account_holder_name"]),
                          _row("Account Number", data["account_number"]),
                          _row("IFSC / SWIFT", data["ifsc_swift_code"]),
                          _row("Bank Branch", data["bank_branch"]),
                          _fileRow("Bank Proof", data["bank_proof"]),

                          // ADDRESS
                          _row("Registered Address", data["registered_address"]),
                          _row("Operational Address", data["operational_address"]),
                          _row("Official Email", data["official_email"]),
                          _row("Phone Number", data["phone_number"]),

                          // SIGNATORY
                          _row("Signatory Name", data["signatory_name"]),
                          _row("Signatory Designation", data["signatory_designation"]),
                          _row("Signatory Email", data["signatory_email"]),
                          _row("Signatory Phone", data["signatory_phone"]),

                          // COMPLIANCE
                          _row("NDA Signed", _boolValue(data["nda_signed"])),
                          _row("Contract Signed", _boolValue(data["contract_signed"])),
                          _row("Blacklisted", _boolValue(data["is_blacklisted"])),
                          _row("Risk Rating", data["risk_rating"]),

                          _row("KYC Status", _fkValue(data["kyc_status"])),
                          _row("Approved At", data["approved_at"]),
                          _row("Approved By", _fkValue(data["approved_by"])),

                          _row("VAT Number", data["vat_number"]),
                          _row("Created At", data["created_at"]),
                          _row("Updated At", data["updated_at"]),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // 🔹 Standard Row
  TableRow _row(String label, dynamic value) {
    return TableRow(
      children: [
        _buildCell(label, isHeader: true),
        _buildCell(value?.toString() ?? ""),
      ],
    );
  }

  // 🔹 File Row (click to download)
  TableRow _fileRow(String label, dynamic value) {
    return TableRow(
      children: [
        _buildCell(label, isHeader: true),
        GestureDetector(
          onTap: value != null
              ? () async {
                  final url = "${baseUrl}$value";
                  final uri = Uri.parse(url);
                  await launchUrl(uri);
                }
              : null,
          child: _buildCell(
            value != null ? "Download File" : "",
            isLink: true,
          ),
        ),
      ],
    );
  }

  // 🔹 Boolean Formatting
  String _boolValue(dynamic value) {
    if (value == true) return "Yes";
    if (value == false) return "No";
    return "";
  }

  // 🔹 FK Formatting (show only main field)
  String _fkValue(dynamic fk) {
    if (fk == null) return "";
    if (fk is Map && fk.containsKey("name")) {
      return fk["name"].toString();
    }
    return fk.toString();
  }

  Widget _buildCell(String text,
      {bool isHeader = false, bool isLink = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isLink ? Colors.blue : Colors.black,
          decoration: isLink ? TextDecoration.underline : null,
        ),
      ),
    );
  }
}
