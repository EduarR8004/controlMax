import 'package:flutter/material.dart';
import 'package:controlmax/modelos/Rol.dart';
import 'package:controlmax/modelos/Usuarios.dart';
import 'package:controlmax/utiles/Informacion.dart';
import 'package:controlmax/vistas/widgets/boton.dart';
import 'package:controlmax/controlador/InsertarVenta.dart';

class RolesAsignados extends StatefulWidget {
  final String token;
  final List <Usuario>obj;
  RolesAsignados(this.token,this.obj) : super();
  @override
  _RolesAsignadosState createState() => _RolesAsignadosState();
}

class _RolesAsignadosState extends State<RolesAsignados> {
  List<Rol> roles=[];
  List<Rol> rolesNo=[];
  List<Rol> selectedRolNo;
  bool sortNo;
  List asignarRol;
  List<Rol> selectedRol;
  bool refrescar = false;
  bool sort;
  String _token;
  bool validar;
  bool borrar=false;
  String mensaje,texto;

   
   @override
  void initState() {
    sort = false;
    _token=widget.token;
    selectedRol = [];
    roles=[];
    sortNo = false;
    selectedRolNo = [];
    //users =widget.data.usuarios ;
    //listar_usuario();
    super.initState();
  }
  void borrarTabla(){
    setState(() {
     roles=[]; 
    });
  }
  
  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        roles.sort((a, b) => a.nombre.compareTo(b.nombre));
      } else {
        roles.sort((a, b) => b.nombre.compareTo(a.nombre));
      }
    }
  }
  onSelectedRow(bool selected, Rol rol) async {
    setState(() {
      if (selected) {
        selectedRol.add(rol);
      } else {
        selectedRol.remove(rol);
      }
    });
  }
   deleteSelected() async {
    setState(() {
      List rolesa=[];
      List rolesNombre=[];
      if (selectedRol.isNotEmpty) {
        List<Rol> temp = [];
        temp.addAll(selectedRol);
        for (Rol rol in temp) {
          rolesa.add(rol.id);
          rolesNombre.add(rol.nombre);
          roles.remove(rol);
          selectedRol.remove(rol); 
       }
       removerRoles(rolesa,rolesNombre);
       successDialog(
        context, 
        "Se quitaron los roles seleccionados",
        neutralText: "Aceptar",
        negativeAction: (){
        },
      );
      }else
      {  
        errorDialog(
          context, 
          "Por favor seleccione un rol",
          negativeAction: (){
          },
        );
      }
    });
  }
  onSortColumNo(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        rolesNo.sort((a, b) => a.nombre.compareTo(b.nombre));
      } else {
        rolesNo.sort((a, b) => b.nombre.compareTo(a.nombre));
      }
    }
  }

deleteSelectedNo() async {
  setState(() {
    List rolesa=[];
    List rolesNombre=[];
    if (selectedRolNo.isNotEmpty) {
      List<Rol> temp = [];
      temp.addAll(selectedRolNo);
      for (Rol rol in temp) {
        rolesa.add(rol.id);
        rolesNombre.add(rol.nombre);
        rolesNo.remove(rol);
        selectedRolNo.remove(rol); 
      }
      asignarRoles(rolesa,rolesNombre);
      successDialog(
        context, 
        "Se asignaron los roles seleccionados",
        neutralText: "Aceptar",
        negativeAction: (){
        },
      );
    }else
    {
      errorDialog(
        context, 
        "Por favor seleccione un rol",
        negativeAction: (){
        },
      );
    }
  });
}
 
  onSelectedRowNo(bool selected, Rol rol) async {
    setState(() {
      if (selected) {
        selectedRolNo.add(rol);
      } else {
        selectedRolNo.remove(rol);
      }
    });
  }

  Future <List<Rol>> descargarRolesNoAsignados(usuario)async{
    var session= Insertar();
    if(selectedRolNo.length > 0){
       return rolesNo;
    }else if(borrar==true)
    {
      return rolesNo;
    }else if(rolesNo.length > 0 && borrar==true )
    {
      return rolesNo;
    }
    else
    {
      await session.descargarRolesNoAsignados(usuario, _token).then((_){
        var preRol=session.obtenerRolesNoAsignados();
        rolesNo=[];
        for ( var rol in preRol)
        {
         rolesNo.add(rol);
        }        
      });
      return rolesNo;
    }
  }

