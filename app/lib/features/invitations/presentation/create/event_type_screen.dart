import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/tokens.dart';

/// Step 1 of "new invitation". Phase 1 ships birthdays; the list grows with D11 event types.
class EventTypeScreen extends StatelessWidget {
  const EventTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('New invitation')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.all(Space.lg),
              children: [
                Text("What's the occasion?", style: text.headlineSmall),
                const SizedBox(height: Space.lg),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    minTileHeight: 72,
                    leading: const Icon(Icons.cake_outlined),
                    title: const Text('Birthday'),
                    subtitle: const Text('Kids, milestones, surprise parties'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/invitations/new/birthday'),
                  ),
                ),
                const SizedBox(height: Space.md),
                Text(
                  'Weddings, baby showers and more are coming soon.',
                  style: text.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
