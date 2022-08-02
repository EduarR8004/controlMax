import 'package:flutter/material.dart';
import 'package:controlmax/modelos/Rol.dart';
import 'package:controlmax/modelos/Objeto.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';

class ObjetosAsignados extends StatefulWidget {
  final String token;
  final List <Rol>obj;
  ObjetosAsignados(this.token,this.obj) : super();
  @override
  _ObjetosAsignadosState createState() => _ObjetosAsignadosState();
}

class _ObjetosAsignadosState extends State<ObjetosAsignados> {
  List<Objeto> objetos=[];
  List<Objeto> objetosNo=[];
  Objeto consulta;
  String token;
  List<Objeto> selectedObject;
  List<Objeto> selectedObjectNo;
  bool refrescar = false;
  bool sort;
  bool sortNo;
  bool validar;
  bool borrar=false;
  String mensaje,texto;

   
   @override
  void initState() {
    sort = false;
    sortNo = false;
    token=widget.token;
    selectedObject = [];
    objetos=[];
    selectedObjectNo = [];
    objetosNo=[];
    //users =widget.data.usuarios ;
    //listar_usuario();
    super.initState();
  }

  void borrarTabla(){
    setState(() {
      objetos=[]; 
    });
  }
  
  
  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        objetos.sort((a, b) => a.objeto.compareTo(b.objeto));
      } else {
        objetos.sort((a, b) => b.objeto.compareTo(a.objeto));
      }
    }
  }

   onSortColumNo(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        objetosNo.sort((a, b) => a.objeto.compareTo(b.objeto));
      } else {
        objetosNo.sort((a, b) => b.objeto.compareTo(a.objeto));
      }
    }
  }
 
  onSelectedRowNo(bool selected, Objeto obj) async {
    setState(() {
      if (selected) {
        selectedObjectNo.add(obj);
      } else {
        selectedObjectNo.remove(obj);
      }
    });
  }
 
  onSelectedRow(bool selected, Objeto obj) async {
    setState(() {
      if (selected) {
        selectedObject.add(obj);
      } else {
        selectedObject.remove(obj);
      }
    });
  }

  deleteSelected() async {
    setState(() {
      List objetoa=[];
      if (selectedObject.isNotEmpty) {
        List<Objeto> temp = [];
        temp.addAll(selectedObject);
        for (Objeto obj in temp) {
          objetoa.add(obj.objeto);
          objetos.remove(obj);
          selectedObject.remove(obj); 
          //_showAlertDialogOnly('Usuario Eliminado Correctamente','Eliminar Usario');
       }
       removerObjetos(objetoa);
       successDialog(
       context, 
        'Se quitaron los objetos seleccionados',
        neutralText: "Aceptar",
        neutralAction: (){},
      );
      }else
      {  
        errorDialog(
          context, 
          "Por favor seleccione un objeto",
          negativeAction: (){
          },
        );
      }
    });
  }

  Future <List<Objeto>> listarObjetosAsignados(rol)async{
    var session= Insertar();
    if(selectedObject.length > 0){
      return objetos;
    }else if(borrar==true)
    {
      return objetos;
    }else if(objetos.length > 0 && borrar==true )
    {
      return objetos;
    }
    else
    {
      await session.descargarObjetosAsignados(rol,token).then((_){
        var preObjetos=session.obtenerAsignados();
        objetos=[];
        for ( var obj in preObjetos)
        {
         objetos.add(obj);
        }        
      });
      return objetos;
    }
}

removerObjetos(objetoa)async{
  var session= Insertar();
  await session.removerObjeto(widget.obj[0].nombre,token,objetoa).then((_){
  });
}

  deleteSelectedNo() async {
    setState(() {
      List objetoNoT=[];
      if (selectedObjectNo.isNotEmpty) {
        List<Objeto> temp = [];
        temp.addAll(selectedObjectNo);
        for (Objeto obj in temp) {
          objetoNoT.add(obj.objeto);
          objetosNo.remove(obj);
          selectedObjectNo.remove(obj); 
        }
        asignarObjeto(objetoNoT);
        successDialog(
          context, 
          'Se asignaron los objetos seleccionados',
          neutralText: "Aceptar",
          neutralAction: (){},
        );
      }else
      {  
        errorDialog(
          context, 
          "Por favor seleccione un objeto",
          negativeAction: (){
          },
        );
      }
    });
  }

  Future <List<Objeto>> listarObjetosNoasignados(rol)async{
    var session= Insertar();
    if(selectedObjectNo.length > 0){
       return objetosNo;
    }else if(borrar==true)
    {
      return objetos;
    }else if(objetosNo.length > 0 && borrar==true )
    {
      return objetosNo;
    }
    else
    {
      await session.descargarObjetosNoAsignados(rol, token).then((_){
        var preObjetos=session.obtenerNoAsignados();
        objetosNo=[];
        for ( var obj in preObjetos)
        {
         objetosNo.add(obj);
        }        
      });
      return objetosNo;
    }
  }

