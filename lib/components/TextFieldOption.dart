import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

class TextFieldOption extends StatefulWidget {
  TextFieldOption(this.label, this.value);

  final String label;
  final String value;

  @override
  _TextFieldOptionState createState() => _TextFieldOptionState();
}

class _TextFieldOptionState extends State<TextFieldOption> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = GlobalConfiguration().getValue(widget.value);
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.5,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(23.0),
                topRight: Radius.zero,
                bottomLeft: Radius.circular(23.0),
                bottomRight: Radius.zero,
              ),
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Text(widget.label,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black54,
                fontSize: MediaQuery.of(context).size.width*0.032,
                decoration: TextDecoration.none
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.35,
            height: 45,
            child: Scaffold(
              backgroundColor: Colors.black.withOpacity(0),
              body: TextField(
                autofocus: false,
                controller: this.controller,
                cursorColor: Colors.blue,
                cursorWidth: 4,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.left,
                onChanged: (text){
                  GlobalConfiguration().updateValue(widget.value, controller.text);
                  print(GlobalConfiguration().getValue(widget.value));
                },
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: MediaQuery.of(context).size.width*0.032
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  fillColor: Colors.white70.withOpacity(0.7),
                  focusColor: Colors.white70.withOpacity(0.7),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(23.0),
                      topLeft: Radius.zero,
                      bottomRight: Radius.circular(23.0),
                      bottomLeft: Radius.zero,
                    ),
                  ),
                ),
              ),
            )
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
