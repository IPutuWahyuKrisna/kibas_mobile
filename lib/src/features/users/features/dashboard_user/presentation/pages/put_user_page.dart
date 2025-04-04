import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kibas_mobile/src/component/basic_form_small.dart';
import 'package:kibas_mobile/src/component/password_form_small.dart';
import 'package:kibas_mobile/src/config/theme/index_style.dart';

import '../../../../../../component/index_component.dart';
import '../../../../../../component/snack_bar.dart';
import '../../domain/entities/put_user_profile.dart';
import '../bloc/dashboard_user_bloc.dart';

class PutUsersPage extends StatefulWidget {
  const PutUsersPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PutUsersPagePageState createState() => _PutUsersPagePageState();
}

class _PutUsersPagePageState extends State<PutUsersPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController noPelangganController = TextEditingController();
  final TextEditingController namaPelangganController = TextEditingController();
  final TextEditingController nikPelangganController = TextEditingController();
  final TextEditingController alamatPelangganController =
      TextEditingController();

  int? selectedGolongan;
  int? selectedKecamatan;
  int? selectedKelurahan;
  int? selectedArea;

  @override
  void initState() {
    super.initState();
    context.read<DashboardUserBloc>().add(FetchDropdownEvent());
  }

  void submitPutUsersPage() {
    if (selectedGolongan == null ||
        selectedKecamatan == null ||
        selectedKelurahan == null ||
        selectedArea == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap pilih semua dropdown")),
      );
      return;
    }

    final putUsersPageData = PutUserProfileEntity(
      email: emailController.text,
      password: passwordController.text,
      passwordConfirmation: passwordConfirmController.text,
      noPelanggan: noPelangganController.text,
      namaPelanggan: namaPelangganController.text,
      nikPelanggan: nikPelangganController.text,
      alamatPelanggan: alamatPelangganController.text,
      golonganId: selectedGolongan!,
      kecamatanId: selectedKecamatan!,
      kelurahanId: selectedKelurahan!,
      areaId: selectedArea!,
    );

    context
        .read<DashboardUserBloc>()
        .add(PutUsersEvent(putUsers: putUsersPageData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Form Edit User',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: ColorConstants.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<DashboardUserBloc, DashboardUserState>(
          listener: (context, state) {
            if (state is PutUserSuccess) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.green);
              });
              Future.delayed(const Duration(seconds: 2), () {
                // ignore: use_build_context_synchronously
                context.pop(true);
              });
            } else if (state is DashboardStateFailure) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.red);
              });
            }
          },
          builder: (context, state) {
            if (state is DropdownLoadedUsers) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    BasicFormSmall(
                        label: "Email",
                        hintText: "wedyapancer@gmail.com",
                        inputType: TextInputType.emailAddress,
                        controller: emailController),
                    const SizedBox(height: 20),
                    PasswordFormSmall(
                        label: "Password",
                        controller: passwordController,
                        hintText: "Password"),
                    const SizedBox(height: 20),
                    PasswordFormSmall(
                        label: "Konfirmasi Password",
                        controller: passwordConfirmController,
                        hintText: "Konfirmasi Password"),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: BasicFormSmall(
                            label: "No Pelanggan",
                            hintText: "Masukkan nomor pelanggan",
                            inputType: TextInputType.number,
                            controller: noPelangganController,
                          ),
                        ),
                        const SizedBox(
                            width: 10), // 🔥 Tambahkan jarak antar field
                        Expanded(
                          child: BasicFormSmall(
                            label: "NIK Pelanggan",
                            hintText: "Masukkan NIK pelanggan",
                            inputType: TextInputType.number,
                            controller: nikPelangganController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    BasicFormSmall(
                        label: "Nama Pelanggan",
                        hintText: "Tolong masukan nama anda",
                        inputType: TextInputType.text,
                        controller: namaPelangganController),
                    const SizedBox(height: 20),
                    BasicFormSmall(
                        label: "Alamat Pelanggan",
                        hintText: "Tolong masukan alamat anda",
                        inputType: TextInputType.text,
                        controller: alamatPelangganController),
                    const SizedBox(height: 20),

                    /// 🔹 Dropdown Golongan & Kecamatan
                    Row(
                      children: [
                        Expanded(
                            child: _buildDropdown("Golongan",
                                state.golonganList, selectedGolongan, (value) {
                          setState(() => selectedGolongan = value);
                        })),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _buildDropdown(
                                "Kecamatan",
                                state.kecamatanList,
                                selectedKecamatan, (value) {
                          setState(() => selectedKecamatan = value);
                        })),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// 🔹 Dropdown Kelurahan & Area
                    Row(
                      children: [
                        Expanded(
                            child: _buildDropdown(
                                "Kelurahan",
                                state.kelurahanList,
                                selectedKelurahan, (value) {
                          setState(() => selectedKelurahan = value);
                        })),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _buildDropdown(
                                "Area", state.areaList, selectedArea, (value) {
                          setState(() => selectedArea = value);
                        })),
                      ],
                    ),
                    const SizedBox(height: 30),

                    /// 🔹 Tombol Daftar
                    PrimaryButton(
                      label: "Perbaharui",
                      onPressed: submitPutUsersPage,
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
