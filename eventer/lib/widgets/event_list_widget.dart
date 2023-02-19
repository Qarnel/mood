import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../repositories/event_repository.dart';
import '../models/event.dart';
import '../pages/event_page.dart';

class EventListWidget extends StatefulWidget {
  final double scrollDelta = 200;
  final int limitShowed = 20;
  final int limitLoad = 5;

  const EventListWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventListWidgetState createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  StreamSubscription<EventListAction>? _streamSubscription;
  final ScrollController _scrollController = ScrollController();
  final List<Event> _itemList = [];
  bool _loading = false;
  int _firstLoaded = 0;
  int _lastLoaded = 0;
  int _maxLength = 0;

  @override
  void initState() {
    super.initState();

    _streamSubscription = EventRepository().stream.listen((listAction) {
      if (listAction.isDeletion) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${listAction.id.toString()} deleted")));
      } else if (listAction.isAddition) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${listAction.id.toString()} added")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${listAction.id.toString()} modified")));
      }

      updateState();
    });

    _scrollController.addListener(() {
      final double maxScroll = _scrollController.position.maxScrollExtent;
      final double currentScroll = _scrollController.position.pixels;

      if (kDebugMode) {
        print("maxScroll=$maxScroll");
        print("currentScroll=$currentScroll");
        print("_maxLength=$_maxLength");
      }

      if (maxScroll - currentScroll < widget.scrollDelta) {
        if (_lastLoaded < _maxLength - 1) {
          int offset = _lastLoaded + 1;
          int limit = min(widget.limitLoad, _maxLength - offset + 1);
          _loadNext(offset, limit);
        }
      } else if (currentScroll < widget.scrollDelta) {
        if (_firstLoaded > 0) {
          int offset = max(0, _firstLoaded - widget.limitLoad);
          int limit = min(widget.limitLoad, _firstLoaded - offset);
          _loadPrevious(offset, limit);
        }
      }
    });

    updateState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _load(int offset, int limit) {
    if (kDebugMode) {
      print("offset=$offset");
      print("limit=$limit");
    }
    if (_loading) {
      return;
    }
    _loading = true;

    List<Event> newList =
        EventRepository().getAllSync(offset: offset, limit: limit);

    setState(() {
      _lastLoaded = offset + newList.length - 1;
      _firstLoaded = max(offset, _lastLoaded - widget.limitShowed + 1);

      if (kDebugMode) {
        print("_lastLoaded=$_lastLoaded");
        print("_firstLoaded=$_firstLoaded");
      }

      // Merge lists
      _itemList.addAll(newList);
      _itemList.sort((a, b) => b.date!.compareTo(a.date!));
    });
    _loading = false;
  }

  void _loadNext(int offset, int limit) {
    if (kDebugMode) {
      print("offset=$offset");
      print("limit=$limit");
    }
    if (_loading) {
      return;
    }
    _loading = true;

    List<Event> newList =
        EventRepository().getAllSync(offset: offset, limit: limit);
    if (kDebugMode) {
      print("newList.length=${newList.length}");
    }
    setState(() {
      _lastLoaded = offset + newList.length - 1;
      _firstLoaded = max(_firstLoaded, _lastLoaded - widget.limitShowed + 1);

      if (kDebugMode) {
        print("_lastLoaded=$_lastLoaded");
        print("_firstLoaded=$_firstLoaded");
      }

      // Keep only widget.limitShowed items
      for (int i = 0; i < newList.length; i++) {
        _itemList.removeAt(i);
      }

      // Merge lists
      _itemList.addAll(newList);
      _itemList.sort((a, b) => b.date!.compareTo(a.date!));
    });
    _loading = false;
  }

  void _loadPrevious(int offset, int limit) {
    if (kDebugMode) {
      print("offset=$offset");
      print("limit=$limit");
    }
    if (_loading) {
      return;
    }
    _loading = true;

    List<Event> newList =
        EventRepository().getAllSync(offset: offset, limit: limit);

    setState(() {
      _firstLoaded = offset;
      _lastLoaded = min(_lastLoaded, _firstLoaded + widget.limitShowed - 1);

      if (kDebugMode) {
        print("_lastLoaded=$_lastLoaded");
        print("_firstLoaded=$_firstLoaded");
      }

      // Merge lists
      _itemList.addAll(newList);
      _itemList.sort((a, b) => b.date!.compareTo(a.date!));

      // Keep only widget.limitShowed items
      for (int i = widget.limitShowed; i < _itemList.length;) {
        _itemList.removeAt(i);
      }
    });

    _loading = false;
  }

  void updateState() {
    _maxLength = EventRepository().getCountSync();

    _itemList.clear();
    int offset = max(0, _firstLoaded - widget.limitLoad);
    int limit = widget.limitShowed;
    _load(offset, limit);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: const EdgeInsets.all(5),
        controller: _scrollController,
        itemCount: _itemList.length,
        itemBuilder: (context, index) {
          Event item = _itemList[index];
          return ListTile(
            title: Text("${item.dateToString} ${item.typeToString}"),
            subtitle: Text("${item.levelToString} / 100"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    context.push(EventPage.routeName, extra: item);
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () async {
                    await EventRepository().delete(item.id!);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
