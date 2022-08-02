import 'package:flutter/material.dart';

class DropdownSoatView extends StatefulWidget {
  final String texto;
  final dynamic alCambiar;
  final String dropdownValor;
  final List <String> documentosLista;

  DropdownSoatView({this.texto,this.alCambiar,this.documentosLista,this.dropdownValor});

  @override
  _DropdownSoatViewState createState() => _DropdownSoatViewState();
}
class _DropdownSoatViewState extends State<DropdownSoatView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      //margin: const EdgeInsets.fromLTRB(30, 5, 30,10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            //color: Color.fromRGBO(83, 86, 90, 1.0),
          ),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Center(
            child: Text(
              widget.texto,
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
          ),
          value: widget.dropdownValor,
          iconSize: 0,
          elevation: 2,
          underline: Container(
            height: 2,
          ),
          onChanged: widget.alCambiar,
          items: widget.documentosLista
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: new Text(
                  value, textAlign: TextAlign.center,
                  //style: new TextStyle(color: Colors.black)
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}