import 'package:flutter/material.dart';

class DraftGuard extends StatefulWidget {
  const DraftGuard({
    super.key,
    required this.dirty,
    required this.saving,
    required this.child,
  });
  final bool dirty;
  final bool saving;
  final Widget child;
  @override
  State<DraftGuard> createState() => _DraftGuardState();
}

class _DraftGuardState extends State<DraftGuard> {
  bool _allowExit = false;
  bool _asking = false;
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !widget.saving && (!widget.dirty || _allowExit),
    onPopInvokedWithResult: (didPop, result) async {
      if (didPop || widget.saving || _asking) return;
      _asking = true;
      final discard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard unsaved changes?'),
          content: const Text('Your saved budget will stay unchanged.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep editing'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
      _asking = false;
      if (!mounted || discard != true) return;
      setState(() => _allowExit = true);
      await WidgetsBinding.instance.endOfFrame;
      if (context.mounted) Navigator.of(context).maybePop();
    },
    child: widget.child,
  );
}
