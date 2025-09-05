import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kibas_mobile/src/component/basic_form_small.dart';
import 'package:kibas_mobile/src/component/index_component.dart';
import 'package:kibas_mobile/src/core/services/global_service_locator.dart';
import 'package:kibas_mobile/src/core/services/permission_service.dart';
import 'package:kibas_mobile/src/core/utils/user_local_storage_service.dart';
import '../../../../../../component/snack_bar.dart';
import '../bloc/rekening_bloc.dart';

class PutRekeningPage extends StatefulWidget {
  final int editRekeningId;
  const PutRekeningPage({super.key, required this.editRekeningId});

  @override
  // ignore: library_private_types_in_public_api
  _PutRekeningPageState createState() => _PutRekeningPageState();
}

class _PutRekeningPageState extends State<PutRekeningPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController noRekeningController = TextEditingController();
  String latitude = "";
  String longitude = "";

  int? selectedArea;
  int? selectedKecamatan;
  int? selectedKelurahan;
  int? selectedGolongan;
  int? selectedRayon;

  @override
  void initState() {
    super.initState();
    // Fetch dropdown data sama seperti di POST
    context.read<RekeningBloc>().add(FetchDropdownDataEvent());
    _getCurrentLocation();
  }

  /// Ambil lokasi otomatis menggunakan PermissionService
  Future<void> _getCurrentLocation() async {
    final position =
        await coreInjection<PermissionService>().getCurrentLocation();
    if (position != null) {
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });
    }
  }

  /// Kirim data ke API dengan PUT
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Ambil user dari local storage
      final userService = coreInjection<UserLocalStorageService>();
      final user = userService.getUser();

      // Pastikan pelanggan id tersedia
      if (user?.pelanggan?.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pelanggan ID tidak tersedia."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      final int idPelanggan = user!.pelanggan!.id;

      // Buat data sebagai Map<String, dynamic>
      // Pastikan jika untuk update, field "id" sudah ada (misalnya disertakan di data yang diedit)
      // Jika tidak, Anda bisa tambahkan field "id" sesuai kebutuhan update.
      final Map<String, dynamic> rekeningData = {
        "id": widget.editRekeningId,
        "no_rekening": noRekeningController.text,
        "area_id": selectedArea,
        "kecamatan_id": selectedKecamatan,
        "kelurahan_id": selectedKelurahan,
        "golongan_id": selectedGolongan,
        "rayon_id": selectedRayon,
        "lat": latitude,
        "lng": longitude,
        "pelanggan_id": idPelanggan,
      };

      // Panggil event PUT
      context.read<RekeningBloc>().add(PutRekeningEvent(rekeningData));
    }
  }

  @override
  void dispose() {
    noRekeningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text(
          'Update Rekening',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blue[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<RekeningBloc, RekeningState>(
          listener: (context, state) {
            if (state is PutRekeningSuccess) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.green);
              });
              // Setelah update berhasil, kembali ke halaman sebelumnya dan kirim nilai true
              Future.delayed(const Duration(seconds: 2), () {
                // ignore: use_build_context_synchronously
                Navigator.pop(context, true);
              });
            } else if (state is RekeningError) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.red);
              });
            }
          },
          builder: (context, state) {
            if (state is RekeningDropdownLoaded) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      /// Input No Rekening
                      BasicFormSmall(
                        label: "No Rekening",
                        hintText: "Masukkan No Rekening",
                        inputType: TextInputType.number,
                        controller: noRekeningController,
                      ),
                      const SizedBox(height: 20),

                      /// Dropdown Kecamatan & Area
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                                "Kecamatan",
                                state.kecamatanList,
                                selectedKecamatan, (value) {
                              setState(() => selectedKecamatan = value);
                            }),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildDropdown(
                                "Area", state.areaList, selectedArea, (value) {
                              setState(() => selectedArea = value);
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Dropdown Kelurahan & Golongan
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                                "Kelurahan",
                                state.kelurahanList,
                                selectedKelurahan, (value) {
                              setState(() => selectedKelurahan = value);
                            }),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildDropdown("Golongan",
                                state.golonganList, selectedGolongan, (value) {
                              setState(() => selectedGolongan = value);
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Dropdown Rayon
                      _buildDropdown("Rayon", state.rayonList, selectedRayon,
                          (value) {
                        setState(() => selectedRayon = value);
                      }),
                      const SizedBox(height: 20),

                      /// Tombol Simpan
                      PrimaryButton(
                        label: "Simpan",
                        onPressed: _submitForm,
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  /// Widget untuk Dropdown dengan tampilan yang lebih modern
  Widget _buildDropdown(String label, List<dynamic> items, int? selectedValue,
      Function(int?) onChanged) {
    return DropdownButtonFormField<int>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      initialValue: selectedValue,
      items: items.map((item) {
        return DropdownMenuItem<int>(
          value: item['id'] as int,
          child: Text(
            label == 'Rayon'
                ? item['kode_rayon'].toString()
                : item[label.toLowerCase()].toString(),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? "Harap pilih $label" : null,
    );
  }
}
