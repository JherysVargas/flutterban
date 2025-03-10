import 'package:flutter/material.dart';

class AddColumnButton extends StatelessWidget {
  final Function addColumnAction;

  const AddColumnButton({super.key, required this.addColumnAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            addColumnAction();
          },
          child: Container(
            width: 300.0,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black12,
                  spreadRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const <Widget>[
                Icon(
                  Icons.add,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text("Add Column"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
