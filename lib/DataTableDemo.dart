import 'package:flutter/material.dart';
import 'Employee.dart';
import 'Services.dart';

class DataTableDemo extends StatefulWidget{
  DataTableDemo() : super();
  final String title = 'Flutter Data Table Employee';
  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo>{
  List<Employee> _employees;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _nameController; //controller untuk field nama 
  TextEditingController _emailController; //controller untuk field email
  Employee _selectedEmployee;
  bool _isUpdating;
  String _titleProgress;

  @override
  void initState(){
    super.initState();
    _employees = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); //key untuk mendapatkan konteks untuk ditampilkan di bar
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _getEmployees();
  }

//Method untuk update title dalam appbar title
_showProgress(String message){
    setState((){
      _titleProgress = message;
    });
}

_showSnackBar(context, message){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        ),
      );
}
  

  _createTable(){
    _showProgress('Create Table ...');
    Services.createTable().then((result){
      if('success' == result){

        //sukses membuat table
        _showSnackBar(context, result);
        _showProgress(widget.title);
      }
    });
  } 

  //
  _addEmployee(){
    if(_nameController.text.isEmpty || _emailController.text.isEmpty){
       print('Empty Fields');
       return;
    }
    _showProgress('Menambahkan karyawan');
    Services.addEmployee(_nameController.text, _emailController.text)
    .then((result){
        if('success' == result){
          _getEmployees(); //refresh list setelah menambahkan tiap employeee
          _clearValues();
        }
        
    });
  }


  _getEmployees(){
    _showProgress('Loading Employees ...');
    Services.getEmployees().then((employees){
      setState((){
        _employees = employees;
      });
      _showProgress(widget.title);//Reset the title...
      print("Length ${employees.length}");
    });
  }

  _updateEmployee(Employee employee){
setState((){
  _isUpdating = true;
});

    _showProgress('Update Employe ...');
    Services.updateEmployee(employee.id, _nameController.text, _emailController.text)
    .then((result){
      if('success' == result){
        _getEmployees();//refrest setelah update
        setState((){
        _isUpdating = false;

      });
      _clearValues();
      }
    });
  }

  _deleteEmployee(Employee employee){
    _showProgress('Deleting Employee...');
    Services.deleteEmployee(employee.id).then((result){
      if ('success' == result){
        _getEmployees();//refresh setelah delete ..
      }

    });
  }

  //Method to Clear TextField Value
  _clearValues(){
    _nameController.text = '';
    _emailController.text = '';
  }
_showValues(Employee employee){
  _nameController.text = employee.name;
  _emailController.text = employee.email;
}
  //Datagrid
  SingleChildScrollView _dataBody(){
    //Keduanya vertical dan horizontal scrollview untuk datagrid
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('Name'),
            ),
            DataColumn(
              label: Text('Email'),
            ),

            //Delete Button
            DataColumn(label:Text('DELETE'),
            )
          ],
          rows: _employees
          .map((employee) => DataRow(
            cells: [
              DataCell(
                Text(employee.id),
                //textfields with corespongding value to update
                onTap: (){
                  _showValues(employee);
                  //set selected employee untuk update
                  _selectedEmployee = employee;
                  setState((){
                    _isUpdating = true;
                  });
                  
                },
              ),
              DataCell(
                Text(employee.name.toUpperCase(),
                ),
                onTap: (){
                  _showValues(employee);
                  //set selected employee untuk update
                  _selectedEmployee = employee;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(employee.email.toUpperCase(),
                ),
                onTap: (){
                  _showValues(employee);
                  //set selected employee untuk update
                  _selectedEmployee = employee;
                  setState((){
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(IconButton(
                icon: Icon(Icons.delete),
              onPressed: (){
                _deleteEmployee(employee);
              },
              ))
            ]),
            )
            .toList(),
        ),
      ),
    );
  }

  //UI
  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), //menampilkan progress dalam title
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              _createTable();
            },
          ),

          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              _getEmployees();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Nama Lengkap',
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Email',
                ),
              ),
            ),

            //Menampah Tombol Update dan Cancel
            _isUpdating 
            ? Row(
              children: <Widget>[
                OutlinedButton(
                  child: Text('UPDATE'),
                  onPressed: () {
                    _updateEmployee(_selectedEmployee);
                  },
                ),

                OutlinedButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    setState((){
                      _isUpdating = false;
                    });
                    _clearValues();
                  },
                ),
              ],
            ) 
            : Container(),
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _addEmployee();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}