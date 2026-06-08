import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/clinic.dart';
import '../services/clinic_service.dart';
import 'auth/login_screen.dart';
import 'clinic_details_screen.dart';

const Color _kTeal = Color(0xFF26A69A);

enum _LocationStatus { loading, ready, denied, error }

class ClinicsListScreen extends StatefulWidget {
  const ClinicsListScreen({super.key});

  @override
  State<ClinicsListScreen> createState() => _ClinicsListScreenState();
}

class _ClinicsListScreenState extends State<ClinicsListScreen> {
  final List<Clinic> _allClinics = ClinicService.getAll();

  late final List<String> _allTopics = _buildTopicList();

  String? _selectedTopic;

  _LocationStatus _locationStatus = _LocationStatus.loading;
  double? _userLat;
  double? _userLng;

  List<String> _buildTopicList() {
    const preferredOrder = [
      'Ansiedade',
      'Depressão',
      'Autoestima',
      'Burnout',
      'Casal',
      'Luto',
      'Autoconhecimento',
      'Terapia Infantil',
    ];
    final present = <String>{};
    for (final c in _allClinics) {
      present.addAll(c.topics);
    }
    final ordered = preferredOrder.where(present.contains).toList();
    for (final t in present) {
      if (!ordered.contains(t)) ordered.add(t);
    }
    return ordered;
  }

  List<Clinic> get _filteredClinics {
    if (_selectedTopic == null) return _allClinics;
    return _allClinics
        .where((c) => c.topics.contains(_selectedTopic))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => _locationStatus = _LocationStatus.denied);
        return;
      }

      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null && mounted) {
        setState(() {
          _userLat = lastKnown.latitude;
          _userLng = lastKnown.longitude;
          _locationStatus = _LocationStatus.ready;
        });
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      if (mounted) {
        setState(() {
          _userLat = position.latitude;
          _userLng = position.longitude;
          _locationStatus = _LocationStatus.ready;
        });
      }
    } catch (e) {
      debugPrint('[GPS] Erro: $e');
      if (mounted) setState(() => _locationStatus = _LocationStatus.error);
    }
  }

  String _formatDistance(Clinic clinic) {
    if (_userLat == null || _userLng == null) return '';
    final meters =
        Geolocator.distanceBetween(_userLat!, _userLng!, clinic.lat, clinic.lng);
    return meters < 1000
        ? '${meters.round()} m'
        : '${(meters / 1000).toStringAsFixed(1)} km';
  }

  Future<void> _openInMaps(Clinic clinic) async {
    final uri = Uri.parse(clinic.mapsUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o mapa.')),
        );
      }
    }
  }

  void _openDetails(Clinic clinic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClinicDetailsScreen(
          clinic: clinic,
          distanceText: _formatDistance(clinic),
        ),
      ),
    );
  }

  void _selectTopic(String? topic) {
    setState(() => _selectedTopic = topic);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredClinics;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clínicas de Psicologia'),
        backgroundColor: _kTeal,
        foregroundColor: Colors.white,
        actions: [
          if (_locationStatus == _LocationStatus.denied ||
              _locationStatus == _LocationStatus.error)
            IconButton(
              icon: const Icon(Icons.my_location),
              tooltip: 'Tentar localização novamente',
              onPressed: _fetchLocation,
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterBar(
            topics: _allTopics,
            selected: _selectedTopic,
            onSelect: _selectTopic,
          ),
          if (_selectedTopic != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                '${filtered.length} clínica${filtered.length == 1 ? '' : 's'} encontrada${filtered.length == 1 ? '' : 's'}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ),
          Expanded(
            child: filtered.isEmpty
                ? _EmptyFilterResult(
                    topic: _selectedTopic!,
                    onClear: () => _selectTopic(null),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final clinic = filtered[index];
                      return _ClinicCard(
                        clinic: clinic,
                        distanceLabel: _buildDistanceChip(clinic),
                        onOpenMap: () => _openInMaps(clinic),
                        onTap: () => _openDetails(clinic),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceChip(Clinic clinic) {
    switch (_locationStatus) {
      case _LocationStatus.loading:
        return const _DistanceChip(
          icon: Icons.hourglass_top_rounded,
          label: 'Calculando...',
          color: Colors.grey,
        );
      case _LocationStatus.ready:
        return _DistanceChip(
          icon: Icons.near_me_rounded,
          label: _formatDistance(clinic),
          color: _kTeal,
        );
      case _LocationStatus.denied:
        return const _DistanceChip(
          icon: Icons.location_off_outlined,
          label: 'Sem permissão',
          color: Colors.orange,
        );
      case _LocationStatus.error:
        return const _DistanceChip(
          icon: Icons.gps_off,
          label: 'GPS indisponível',
          color: Colors.red,
        );
    }
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.topics,
    required this.selected,
    required this.onSelect,
  });

  final List<String> topics;
  final String? selected;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            _TopicChip(
              label: 'Todas',
              isSelected: selected == null,
              onTap: () => onSelect(null),
            ),
            const SizedBox(width: 8),
            ...topics.map((topic) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _TopicChip(
                    label: topic,
                    isSelected: selected == topic,
                    onTap: () => onSelect(selected == topic ? null : topic),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? _kTeal : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _kTeal : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.grey.shade800,
          ),
        ),
      ),
    );
  }
}

class _EmptyFilterResult extends StatelessWidget {
  const _EmptyFilterResult({required this.topic, required this.onClear});

  final String topic;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Nenhuma clínica encontrada\npara "$topic"',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onClear,
              child: const Text('Ver todas as clínicas'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClinicCard extends StatelessWidget {
  const _ClinicCard({
    required this.clinic,
    required this.distanceLabel,
    required this.onOpenMap,
    required this.onTap,
  });

  final Clinic clinic;
  final Widget distanceLabel;
  final VoidCallback onOpenMap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      clinic.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  distanceLabel,
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                  const SizedBox(width: 3),
                  Text(
                    clinic.rating.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${clinic.reviewCount})',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      clinic.address,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
              if (clinic.topics.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: clinic.topics
                      .map((t) => _InlineTag(label: t))
                      .toList(),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onOpenMap,
                      icon: const Icon(Icons.map_outlined, size: 18),
                      label: const Text('Abrir no Mapa'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: _kTeal),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(foregroundColor: _kTeal),
                    child: const Text('Ver detalhes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineTag extends StatelessWidget {
  const _InlineTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _kTeal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: _kTeal,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _DistanceChip extends StatelessWidget {
  const _DistanceChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style:
              Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