asignarRoles(rolesa,rolesNombre)async{
  var session= Insertar();
  await session.asignarRol(rolesNombre, _token, widget.obj[0].usuario).then((_){
        
  });
}

  Future <List<Rol>> descargarRolesAsignados(usuario)async{
    var session= Insertar();
    if(selectedRol.length > 0){
       return roles;
    }else if(borrar==true)
    {
      return roles;
    }else if(roles.length > 0 && borrar==true )
    {
      return roles;
    }
    else
    {
      await session.descargarRolesAsignados(usuario).then((_){
        var preRol=session.obtenerRolesAsignados();
        roles=[];
        for ( var rol in preRol)
        {
         roles.add(rol);
        }        
      });
      return roles;
    }
  }

  removerRoles(rolesa,rolesNombre)async{
    var session= Insertar();
    await session.removerRol(rolesNombre, _token, widget.obj[0].usuario).then((_){
    
    });
  }

  onPressed() {
   deleteSelectedNo();
  }

  quitarPressed() {
    deleteSelected();
  }
  
  @override
  Widget build(BuildContext context) {
    var id=widget.obj[0].usuario;
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Boton(onPresed:quitarPressed,texto:'Quitar',),
            dataBody(id),
            Container(
              padding: EdgeInsets.all(2),
              child: Column(
                children: [Text('Roles No Asignados')],
              )
            ),
            Boton(onPresed:onPressed,texto:'Asignar',),
            dataBodyNo(id),
          ],
        ),
      ),
    );
  }

  Widget  dataBody(id) {
    return FutureBuilder <List<Rol>>(
      future:descargarRolesAsignados(id),
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
                rows: roles
                .map(
                  (obj) => DataRow(
                    selected: selectedRol.contains(obj),
                    onSelectChanged: (b) {
                      print("Onselect");
                      onSelectedRow(b, obj);
                    },
                    cells: [
                      DataCell(
                        Text(obj.nombre),
                        onTap: () {
                          print('Selected ${obj.nombre}');
                        },
                      ),
                      DataCell(
                        Text(obj.descripcion),
                      ),
                    ]
                  ),
                ).toList(),
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

   Widget  dataBodyNo(usuario) {
     return FutureBuilder <List<Rol>>(
      future:descargarRolesNoAsignados(usuario),
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
                  sortAscending: sortNo,
                  sortColumnIndex: 0,
                  columns: [
                    DataColumn(
                      label: Text("Objeto"),
                      numeric: false,
                      tooltip: "Objeto",
                      onSort: (columnIndexNo, ascending) {
                        setState(() {
                          sortNo = !sortNo;
                        });
                        onSortColumNo(columnIndexNo, ascending);
                      }
                    ),
                    DataColumn(
                      label: Text("Descripción"),
                      numeric: false,
                      tooltip: "Descripción",
                      onSort: (columnIndexNo, ascending) {
                        setState(() {
                          sortNo = !sortNo;
                        });
                        onSortColumNo(columnIndexNo, ascending);
                      }
                    ),
                  ],
                  rows: rolesNo
                  .map(
                    (objNo) => DataRow(
                      selected: selectedRolNo.contains(objNo),
                      onSelectChanged: (b) {
                        print("Onselect");
                        onSelectedRowNo(b, objNo);
                      },
                      cells: [
                        DataCell(
                          Text(objNo.nombre),
                          onTap: () {
                            print('Selected ${objNo.nombre}');
                          },
                        ),
                        DataCell(
                          Text(objNo.descripcion),
                        ),
                      ]
                    ),
                  ).toList(),
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