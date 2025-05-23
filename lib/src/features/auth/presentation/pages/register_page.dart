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
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController noRekeningController = TextEditingController();
  final TextEditingController nikPelangganController = TextEditingController();

  int? selectedGolongan;
  int? selectedKecamatan;
  int? selectedKelurahan;
  int? selectedArea;

  // @override
  // void initState() {
  //   super.initState();
  //   context.read<AuthBloc>().add(FetchDropdownEvent());
  // }

  void submitRegister() {
    final nik = nikPelangganController.text;

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

    final registerData = RegisterEntity(
      noRekening: noRekeningController.text,
      email: emailController.text,
      password: passwordController.text,
      passwordConfirmation: passwordConfirmController.text,
      nikPelanggan: nik,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
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
              CustomSnackBar.show(context, state.message,
                  backgroundColor: Colors.red);
            });
          }
        }, builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BasicForm(
                    label: "No Sambungan",
                    hintText: "Masukan no sambungan air",
                    inputType: TextInputType.text,
                    controller: noRekeningController),
                const SizedBox(height: 40),
                BasicForm(
                    label: "Email",
                    hintText: "Masukan email",
                    inputType: TextInputType.emailAddress,
                    controller: emailController),
                const SizedBox(height: 40),
                BasicForm(
                  label: "NIK Pelanggan",
                  hintText: "Masukan NIK",
                  inputType: TextInputType.number,
                  controller: nikPelangganController,
                ),
                const SizedBox(height: 40),
                PasswordForm(
                    label: "Password",
                    controller: passwordController,
                    hintText: "Masukan password"),
                const SizedBox(height: 40),
                PasswordForm(
                    label: "Konfirmasi Password",
                    controller: passwordConfirmController,
                    hintText: "Masukan konfirmasi password"),
                const SizedBox(height: 40),
                const SizedBox(height: 30),
                PrimaryButton(
                  label: "Daftar",
                  onPressed: submitRegister,
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
