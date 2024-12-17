import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jogjappetite_mobile/models/restaurant.dart';

class EditRestaurantPage extends StatefulWidget {
  final Restaurant restaurant;

  const EditRestaurantPage({super.key, required this.restaurant});

  @override
  State<EditRestaurantPage> createState() => _EditRestaurantPageState();
}

class _EditRestaurantPageState extends State<EditRestaurantPage> {
  final _formKey = GlobalKey<FormState>();
  late String _namaRestoran;
  late String _lokasi;
  late String _gambar;
  late String _jenisSuasana;
  late int _keramaianRestoran;
  late String _jenisPenyajian;
  late String _ayceAtauAlacarte;
  late int _hargaRataRataMakanan;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize form fields with existing restaurant data
    _namaRestoran = widget.restaurant.namaRestoran;
    _lokasi = widget.restaurant.lokasi;
    _gambar = widget.restaurant.gambar;
    _jenisSuasana = widget.restaurant.jenisSuasana;
    _keramaianRestoran = widget.restaurant.keramaianRestoran;
    _jenisPenyajian = widget.restaurant.jenisPenyajian;
    _ayceAtauAlacarte = widget.restaurant.ayceAtauAlacarte;
    _hargaRataRataMakanan = widget.restaurant.hargaRataRataMakanan;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Restaurant'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: _namaRestoran,
                decoration: const InputDecoration(
                  labelText: 'Restaurant Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter restaurant name';
                  }
                  return null;
                },
                onSaved: (value) => _namaRestoran = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _lokasi,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
                onSaved: (value) => _lokasi = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _gambar,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  return null;
                },
                onSaved: (value) => _gambar = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _jenisSuasana,
                decoration: const InputDecoration(
                  labelText: 'Atmosphere Type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter atmosphere type';
                  }
                  return null;
                },
                onSaved: (value) => _jenisSuasana = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _keramaianRestoran.toString(),
                decoration: const InputDecoration(
                  labelText: 'Crowded Level (1-5)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter crowded level';
                  }
                  final intVal = int.tryParse(value);
                  if (intVal == null || intVal < 1 || intVal > 5) {
                    return 'Please enter a number between 1 and 5';
                  }
                  return null;
                },
                onSaved: (value) => _keramaianRestoran = int.parse(value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _jenisPenyajian,
                decoration: const InputDecoration(
                  labelText: 'Service Type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service type';
                  }
                  return null;
                },
                onSaved: (value) => _jenisPenyajian = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _ayceAtauAlacarte,
                decoration: const InputDecoration(
                  labelText: 'AYCE or A La Carte',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please specify AYCE or A La Carte';
                  }
                  return null;
                },
                onSaved: (value) => _ayceAtauAlacarte = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _hargaRataRataMakanan.toString(),
                decoration: const InputDecoration(
                  labelText: 'Average Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter average price';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _hargaRataRataMakanan = int.parse(value!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          _formKey.currentState!.save();

                          try {
                            final response = await request.post(
                              'http://127.0.0.1:8000/restaurant/api/owner/${widget.restaurant.id}/edit/',
                              {
                                'nama_restoran': _namaRestoran,
                                'lokasi': _lokasi,
                                'gambar': _gambar,
                                'jenis_suasana': _jenisSuasana,
                                'keramaian_restoran': _keramaianRestoran.toString(),
                                'jenis_penyajian': _jenisPenyajian,
                                'ayce_atau_alacarte': _ayceAtauAlacarte,
                                'harga_rata_rata_makanan': _hargaRataRataMakanan.toString(),
                              },
                            );

                            if (response['success'] == true) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Restaurant updated successfully')),
                              );
                              Navigator.pop(context, true);
                            } else {
                              throw response['message'] ?? 'Failed to update restaurant';
                            }
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        }
                      },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white))
                      : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
