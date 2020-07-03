import 'package:Flutterban/application/store/kanban.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../domain/entities/data.dart';
import '../../domain/entities/task.dart';
import '../widgets/add_column_button_widget.dart';
import '../widgets/add_column_widget.dart';
import '../widgets/add_task_widget.dart';
import '../widgets/column_widget.dart';

class KanbanPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final Kanban kanban = Kanban();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        statusBarBrightness:
            Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );
    return Scaffold(
      body: Observer(
        builder: (_) => SafeArea(
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: kanban.items.length + 1,
            itemBuilder: (context, index) {
              if (index == kanban.items.length) {
                return AddColumnButton(
                  key: UniqueKey(),
                  addColumnAction: () => _showAddColumn(context),
                );
              } else {
                return KanbanColumn(
                  key: UniqueKey(),
                  column: kanban.items[index],
                  index: index,
                  dragHandler: (KData data, int currentIndex) =>
                      _handleDrag(data, currentIndex),
                  reorderHandler:
                      (int oldIndex, int newIndex, int columnIndex) =>
                          _handleReOrder(oldIndex, newIndex, columnIndex),
                  addTaskHandler: (int index) => _showAddTask(context, index),
                  dragListener: (PointerMoveEvent event) =>
                      _dragListener(context, event),
                  deleteItemHandler: (int index, KTask task) =>
                      _deleteItem(index, task),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _dragListener(BuildContext context, PointerMoveEvent event) {
    if (event.position.dx > MediaQuery.of(context).size.width - 20) {
      _scrollController.jumpTo(_scrollController.offset + 10);
    } else if (event.position.dx < 20) {
      _scrollController.jumpTo(_scrollController.offset - 10);
    }
  }

  void _showAddColumn(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AddColumn(
        addColumnHandler: (String title) {
          kanban.addColumn(title: title);
        },
      ),
    );
  }

  void _showAddTask(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AddTask(
        addTaskHandler: (String title) {
          kanban.addTask(column: index, title: title);
        },
      ),
    );
  }

  void _deleteItem(int columnIndex, KTask task) {
    kanban.deleteTask(column: columnIndex, task: task);
  }

  // Drag methods

  void _handleReOrder(int oldIndex, int newIndex, int index) {
    if (oldIndex != newIndex) {
      kanban.arrangeTask(column: index, from: oldIndex, to: newIndex);
    }
  }

  void _handleDrag(KData data, int currentIndex) {
    kanban.moveTask(column: currentIndex, data: data);
  }
}
