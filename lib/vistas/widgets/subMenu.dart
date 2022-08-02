import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class Configuracion extends StatelessWidget {

  final List<Widget> subMenu;
  final Icon icon;
  final Color color = Color.fromRGBO(83, 86, 90, 1.0);
  final String titulo;
  Configuracion(this.subMenu,this.titulo,this.icon);
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
    child: Padding(
      padding: const EdgeInsets.all(0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                  padding: EdgeInsets.all(0),
                  child:
                  Container(
                    height: 32,
                    margin: EdgeInsets.only(top:1),
                    decoration: BoxDecoration(
                      //color: Colors.white,  
                    ),
                    child:Row(
                      children:<Widget>[
                        Container(
                          child:IconButton(
                            iconSize: 15,
                            icon: icon,
                            color: Colors.grey[600],
                            onPressed: () {
                              //inicio();
                              //Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Padding( padding: EdgeInsets.only(top: 9, left: 0, right: 5),
                          child:Center(
                            child:Text(titulo,style: TextStyle(
                              //color:color,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                            ),
                          ),
                        ),
                      ],
                    ) ,
                  ),
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: subMenu,
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}