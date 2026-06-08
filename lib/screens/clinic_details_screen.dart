import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/clinic.dart';

class ClinicDetailsScreen extends StatelessWidget {
  final Clinic clinic;
  final String distanceText;

  const ClinicDetailsScreen({
    super.key,
    required this.clinic,
    this.distanceText = '',
  });

  Future<void> _openMaps(BuildContext context) => _launch(
        context: context,
        deepLink: Uri.parse(
          'https://www.google.com/maps/search/?api=1'
          '&query=${clinic.lat},${clinic.lng}'
          '&query_place_id=${clinic.placeId}',
        ),
        fallback: Uri.parse(
          'https://play.google.com/store/apps/details?id=com.google.android.apps.maps',
        ),
        appName: 'Google Maps',
      );

  Future<void> _openUber(BuildContext context) => _launch(
        context: context,
        deepLink: Uri.parse(
          'uber://?action=setPickup'
          '&pickup=my_location'
          '&dropoff[latitude]=${clinic.lat}'
          '&dropoff[longitude]=${clinic.lng}'
          '&dropoff[nickname]=${Uri.encodeComponent(clinic.name)}',
        ),
        fallback: Uri.parse(
          'https://play.google.com/store/apps/details?id=com.ubercab',
        ),
        appName: 'Uber',
      );

  Future<void> _open99(BuildContext context) => _launch(
        context: context,
        deepLink: Uri.parse(
          'taxis99://call?dropoff_lat=${clinic.lat}&dropoff_lng=${clinic.lng}',
        ),
        fallback: Uri.parse(
          'https://play.google.com/store/apps/details?id=com.taxis99',
        ),
        appName: '99',
      );

  static Future<void> _launch({
    required BuildContext context,
    required Uri deepLink,
    required Uri fallback,
    required String appName,
  }) async {
    try {
      if (await canLaunchUrl(deepLink)) {
        await launchUrl(deepLink);
      } else {
        await launchUrl(fallback, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir $appName.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Clínica'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomNavigationBar: _ActionBar(
        onUber: () => _openUber(context),
        on99: () => _open99(context),
        onMaps: () => _openMaps(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MainCard(clinic: clinic, distanceText: distanceText),
            const SizedBox(height: 20),
            _Section(
              title: 'Sobre',
              child: Text(
                clinic.about,
                style: TextStyle(color: Colors.grey[700], height: 1.5),
              ),
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Especialidades',
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: clinic.specialties
                    .map((s) => Chip(
                          label: Text(
                            s,
                            style: const TextStyle(
                              color: Color(0xFF00695C),
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: const Color(0xFFE0F2F1),
                          side: BorderSide.none,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Avaliações',
              child: Column(
                children: clinic.reviews
                    .map((r) => _ReviewCard(review: r))
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _MainCard extends StatelessWidget {
  const _MainCard({required this.clinic, required this.distanceText});

  final Clinic clinic;
  final String distanceText;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              clinic.name,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  clinic.rating.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${clinic.reviewCount} avaliações)',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.location_on_outlined,
              text: clinic.address,
            ),
            if (distanceText.isNotEmpty) ...[
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.near_me_rounded,
                text: '$distanceText de você',
                iconColor: Theme.of(context).colorScheme.primary,
              ),
            ],
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.phone_outlined,
              text: clinic.phone.isNotEmpty ? clinic.phone : 'Não informado',
              textColor: clinic.phone.isNotEmpty ? null : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String text;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: iconColor ?? Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.grey[800],
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 0.3,
              ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ...List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating.round()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  review.reviewerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              review.comment,
              style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.onUber,
    required this.on99,
    required this.onMaps,
  });

  final VoidCallback onUber;
  final VoidCallback on99;
  final VoidCallback onMaps;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          children: [
            Expanded(
              child: _AppButton(
                label: 'Uber',
                color: Colors.black,
                textColor: Colors.white,
                onPressed: onUber,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _AppButton(
                label: '99',
                color: const Color(0xFFFFCC00),
                textColor: Colors.black,
                onPressed: on99,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _AppButton(
                label: 'Maps',
                color: const Color(0xFF1A73E8),
                textColor: Colors.white,
                onPressed: onMaps,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppButton extends StatelessWidget {
  const _AppButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
