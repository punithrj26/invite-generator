import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/config/env.dart';
import '../../../../core/error/app_failure.dart';
import '../../domain/invitation.dart';
import 'invitations_list_controller.dart';

/// Home (`/`): the user's invitations, newest edit first.
class InvitationsListScreen extends ConsumerWidget {
  const InvitationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(invitationsListControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'More',
            onSelected: context.push,
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: '/templates',
                child: Text('Browse designs'),
              ),
              if (!Env.isProd)
                const PopupMenuItem(
                  value: '/dev/template-playground',
                  child: Text('Template playground'),
                ),
            ],
          ),
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/invitations/new'),
        icon: const Icon(Icons.add),
        label: const Text('New invitation'),
      ),
      body: SafeArea(
        child: switch (list) {
          AsyncData(:final value) when value.items.isEmpty => const _Empty(),
          AsyncData(:final value) => RefreshIndicator(
            onRefresh: () =>
                ref.refresh(invitationsListControllerProvider.future),
            child: NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n.metrics.extentAfter < 400) {
                  ref
                      .read(invitationsListControllerProvider.notifier)
                      .loadMore();
                }
                return false;
              },
              child: ListView.separated(
                // Bottom padding keeps the last row clear of the FAB.
                padding: const EdgeInsets.fromLTRB(
                  Space.md,
                  Space.md,
                  Space.md,
                  96,
                ),
                itemCount:
                    value.items.length + (value.nextCursor == null ? 0 : 1),
                separatorBuilder: (_, _) => const SizedBox(height: Space.sm),
                itemBuilder: (_, i) => i == value.items.length
                    ? const Padding(
                        padding: EdgeInsets.all(Space.md),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _Row(value.items[i]),
              ),
            ),
          ),
          AsyncError(:final error) => Center(
            child: Padding(
              padding: const EdgeInsets.all(Space.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    error is AppFailure
                        ? error.message
                        : const ServerFailure().message,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Space.md),
                  FilledButton(
                    onPressed: () =>
                        ref.invalidate(invitationsListControllerProvider),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          ),
          _ => Center(
            child: Semantics(
              label: 'Loading invitations',
              child: const CircularProgressIndicator(),
            ),
          ),
        },
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.celebration_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: Space.md),
            Text('No invitations yet', style: text.headlineSmall),
            const SizedBox(height: Space.sm),
            Text(
              'Create one in a couple of minutes: add the details, pick a design, share the link.',
              style: text.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends ConsumerWidget {
  const _Row(this.item);

  final InvitationSummary item;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete this invitation?'),
        content: Text(
          '"${item.eventName}" will be removed. This can\'t be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(invitationsListControllerProvider.notifier)
          .delete(item.id);
      messenger.showSnackBar(
        const SnackBar(content: Text('Invitation deleted')),
      );
    } on AppFailure catch (f) {
      messenger.showSnackBar(SnackBar(content: Text(f.message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final date = DateTime.tryParse(item.date);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        minTileHeight: 72,
        leading: const Icon(Icons.cake_outlined),
        title: Text(
          item.eventName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          [
            if (date != null)
              DateFormat('EEE, d MMM yyyy', 'en_US').format(date),
            switch (item.status) {
              InvitationStatus.draft => 'Draft',
              InvitationStatus.published => 'Published',
              InvitationStatus.unpublished => 'Unpublished',
            },
          ].join(' · '),
        ),
        onTap: () => context.push('/invitations/${item.id}/preview'),
        trailing: PopupMenuButton<String>(
          tooltip: 'Options for ${item.eventName}',
          icon: Icon(Icons.more_vert, color: scheme.onSurfaceVariant),
          onSelected: (_) => _delete(context, ref),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