asignarObjeto(objetoa)async{
  var session= Insertar();
  await session.asignarObjeto(widget.obj[0].nombre,token,objetoa).then((_){
  });
}
  _onPressed () {
    deleteSelected();
  }

  _deleteOnPressed() {
    deleteSelectedNo();
  }

  @override
  Widget build(BuildContext context) {
    var rol=widget.obj[0].nombre;
    return Expanded(child:
      SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:Column(children:[
        Padding(
          padding: EdgeInsets.all(5.0),
          child:Container(
            decoration: BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: 
          Boton(onPresed: _onPressed,texto:'Quitar',),
        ),
        ),
        dataBody(rol),   
        Container(padding: EdgeInsets.all(2),child:Column(children: [Text('Objetos No Asignados')],)),
        Padding(
          padding: EdgeInsets.all(5.0),
          child:Container(
            decoration: BoxDecoration(
              //color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child:Boton(onPresed:_deleteOnPressed,texto:'Asignar',),
          ),
        ),
        dataBodyNo(rol),  
      ],
      ),
    ),      
    );

  }

  Widget  dataBody(rol) {
      return FutureBuilder <List<Objeto>>(
      future:listarObjetosAsignados(rol),
      builder:(context,snapshot){
        if(snapshot.hasData){
          return  
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView( 
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  headingRowColor:
                MaterialStateColor.resolveWith((states) =>Theme.of(context).accentColor ),
                //Color.fromRGBO(136,139, 141, 1.0)
                sortAscending: sort,
                sortColumnIndex: 0,
                columns: [
                  DataColumn(
                    label: Text("Objeto"),
                    numeric: false,
                    tooltip: "Objeto",
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        sort = !sort;
                      });
                      onSortColum(columnIndex, ascending);
                    }
                  ),
                  DataColumn(
                    label: Text("Descripción"),
                    numeric: false,
                    tooltip: "Descripción",
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        sort = !sort;
                      });
                      onSortColum(columnIndex, ascending);
                    }
                  ),
                ],
                rows: objetos.map(
                  (obj) => DataRow(
                    selected: selectedObject.contains(obj),
                    onSelectChanged: (b) {
                      print("Onselect");
                      onSelectedRow(b, obj);
                    },
                    cells: [
                      DataCell(
                        Text(obj.objeto),
                        onTap: () {
                          print('Selected ${obj.objeto}');
                        },
                      ),
                      DataCell(
                        Text(obj.descripcion),
                      ),
                    ]
                  ),
                )
                .toList(),
              ),
            ),
          );
        }else{
          return
          Center(
            child:CircularProgressIndicator()
            //Splash1(),
          );
          
        }
      },
    );
  }

  Widget  dataBodyNo(id) {
     return FutureBuilder <List<Objeto>>(
      future:listarObjetosNoasignados(id),
      builder:(context,snapshot){
        if(snapshot.hasData){
          return  
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                  child: SingleChildScrollView( 
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                       headingRowColor:
                      MaterialStateColor.resolveWith((states) =>Theme.of(context).accentColor),
                      //Color.fromRGBO(136,139, 141, 1.0)
                      sortAscending: sort,
                      sortColumnIndex: 0,
                      columns: [
                        DataColumn(
                            label: Text("Objeto"),
                            numeric: false,
                            tooltip: "Obj",
                            onSort: (columnIndexNo, ascendingNo) {
                              setState(() {
                                sortNo = !sortNo;
                              });
                              onSortColumNo(columnIndexNo, ascendingNo);
                            }),
                        DataColumn(
                          label: Text("Descripción"),
                          numeric: false,
                          tooltip: "Descri",
                          onSort: (columnIndexNo, ascendingNo) {
                              setState(() {
                                sortNo = !sortNo;
                              });
                              onSortColumNo(columnIndexNo, ascendingNo);
                            }
                        ),
                      ],
                      rows: objetosNo
                          .map(
                            (objNo) => DataRow(
                                    selected: selectedObjectNo.contains(objNo),
                                    onSelectChanged: (b) {
                                      print("Onselect");
                                      onSelectedRowNo(b, objNo);
                                    },
                                    cells: [
                                      DataCell(
                                        Text(objNo.objeto),
                                        onTap: () {
                                          print('Selected ${objNo.objeto}');
                                        },
                                      ),
                                      DataCell(
                                        Text(objNo.descripcion),
                                      ),
                                      
                                    ]),
                          )
                          .toList(),
                    ),
                  ),
              );
          
        }else{
          return
          Center(
            child:CircularProgressIndicator()
            //Splash1(),
          );
          
        }
      },
    );
  }
  
}