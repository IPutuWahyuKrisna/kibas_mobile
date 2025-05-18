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
  final TextEditingController namaPelangganController = TextEditingController();
  final TextEditingController nikPelangganController = TextEditingController();
  final TextEditingController noPelanggancontroller = TextEditingController();

  int? selectedGolongan;
  int? selectedKecamatan;
  int? selectedKelurahan;
  int? selectedArea;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(FetchDropdownEvent());
  }

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
      noPelanggan: noPelanggancontroller.text,
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

  // void submitRegister() {
  //   // if (selectedGolongan == null ||
  //   //     selectedKecamatan == null ||
  //   //     selectedKelurahan == null ||
  //   //     selectedArea == null) {
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //     const SnackBar(content: Text("Harap pilih semua dropdown")),
  //   //   );
  //   //   return;
  //   // }

  //   final registerData = RegisterEntity(
  //       noPelanggan: noPelanggancontroller.text,
  //       noRekening: noRekeningController.text,
  //       email: emailController.text,
  //       password: passwordController.text,
  //       passwordConfirmation: passwordConfirmController.text,
  //       nikPelanggan: nikPelangganController.text);

  //   context
  //       .read<AuthBloc>()
  //       .add(SubmitRegisterEvent(registerData: registerData));
  // }

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
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.green);
              });
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text(state.message)),
              // );
              Future.delayed(const Duration(seconds: 2), () {
                // ignore: use_build_context_synchronously
                context.goNamed(RouteNames.login);
              });
            } else if (state is RegisterError) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.red);
              });
            }
          },
          builder: (context, state) {
            if (state is DropdownLoaded) {
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
                    BasicForm(
                      label: "No Pelanggan",
                      hintText: "Masukkan nomor pelanggan",
                      inputType: TextInputType.text,
                      controller: noPelanggancontroller,
                    ),

                    // const SizedBox(height: 20),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: BasicFormSmall(
                    //         label: "No Pelanggan",
                    //         hintText: "Masukkan nomor pelanggan",
                    //         inputType: TextInputType.number,
                    //         controller: noPelangganController,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //         width: 10), // 🔥 Tambahkan jarak antar field
                    //     Expanded(
                    //       child: BasicFormSmall(
                    //         label: "NIK Pelanggan",
                    //         hintText: "Masukkan NIK pelanggan",
                    //         inputType: TextInputType.number,
                    //         controller: nikPelangganController,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 20),
                    // BasicFormSmall(
                    //     label: "Nama Pelanggan",
                    //     hintText: "Tolong masukan nama anda",
                    //     inputType: TextInputType.text,
                    //     controller: namaPelangganController),
                    // const SizedBox(height: 20),
                    // BasicFormSmall(
                    //     label: "Alamat Pelanggan",
                    //     hintText: "Tolong masukan alamat anda",
                    //     inputType: TextInputType.text,
                    //     controller: alamatPelangganController),
                    // const SizedBox(height: 20),

                    // /// 🔹 Dropdown Golongan & Kecamatan
                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: _buildDropdown("Golongan",
                    //             state.golonganList, selectedGolongan, (value) {
                    //       setState(() => selectedGolongan = value);
                    //     })),
                    //     const SizedBox(width: 10),
                    //     Expanded(
                    //         child: _buildDropdown(
                    //             "Kecamatan",
                    //             state.kecamatanList,
                    //             selectedKecamatan, (value) {
                    //       setState(() => selectedKecamatan = value);
                    //     })),
                    //   ],
                    // ),
                    // const SizedBox(height: 20),

                    // /// 🔹 Dropdown Kelurahan & Area
                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: _buildDropdown(
                    //             "Kelurahan",
                    //             state.kelurahanList,
                    //             selectedKelurahan, (value) {
                    //       setState(() => selectedKelurahan = value);
                    //     })),
                    //     const SizedBox(width: 10),
                    //     Expanded(
                    //         child: _buildDropdown(
                    //             "Area", state.areaList, selectedArea, (value) {
                    //       setState(() => selectedArea = value);
                    //     })),
                    //   ],
                    // ),
                    const SizedBox(height: 30),

                    /// 🔹 Tombol Daftar
                    PrimaryButton(
                      label: "Daftar",
                      onPressed: submitRegister,
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  /// 🔹 Fungsi Membuat Dropdown (Modular)
  Widget _buildDropdown(String label, List<dynamic> items, int? selectedValue,
      Function(int?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorConstants.backgroundColor,
            border: Border.all(color: ColorConstants.greyColorsecondary),
          ),
          child: DropdownButton<int>(
            underline: Container(),
            isExpanded: true,
            value: selectedValue,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item['id'] as int,
                      child: Text(
                          item[label.toLowerCase()]), // Ambil nilai dari label
                    ))
                .toList(),
            onChanged: onChanged,
            hint: Text(label),
          ),
        ),
      ],
    );
  }
}
