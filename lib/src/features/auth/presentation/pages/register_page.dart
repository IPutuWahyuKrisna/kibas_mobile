import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kibas_mobile/src/config/theme/index_style.dart';
import '../../../../component/index_component.dart';
import '../../../../component/snack_bar.dart';
import '../../../../config/routes/router.dart';
import '../../domain/entities/register_entity.dart';
import '../bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController noRekeningController = TextEditingController();
  final TextEditingController nikPelangganController = TextEditingController();
  final TextEditingController noTeleponController = TextEditingController();

  int? selectedGolongan;
  int? selectedKecamatan;
  int? selectedKelurahan;
  int? selectedArea;

  void submitRegister() {
    final nik = nikPelangganController.text;

    if (emailController.text.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        CustomSnackBar.show(
          context,
          "Email tidak boleh kosong!",
          backgroundColor: Colors.red,
        );
      });
      return;
    }

    if (passwordController.text.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        CustomSnackBar.show(
          context,
          "Password tidak boleh kosong!",
          backgroundColor: Colors.red,
        );
      });
      return;
    }

    if (passwordConfirmController.text.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        CustomSnackBar.show(
          context,
          "Konfirmasi password tidak boleh kosong!",
          backgroundColor: Colors.red,
        );
      });
      return;
    }

    if (noRekeningController.text.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        CustomSnackBar.show(
          context,
          "No rekening tidak boleh kosong!",
          backgroundColor: Colors.red,
        );
      });
      return;
    }

    if (nikPelangganController.text.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        CustomSnackBar.show(
          context,
          "NIK pelanggan tidak boleh kosong!",
          backgroundColor: Colors.red,
        );
      });
      return;
    }
    if (noTeleponController.text.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        CustomSnackBar.show(
          context,
          "No telepon pelanggan tidak boleh kosong!",
          backgroundColor: Colors.red,
        );
      });
      return;
    }

    if (noTeleponController.text.length < 10 ||
        noTeleponController.text.length > 17) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        CustomSnackBar.show(
          context,
          "No telepon harus antara 10 dan 17 digit!",
          backgroundColor: Colors.red,
        );
      });
      return;
    }

    // Validasi panjang NIK harus 16 digit
    if (nik.length != 16 || !RegExp(r'^\d{16}$').hasMatch(nik)) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        CustomSnackBar.show(
          context,
          "NIK harus berjumlah 16 digit!!",
          backgroundColor: Colors.red,
        );
      });
      return;
    }
    if (passwordController.text != passwordConfirmController.text) {
      CustomSnackBar.show(context, "Password tidak sama!");
      return;
    }

    final registerData = RegisterEntity(
      noRekening: noRekeningController.text,
      email: emailController.text,
      password: passwordController.text,
      passwordConfirmation: passwordConfirmController.text,
      nikPelanggan: nik,
      noTelepon: noTeleponController.text,
    );

    context
        .read<AuthBloc>()
        .add(SubmitRegisterEvent(registerData: registerData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants.backgroundSecondary,
      appBar: AppBar(
        title: const Text(
          'Form Pendaftaran',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: ColorConstants.backgroundColor,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              CustomSnackBar.show(context, state.message,
                  backgroundColor: Colors.green);
            });
            Future.delayed(const Duration(seconds: 2), () {
              context.goNamed(RouteNames.login);
            });
          } else if (state is RegisterError) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              CustomSnackBar.show(context,
                  "gagal melakukan register, coba cek email atau nomor sambungan anda, mungkin itu sudah terdaftar",
                  backgroundColor: Colors.red);
            });
          }
        },
        builder: (context, state) {
          if (state is AuthStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BasicForm(
                            label: "No Sambungan",
                            hintText: "Masukan no sambungan air",
                            inputType: TextInputType.text,
                            controller: noRekeningController),
                        const SizedBox(height: 20),
                        BasicForm(
                            label: "Email",
                            hintText: "Masukan email",
                            inputType: TextInputType.emailAddress,
                            controller: emailController),
                        const SizedBox(height: 20),
                        BasicForm(
                          label: "NIK Pelanggan",
                          hintText: "Masukan NIK",
                          inputType: TextInputType.number,
                          controller: nikPelangganController,
                        ),
                        const SizedBox(height: 20),
                        BasicForm(
                          label: "No Telepon",
                          hintText: "Masukan No telepon",
                          inputType: TextInputType.number,
                          controller: noTeleponController,
                        ),
                        const SizedBox(height: 20),
                        PasswordForm(
                            label: "Password",
                            controller: passwordController,
                            hintText: "Masukan password"),
                        const SizedBox(height: 20),
                        PasswordForm(
                            label: "Konfirmasi Password",
                            controller: passwordConfirmController,
                            hintText: "Masukan konfirmasi password"),
                        const SizedBox(height: 30),
                        PrimaryButton(
                          label: "Daftar",
                          onPressed: submitRegister,
                          height: 45,
                          width: double.infinity,
                          isLoading: state is AuthStateLoading,
                          enabled: state is! AuthStateLoading,
                        ),
                        const SizedBox(
                            height: 20), // Added extra space at bottom
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
