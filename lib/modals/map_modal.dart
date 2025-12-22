import 'dart:convert';

import 'package:app/helpers/helpers.dart';
import 'package:app/models/address.dart';
import 'package:app/router.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapModal extends StatefulWidget {
  final Address? address;
  const MapModal({super.key, this.address});

  @override
  State<MapModal> createState() => _MapModalState();
}

class _MapModalState extends State<MapModal> {
  GoogleMapController? mapController;

  LatLng selectedLatLng = const LatLng(32.37624, 15.09349);

  String? selectedStreet;
  String? selectedCity;
  String? selectedState;
  String? selectedPostalCode;

  bool isLoading = false;
  bool canUseMyLocation = false;

  Address? currentAddress;

  bool get isEditing => currentAddress != null;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args is Address) {
      currentAddress = args;
      selectedLatLng = LatLng(args.latitude, args.longitude);
    } else {
      currentAddress = widget.address;
      if (currentAddress != null) {
        selectedLatLng = LatLng(
          currentAddress!.latitude,
          currentAddress!.longitude,
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCurrentLocation();
    });
  }

  Future<void> _initCurrentLocation() async {
    if (isEditing) return;

    try {
      final pos = await Helpers.determinePosition().timeout(
        const Duration(seconds: 10),
      );

      selectedLatLng = LatLng(pos.latitude, pos.longitude);

      if (mounted) {
        setState(() => canUseMyLocation = true);
      }

      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLng(selectedLatLng));
      }

      if (mounted) setState(() {});
    } catch (_) {}
  }

  Future<void> _reverseGeocode(LatLng latLng) async {
    setState(() => isLoading = true);

    try {
      const apiKey = "AIzaSyB-YZX3_b2i3bBeXbBLlTWvmw23PkKhnAY";
      final url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&language=ar&key=$apiKey";

      final res = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 8));

      final data = jsonDecode(res.body);

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final components = data['results'][0]['address_components'] as List;

        String getComponent(String type) {
          final match = components.firstWhere(
            (c) => (c['types'] as List).contains(type),
            orElse: () => null,
          );
          return match == null ? '' : match['long_name'];
        }

        selectedStreet = getComponent('route');
        selectedCity = getComponent('locality').isNotEmpty
            ? getComponent('locality')
            : getComponent('administrative_area_level_2');
        selectedState = getComponent('administrative_area_level_1');
        selectedPostalCode = getComponent('postal_code');
      } else {
        selectedStreet = null;
        selectedCity = null;
        selectedState = null;
        selectedPostalCode = null;
      }
    } catch (_) {
      selectedStreet = null;
      selectedCity = null;
      selectedState = null;
      selectedPostalCode = null;
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _confirmSelection() {
    final prefilled = {
      'street': selectedStreet ?? '',
      'city': selectedCity ?? '',
      'state': selectedState ?? '',
      'postal_code': selectedPostalCode ?? '',
      'latitude': selectedLatLng.latitude,
      'longitude': selectedLatLng.longitude,
      'is_default': currentAddress?.isDefault ?? false,
    };

    if (isEditing) {
      Get.toNamed(
        Routes.addressForm,
        arguments: {'address': currentAddress, 'prefilled': prefilled},
      );
    } else {
      Get.toNamed(Routes.addressForm, arguments: {'prefilled': prefilled});
    }
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: selectedLatLng,
                      zoom: 15,
                    ),
                    myLocationEnabled: canUseMyLocation,
                    myLocationButtonEnabled: canUseMyLocation,
                    onMapCreated: (c) => mapController = c,
                    onTap: (latLng) async {
                      setState(() => selectedLatLng = latLng);
                      await _reverseGeocode(latLng);
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: selectedLatLng,
                      ),
                    },
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                      ),
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 15,
                top: 10,
              ),
              child: CustomButton(
                text: 'تأكيد الموقع',
                onPressed: _confirmSelection,
                isLoading: isLoading,
                isDisabled: selectedStreet == null || selectedCity == null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
