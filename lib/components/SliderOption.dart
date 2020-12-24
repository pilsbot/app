import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

class SliderOption extends StatefulWidget {
  SliderOption(this.label, this.value);

  final String label;
  final String value;

  @override
  _SliderOptionState createState() => _SliderOptionState();
}

class _SliderOptionState extends State<SliderOption> {

  double value = 0.0;

  @override
  Widget build(BuildContext context) {
    value = double.parse(GlobalConfiguration().getValue(widget.value));
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white70,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(23.0),
                  topLeft: Radius.zero,
                  bottomRight: Radius.circular(23.0),
                  bottomLeft: Radius.zero,
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.black54.withOpacity(0),
                body:Slider(
                  value: value,
                  activeColor: Colors.black54,
                  onChanged: (v){
                    print(value);
                    GlobalConfiguration().updateValue(widget.value, v.toString());
                    print(GlobalConfiguration().toString());
                    setState(() { value = v; });
                  },
                ),
              ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
