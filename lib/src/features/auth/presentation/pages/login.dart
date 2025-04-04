import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../component/index_component.dart';
import '../../../../component/snack_bar.dart';
import '../../../../config/theme/index_style.dart';
import '../../../../config/routes/router.dart';
import '../bloc/auth_bloc.dart'; // 🟢 Import CustomSnackBar

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// 🟢 Validasi input email dan password
  void _validateAndSubmit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      CustomSnackBar.show(
        context,
        'Peringatan\nOpsss sepertinya ada form yang kosong',
        backgroundColor: Colors.orange,
      );
      return;
    }

    if (password.length < 8) {
      CustomSnackBar.show(
        context,
        'Password minimal 8 karakter',
        backgroundColor: Colors.orange,
      );
      return;
    }
    print("masuk ke fungtion");
    // 🟢 Kirim event login ke AuthBloc
    context
        .read<AuthBloc>()
        .add(LoginButtonPressed(email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthStateSuccess) {
            if (state.userModel.role == "pelanggan") {
              context.goNamed(
                  RouteNames.dashboardUser); // 🟢 Pindah ke dashboard user
            } else if (state.userModel.role == "pembaca-meter") {
              context.goNamed(RouteNames
                  .dashboardEmployee); // 🟢 Pindah ke dashboard employee
            }
          } else if (state is AuthStateFailure) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              CustomSnackBar.show(context, state.message,
                  backgroundColor: Colors.red);
            });
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthStateLoading;

          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: ColorConstants.backgroundSecondary,
                ),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    const Padding(
                      padding: Margin.mediumMargin,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selamat Datang di Kibas Mobile",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.blackColorPrimary,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Silahkan masukkan username dan password untuk masuk ke aplikasi",
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorConstants.greyColorPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: Margin.mediumMargin,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BasicForm(
                            inputType: TextInputType.emailAddress,
                            label: "Email Pengguna",
                            hintText: "wedyapancer@gmail.com",
                            controller: emailController,
                          ),
                          const SizedBox(height: 30),
                          PasswordForm(
                            label: "Sandi",
                            hintText: "Password123",
                            controller: passwordController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: Margin.mediumMargin,
                      child: PrimaryButton(
                        label: "Masuk",
                        onPressed: _validateAndSubmit,
                        height: 55,
                        width: 400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Tidak mempunyai akun?",
                            style: TextStyle(
                              color: ColorConstants.greyColorPrimary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.go('/login/regist');
                            },
                            child: const Text(
                              " Daftar",
                              style: TextStyle(
                                color: ColorConstants.purpleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: Margin.mediumMargin,
                      width: MediaQuery.of(context).size.width,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Kebijakan Privasi",
                            style: TextStyle(
                              color: ColorConstants.purpleColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Tirta Danu Arta",
                            style: TextStyle(
                              color: ColorConstants.greyColorPrimary,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
