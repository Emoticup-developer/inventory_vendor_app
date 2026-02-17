import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendors/bloc/my_bloc.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  
  final AppBloc myBloc = AppBloc(
    "${baseUrl}/vendor/transaction_vendor/",
    "${baseUrl}/vendor/transaction_vendor/",
    "${baseUrl}/vendor/transaction_vendor/",
    "${baseUrl}/vendor/transaction_vendor/",
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return myBloc..add(FetchRequested());
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Transaction"), centerTitle: true),
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
              return Container(child: Text(state.data.toString()));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
