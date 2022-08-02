
import 'package:controlmax/controlador/InsertarVenta.dart';
import 'package:controlmax/modelos/Ciudad.dart';
import 'package:controlmax/modelos/Departamento.dart';
import 'package:flutter/material.dart';

class MyApp1 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    _getStateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic DropDownList REST API'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(bottom: 100, top: 100),
            child: Text(
              'KDTechs',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            ),
          ),
          //======================================================== State

          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myState,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Select State'),
                        onChanged: (String newValue) {
                          setState(() {
                            _myState = newValue;
                            _getCitiesList();
                            print(_myState);
                          });
                        },
                        items: statesList?.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item.nombre),
                            value: item.nombre,
                          );
                        })?.toList() ??
                        [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),

          //======================================================== City

          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myCity,
                        iconSize: 30,
                        icon: (null),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Select City'),
                        onChanged: (String newValue) {
                          setState(() {
                            _myCity = newValue;
                            print(_myCity);
                          });
                        },
                        items: citiesList?.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item.nombre),
                                value: item.nombre,
                              );
                            })?.toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //=============================================================================== Api Calling here

//CALLING STATE API HERE
// Get State information by API
  List <Departamento> statesList;
  String _myState;


  var stateInfoUrl = Uri.parse('http://cleanions.bestweb.my/api/location/get_state');
  Future _getStateList() async {
    var insertar = Insertar();
    var lista =await insertar.consultarDeptos();
    //var data = json.decode(lista);
    setState(() {
      statesList = lista;
    });

//     await http.post(stateInfoUrl, headers: {
//       //"Content-Type": "application/x-www-form-urlencoded"
//       "content-type" : "application/json",
//     }, body: {
//       "api_key": '25d55ad283aa400af464c76d713c07ad',
//     }).then((response) {
//       var data = json.decode(response.body);

// //      print(data);
//       setState(() {
//         statesList = data['state'];
//       });
//     });
}

  // Get State information by API
  List <Ciudad>citiesList;
  String _myCity;

  var  cityInfoUrl =Uri.parse('http://cleanions.bestweb.my/api/location/get_city_by_state_id');
  Future _getCitiesList() async {

    //var insertar = Insertar();
    //var lista =await insertar.consultarCiudad();
    setState(() {
      //citiesList = lista;
    });
    // await http.post(cityInfoUrl, headers: {
    //   "content-type" : "application/json",
    // }, body: {
    //   "api_key": '25d55ad283aa400af464c76d713c07ad',
    //   "state_id": _myState,
    // }).then((response) {
    //   var data = json.decode(response.body);

    //   setState(() {
    //     citiesList = data['cities'];
    //   });
    // });
  }
}

// import 'package:controlmax/controlador/InsertarVenta.dart';
// import 'package:flutter/material.dart';

// class MyApp1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "Dropdowns",
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }

// // ================== coped from stakeoverflow

// class MultiSelectDialogItem<V> {
//   const MultiSelectDialogItem(this.value, this.label);

//   final V value;
//   final String label;
// }

// class MultiSelectDialog<V> extends StatefulWidget {
//   MultiSelectDialog({Key key, this.items, this.initialSelectedValues}) : super(key: key);

//   final List<MultiSelectDialogItem<V>> items;
//   final Set<V> initialSelectedValues;

//   @override
//   State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
// }

// class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
//   final _selectedValues = Set<V>();

//   void initState() {
//     super.initState();
//     if (widget.initialSelectedValues != null) {
//       _selectedValues.addAll(widget.initialSelectedValues);
//     }
//   }

//   void _onItemCheckedChange(V itemValue, bool checked) {
//     setState(() {
//       if (checked) {
//         _selectedValues.add(itemValue);
//       } else {
//         _selectedValues.remove(itemValue);
//       }
//     });
//   }

//   void _onCancelTap() {
//     Navigator.pop(context);
//   }

//   void _onSubmitTap() {
//     Navigator.pop(context, _selectedValues);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Select Country'),
//       contentPadding: EdgeInsets.only(top: 12.0),
//       content: SingleChildScrollView(
//         child: ListTileTheme(
//           contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
//           child: ListBody(
//             children: widget.items.map(_buildItem).toList(),
//           ),
//         ),
//       ),
//       actions: <Widget>[
//         FlatButton(
//           child: Text('CANCEL'),
//           onPressed: _onCancelTap,
//         ),
//         FlatButton(
//           child: Text('OK'),
//           onPressed: _onSubmitTap,
//         )
//       ],
//     );
//   }

//   Widget _buildItem(MultiSelectDialogItem<V> item) {
//     final checked = _selectedValues.contains(item.value);
//     return CheckboxListTile(
//       value: checked,
//       title: Text(item.label),
//       controlAffinity: ListTileControlAffinity.leading,
//       onChanged: (checked) => _onItemCheckedChange(item.value, checked),
//     );
//   }
// }

