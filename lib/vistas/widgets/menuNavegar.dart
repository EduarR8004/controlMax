import 'package:flutter/material.dart';

class Navegar extends StatefulWidget {
  final Function currentIndex;
  final List <BottomNavigationBarItem> lista;
  Navegar({this.lista,this.currentIndex});
  @override
  _NavegarState createState() => _NavegarState();
}

class _NavegarState extends State<Navegar> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (int i){
        setState(() {
          index=i; 
          widget.currentIndex(i);    
        });
      },
      type: BottomNavigationBarType.fixed,
      iconSize:25,
      selectedFontSize: 13,
      unselectedFontSize:10,
      items:widget.lista
    );
  }
}