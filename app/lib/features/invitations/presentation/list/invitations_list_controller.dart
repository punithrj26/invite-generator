import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/invitations_repository_impl.dart';
import '../../domain/invitation.dart';

final invitationsListControllerProvider =
    AsyncNotifierProvider.autoDispose<
      InvitationsListController,
      InvitationsPage
    >(InvitationsListController.new);

/// "My invitations" with cursor pagination (docs/01 §4.3).
class InvitationsListController extends AsyncNotifier<InvitationsPage> {
  bool _loadingMore = false;

  @override
  Future<InvitationsPage> build() =>
      ref.read(invitationsRepositoryProvider).list();

  /// Appends the next page. A failure keeps the rows already shown (the error surfaces on the next refresh).
  Future<void> loadMore() async {
    final current = state.value;
    if (_loadingMore || current == null || current.nextCursor == null) return;
    _loadingMore = true;
    try {
      final next = await ref
          .read(invitationsRepositoryProvider)
          .list(cursor: current.nextCursor);
      if (!ref.mounted) return;
      state = AsyncData((
        items: [...current.items, ...next.items],
        nextCursor: next.nextCursor,
      ));
    } finally {
      _loadingMore = false;
    }
  }

  Future<void> delete(String id) async {
    await ref.read(invitationsRepositoryProvider).delete(id);
    final current = state.value;
    if (current == null || !ref.mounted) return;
    state = AsyncData((
      items: current.items.where((i) => i.id != id).toList(),
      nextCursor: current.nextCursor,
    ));
  }
}
