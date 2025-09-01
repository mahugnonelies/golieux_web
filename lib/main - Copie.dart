import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const GoLieuxLanding());
}

class GoLieuxLanding extends StatelessWidget {
  const GoLieuxLanding({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2A8CFF)),
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(),
    );
    return MaterialApp(
      title: 'GoLieux — Trouve rapidement les lieux utiles',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const _Home(),
      routes: {
        '/privacy': (_) => const _DocPage(
          title: 'Politique de confidentialité',
          body: _privacyText,
        ),
        '/terms': (_) => const _DocPage(
          title: 'Conditions générales',
          body: _termsText,
        ),
        '/legal': (_) => const _DocPage(
          title: 'Mentions légales',
          body: _legalText,
        ),
      },
    );
  }
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            _HeroSection(),
            _FeaturesSection(),
            _ScreenshotsSection(),
            _CtaSection(),
            _Footer(),
          ],
        ),
      ),
    );
  }
}

/* ------------------ HERO ------------------ */
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primaryContainer],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final isWide = c.maxWidth > 900;
          final titleStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
            color: cs.onPrimary,
            fontWeight: FontWeight.w800,
            height: 1.1,
          );
          final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
            color: cs.onPrimary.withOpacity(0.95),
          );

          final left = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GoLieux', style: titleStyle),
              const SizedBox(height: 12),
              Text(
                'Trouvez rapidement les lieux utiles autour de vous au Bénin.\n'
                    'Pharmacies, banques, services publics, artisans… en un clic.',
                style: subtitleStyle,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StoreButton(
                    label: 'Télécharger sur Play Store',
                    icon: Icons.android,
                    onTap: () => _launch('https://play.google.com/store/apps/details?id=com.example.golieux'),
                  ),
                  _StoreButton(
                    label: 'Bientôt sur App Store',
                    icon: Icons.apple,
                    onTap: () {}, // à activer quand dispo
                    disabled: true,
                  ),
                ],
              ),
            ],
          );

          final right = AspectRatio(
            aspectRatio: 3/2,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.25)),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  // Remplace par Image.asset('assets/hero.png', fit: BoxFit.contain)
                  child: Icon(Icons.map_rounded, size: 120, color: Colors.white),
                ),
              ),
            ),
          );

          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: isWide
                ? Row(
              children: [
                Expanded(child: left),
                const SizedBox(width: 36),
                Expanded(child: right),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                left,
                right,
              ],
            ),
          );
        },
      ),
    );
  }
}

/* ------------------ FEATURES ------------------ */
class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final items = const [
      _Feature(icon: Icons.flash_on, title: 'Rapide', text: 'Des résultats pertinents en un coup d’œil.'),
      _Feature(icon: Icons.verified, title: 'Fiable', text: 'Fiches modérées avant publication.'),
      _Feature(icon: Icons.public, title: 'Local', text: 'Pensé pour les villes et départements du Bénin.'),
      _Feature(icon: Icons.shield_outlined, title: 'Sécurisé', text: 'Connexion sans mot de passe par code OTP.'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pourquoi GoLieux ?', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              )),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, c) {
                  final col = c.maxWidth > 950 ? 4 : (c.maxWidth > 700 ? 2 : 1);
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: List.generate(items.length, (i) {
                      final w = c.maxWidth / col - (16 * (col - 1)) / col;
                      return SizedBox(
                        width: max(260, min(w, 360)),
                        child: _FeatureCard(item: items[i], color: cs.primary),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String text;
  const _Feature({required this.icon, required this.title, required this.text});
}

class _FeatureCard extends StatelessWidget {
  final _Feature item;
  final Color color;
  const _FeatureCard({required this.item, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withOpacity(0.12)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.12),
            child: Icon(item.icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(item.text),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/* ------------------ SCREENSHOTS ------------------ */
class _ScreenshotsSection extends StatelessWidget {
  const _ScreenshotsSection();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget card(Widget child) => Container(
      width: 280,
      height: 520,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: cs.surface,
        border: Border.all(color: cs.primary.withOpacity(0.12)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: child,
      ),
    );

    return Container(
      color: cs.surfaceContainerLowest,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Aperçu de l’application', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              )),
              const SizedBox(height: 18),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  // Remplace les Containers par Image.asset('assets/screen1.png', fit: BoxFit.cover)
                  card(Container(color: cs.primary.withOpacity(0.08), child: const Center(child: Icon(Icons.map, size: 64)))),
                  card(Container(color: cs.primary.withOpacity(0.08), child: const Center(child: Icon(Icons.search, size: 64)))),
                  card(Container(color: cs.primary.withOpacity(0.08), child: const Center(child: Icon(Icons.place, size: 64)))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ------------------ CTA ------------------ */
class _CtaSection extends StatelessWidget {
  const _CtaSection();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primaryContainer, cs.primary],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Text(
                'Prêt à découvrir GoLieux ?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: cs.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Télécharge l’application et trouve ce dont tu as besoin, tout de suite.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: cs.onPrimary.withOpacity(0.95),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StoreButton(
                    label: 'Télécharger sur Play Store',
                    icon: Icons.android,
                    onTap: () => _launch('https://play.google.com/store/apps/details?id=com.example.golieux'),
                  ),
                  _GhostButton(
                    label: 'Lire la politique de confidentialité',
                    onTap: () => Navigator.pushNamed(context, '/privacy'),
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

/* ------------------ FOOTER ------------------ */
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 10,
            children: [
              Text('CONÇU PAR MAHUGNON ELIE SOGLO', style: TextStyle(color: cs.outline)),
              Wrap(
                spacing: 16,
                children: [
                  TextButton(onPressed: () => Navigator.pushNamed(context, '/privacy'), child: const Text('Confidentialité')),
                  TextButton(onPressed: () => Navigator.pushNamed(context, '/terms'), child: const Text('Conditions')),
                  TextButton(onPressed: () => Navigator.pushNamed(context, '/legal'), child: const Text('Mentions légales')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ------------------ BOUTONS ------------------ */
class _StoreButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool disabled;
  const _StoreButton({required this.label, required this.icon, required this.onTap, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FilledButton.icon(
      onPressed: disabled ? null : onTap,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        backgroundColor: disabled ? cs.surfaceVariant : cs.primary,
        foregroundColor: cs.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _GhostButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
      child: Text(label),
    );
  }
}

/* ------------------ PAGES DOC ------------------ */
class _DocPage extends StatelessWidget {
  final String title;
  final String body;
  const _DocPage({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.primary.withOpacity(0.10)),
            ),
            child: Text(body),
          ),
        ],
      ),
    );
  }
}

/* ------------------ TEXTES ------------------ */
const _privacyText =
    'Cette politique décrit comment GoLieux collecte, utilise et protège vos données…\n'
    '• Données de compte (email/téléphone) pour l’authentification OTP\n'
    '• Données d’usage anonymisées pour améliorer le service\n'
    '• Vous pouvez demander la suppression à tout moment…';

const _termsText =
    'En utilisant GoLieux, vous acceptez ces conditions…\n'
    '• Utilisation raisonnable de l’app\n'
    '• Respect de la vie privée des établissements\n'
    '• Interdiction de contenu illégal, etc.';

const _legalText =
    'GoLieux — Éditeur : Mahugnon Elie Soglo.\n'
    'Contact : mahugnonelies@gmail.com\n'
    'Hébergement : selon votre fournisseur (Netlify, Firebase, etc.).';

/* ------------------ UTILS ------------------ */
Future<void> _launch(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
