import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/Controller/tasks_controller.dart';

class AnimatedListWidget extends StatefulWidget {
  final List<String> notifyTimeList;
  const AnimatedListWidget({super.key, required this.notifyTimeList});

  @override
  State<AnimatedListWidget> createState() => _AnimatedListWidgetState();
}

class _AnimatedListWidgetState extends State<AnimatedListWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _removeItem(int index) {
    String removedItem = widget.notifyTimeList[index];
    widget.notifyTimeList.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildRemovedItem(removedItem, animation),
    );
  }

  Widget _buildRemovedItem(String item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            item,
            textAlign: TextAlign.center,
            style: GoogleFonts.merriweather(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: GestureDetector(
          onLongPress: () => _removeItem(widget.notifyTimeList.indexOf(item)),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              item,
              textAlign: TextAlign.center,
              style: GoogleFonts.merriweather(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (widget.notifyTimeList.isEmpty)
        ? const SizedBox()
        : AnimatedList(
            key: _listKey,
            initialItemCount: widget.notifyTimeList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index, animation) {
              return _buildItem(widget.notifyTimeList[index], animation);
            },
          );
  }
}