// // ===================


// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {

//   String value = "";
//   List<DropdownMenuItem<String>> menuitems = List();  
//   bool disabledropdown = true;
//   var web;

//   @override
//   void initState() {
//     _getStateList();
//     super.initState();
//   }
//   Future<String> _getStateList() async {
//     var insertar = Insertar();
//     var lista =await insertar.consultarCiudad();
//      web = lista;
//     // setState(() {
//     //   statesList = lista;
//     // });
//   }
//   // final web = {
//   //   "1" : "PHP",
//   //   "2" : "Python",
//   //   "3" : "Node JSs",
//   // };

//   final app = {
//     "1" : "Java",
//     "2" : "Flutter",
//     "3" : "React Native",
//   };


//   final desktop = {
//     "1" : "JavaFx",
//     "2" : "Tkinter",
//     "3" : "Electron",
//   };


//   void populateweb(){
//     for(String key in web.keys){
//       menuitems.add(DropdownMenuItem<String>(
//         child : Center(
//           child: Text(
//             web[key]
//           ),
//         ),
//         value: web[key],
//       ));
//     }
//   }

//   void populateapp(){
//     for(String key in app.keys){
//       menuitems.add(DropdownMenuItem<String>(
//         child : Center(
//           child: Text(
//             app[key]
//           ),
//         ),
//         value: app[key],
//       ));
//     }
//   }

//   void populatedesktop(){
//     for(String key in desktop.keys){
//       menuitems.add(DropdownMenuItem<String>(
//         child : Center(
//           child: Text(
//             desktop[key]
//           ),
//         ),
//         value: desktop[key],
//       ));
//     }
//   }

//   void selected(_value){
//     if(_value == "Web"){
//       menuitems = [];
//       populateweb();
//     }else if(_value == "App"){
//       menuitems = [];
//       populateapp();
//     }else if(_value == "Desktop"){
//       menuitems = [];
//       populatedesktop();
//     }
//     setState(() {
//       value = _value;
//       disabledropdown = false;
//     });
//   }

//   void secondselected(_value){
//     setState(() {
//       value = _value;
//     });
//   }

//   List <MultiSelectDialogItem<int>> multiItem = List();

//   final valuestopopulate = {
//     1 : "India",
//     2 : "Britain",
//     3 : "Russia",
//     4 : "Canada",
//   };

//   void populateMultiselect(){
//     for(int v in valuestopopulate.keys){
//       multiItem.add(MultiSelectDialogItem(v, valuestopopulate[v]));
//     }
//   }




//     void _showMultiSelect(BuildContext context) async {
//       multiItem = [];
//       populateMultiselect();
//       final items = multiItem;
//     // final items = <MultiSelectDialogItem<int>>[
//     //   MultiSelectDialogItem(1, 'India'),
//     //   MultiSelectDialogItem(2, 'USA'),
//     //   MultiSelectDialogItem(3, 'Canada'),
//     // ];

//     final selectedValues = await showDialog<Set<int>>(
//       context: context,
//       builder: (BuildContext context) {
//         return MultiSelectDialog(
//           items: items,
//           initialSelectedValues: [1,2].toSet(),
//         );
//       },
//     );

//     print(selectedValues);
//     getvaluefromkey(selectedValues);
//   }

//   void getvaluefromkey(Set selection){
//     if(selection != null){
//       for(int x in selection.toList()){
//         print(valuestopopulate[x]);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Dropdown",
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             DropdownButton<String>(
//               items: [
//                 DropdownMenuItem<String>(
//                   value: "App",
//                   child: Center(
//                     child: Text("App"),
//                   ),
//                 ),
//                 DropdownMenuItem<String>(
//                   value: "Web",
//                   child: Center(
//                     child: Text("Web"),
//                   ),
//                 ),
//                 DropdownMenuItem<String>(
//                   value: "Desktop",
//                   child: Center(
//                     child: Text("Desktop"),
//                   ),
//                 ),
//               ],
//               onChanged: (_value) => selected(_value),
//               hint: Text(
//                 "Select Your Field"
//               ),
//             ),
//             DropdownButton<String>(
//               items: menuitems,
//               onChanged: disabledropdown ? null : (_value) => secondselected(_value),
//               hint: Text(
//                 "Select Your Technology"
//               ),
//               disabledHint: Text(
//                 "First Select Your Field"
//               ),
//             ),
//             Text(
//               "$value",
//               style: TextStyle(
//                 fontSize: 20.0,
//               ),
//             ),
//             RaisedButton(
//               child: Text("Open Multiselect"),
//               onPressed: () => _showMultiSelect(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


