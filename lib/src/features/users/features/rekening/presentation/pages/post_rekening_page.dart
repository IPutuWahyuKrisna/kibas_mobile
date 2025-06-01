import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../component/basic_form_small.dart';
import '../../../../../../component/index_component.dart';
import '../../../../../../component/snack_bar.dart';
import '../../../../../../core/services/global_service_locator.dart';
import '../../../../../../core/services/permission_service.dart';
import '../../../../../../core/utils/user_local_storage_service.dart';
import '../bloc/rekening_bloc.dart';

class PostRekeningPage extends StatefulWidget {
  const PostRekeningPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PostRekeningPageState createState() => _PostRekeningPageState();
}

class _PostRekeningPageState extends State<PostRekeningPage> {
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
    context.read<RekeningBloc>().add(FetchDropdownDataEvent());
    _getCurrentLocation(); // Ambil lokasi otomatis
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

  /// Kirim data ke API
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
      final Map<String, dynamic> rekeningData = {
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

      context.read<RekeningBloc>().add(PostRekeningEvent(rekeningData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text(
          'Tambah Rekening',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blue[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<RekeningBloc, RekeningState>(
          listener: (context, state) {
            if (state is RekeningSuccess) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                CustomSnackBar.show(context, state.message,
                    backgroundColor: Colors.green);
              });
              // Setelah sukses, kembali ke halaman sebelumnya dan kirim nilai true
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
      value: selectedValue,
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
