part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateSuccess extends AuthState {
  final UserModel userModel;

  const AuthStateSuccess(this.userModel);

  @override
  List<Object> get props => [userModel];
}

class AuthStateFailure extends AuthState {
  final String message;

  const AuthStateFailure(this.message);

  @override
  List<Object> get props => [message];
}

class RegisterSuccess extends AuthState {
  final String message;
  const RegisterSuccess({required this.message});
}

class RegisterError extends AuthState {
  final String message;
  const RegisterError({required this.message});
}

class DropdownLoading extends AuthState {}

// class DropdownLoaded extends AuthState {
//   final List<Map<String, dynamic>> golonganList;
//   final List<Map<String, dynamic>> kecamatanList;
//   final List<Map<String, dynamic>> kelurahanList;
//   final List<Map<String, dynamic>> areaList;

//   const DropdownLoaded({
//     required this.golonganList,
//     required this.kecamatanList,
//     required this.kelurahanList,
//     required this.areaList,
//   });
// }
