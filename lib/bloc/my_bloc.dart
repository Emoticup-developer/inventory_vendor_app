import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

// final String baseUrl = "https://emoticups.com/";
final String baseUrl = "http://192.168.1.106:8000";

final Dio dio = Dio(
  BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
  ),
);

/// ================= EVENTS =================

abstract class AppEvent extends Equatable {
  const AppEvent();
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AppEvent {
  final String email;
  final String password;
  final String server;

  const LoginRequested(this.email, this.password, this.server);

  @override
  List<Object?> get props => [email, password, server];
}

class CreateRequested extends AppEvent {
  final FormData data;
  const CreateRequested(this.data);

  @override
  List<Object?> get props => [data];
}

class FetchRequested extends AppEvent {}

class FilterRequested extends AppEvent {
  final Map<String, dynamic> filters;
  const FilterRequested(this.filters);

  @override
  List<Object?> get props => [filters];
}

class UpdateRequested extends AppEvent {
  final FormData data;
  final String id;

  const UpdateRequested(this.data, this.id);

  @override
  List<Object?> get props => [data, id];
}

class DeleteRequested extends AppEvent {
  final String id;
  const DeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class SplashEvent extends AppEvent {}

/// ================= STATES =================

abstract class AppState extends Equatable {
  const AppState();
  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {}

class AppLoading extends AppState {}

class SplashState extends AppState {
  final bool is_login;
  final String page;
  final String role;
  const SplashState(this.is_login, this.page, this.role);
  @override
  List<Object?> get props => [is_login, page, role];
}

class AppError extends AppState {
  final String message;
  const AppError(this.message);

  @override
  List<Object?> get props => [message];
}

class AppSuccess extends AppState {
  final String message;
  const AppSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AppLoaded extends AppState {
  final List<Map<String, dynamic>> data;
  const AppLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

/// ================= BLOC =================

class AppBloc extends Bloc<AppEvent, AppState> {
  final String getUrl;
  final String postUrl;
  final String putUrl;
  final String deleteUrl;

  AppBloc(this.getUrl, this.postUrl, this.putUrl, this.deleteUrl)
    : super(AppInitial()) {
    on<CreateRequested>(_onCreate);
    on<FetchRequested>(_onFetch);
    on<FilterRequested>(_onFilter);
    on<UpdateRequested>(_onUpdate);
    on<DeleteRequested>(_onDelete);
    on<LoginRequested>(_onLogin);
    on<SplashEvent>(_splash);
  }

  Future<String> _getToken() async {
    final box = Hive.box('auth');
    return await box.get("access");
  }

  Future<void> _onCreate(CreateRequested event, Emitter<AppState> emit) async {
    emit(AppLoading());
    try {
      final token = await _getToken();

      final response = await dio.post(
        postUrl,
        data: event.data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // add(FetchRequested());
        emit(AppSuccess(response.data.toString()));
      } else {
        emit(AppError(response.data.toString()));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AppError(e.response!.data.toString()));
      } else {
        emit(AppError(e.toString()));
      }
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onFetch(FetchRequested event, Emitter<AppState> emit) async {
    try {
      final token = await _getToken();

      final response = await dio.get(
        getUrl,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = (response.data as List).cast<Map<String, dynamic>>();
        emit(AppLoaded(data));
      } else {
        emit(AppError(response.data.toString()));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AppError(e.response!.data.toString()));
      } else {
        emit(AppError(e.toString()));
      }
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onFilter(FilterRequested event, Emitter<AppState> emit) async {
    emit(AppLoading());
    try {
      final token = await _getToken();

      final response = await dio.get(
        getUrl,
        queryParameters: event.filters,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = (response.data as List).cast<Map<String, dynamic>>();
        emit(AppLoaded(data));
      } else {
        emit(AppError(response.data.toString()));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AppError(e.response!.data.toString()));
      } else {
        emit(AppError(e.toString()));
      }
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateRequested event, Emitter<AppState> emit) async {
    try {
      final token = await _getToken();

      final response = await dio.put(
        "$putUrl${event.id}",
        data: event.data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        add(FetchRequested());
      } else {
        emit(AppError(response.data.toString()));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AppError(e.response!.data.toString()));
      } else {
        emit(AppError(e.toString()));
      }
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteRequested event, Emitter<AppState> emit) async {
    try {
      final token = await _getToken();

      final response = await dio.delete(
        "$deleteUrl${event.id}",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        add(FetchRequested());
      } else {
        emit(AppError(response.data.toString()));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AppError(e.response!.data.toString()));
      } else {
        emit(AppError(e.toString()));
      }
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AppState> emit) async {
    emit(AppLoading());
    try {
      final response = await dio.post(
        postUrl,
        data: {
          "username": event.email,
          "password": event.password,
          "server": event.server,
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final box = Hive.box('auth');
        await box.put("login", true);
        await box.put("type", "");
        await box.put("access", response.data["access"]);
        await box.put("refresh", response.data["refresh"]);
        await box.put("username", response.data["username"]);
        String user_type = response.data["position"].toString().toUpperCase();

        await box.put("type", user_type);
        emit(AppSuccess(response.data.toString()));
      } else {
        emit(AppError(response.data.toString()));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AppError(e.response!.data.toString()));
      } else {
        emit(AppError(e.toString()));
      }
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _splash(SplashEvent event, Emitter<AppState> emit) async {
    final box = Hive.box('auth');
    final login = await box.get("login", defaultValue: false);
    final type = await box.get("type", defaultValue: "VENDOR");
    emit(SplashState(login, "VENDOR", type));
  }
}
