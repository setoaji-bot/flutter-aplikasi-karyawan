import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Employee.dart';

class Services{
  static const ROOT ='http://localhost/app_karyawan/koneksi.php';
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_EMP_ACTION = 'ADD_EMP';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const _DELETE_EMP_ACTION = 'DELETE_EMP';

  static Future<String> createTable() async{
    try{
      //menambah parameter dilewatkan ke request.
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(ROOT, body: map);
      print('Create Table Response: ${response.body}');
      
      if(200 == response.statusCode){
        return response.body;
      }else{
        return "error";
      }

    }catch (e){
      return "error";
    }
  }

 static Future<List<Employee>> getEmployees() async{
   try{
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getEmployees Response: ${response.body}');
      if(200 == response.statusCode){
        List<Employee> list = parseResponse(response.body);
        return list;
      }else{
        return List<Employee>();
      }
   }catch(e){
     return List<Employee>(); // return an empty list on error
   }
 } 

 static List<Employee> parseResponse(String responseBody){
   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
   return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
 }

  //Method untuk menampah employee ke database..
 static Future<String> addEmployee(String name, String email) async{
    try{
      var map = Map<String, dynamic>();
      map['action'] = _ADD_EMP_ACTION;
      map['name'] = name;
      map['email'] = email;
      final response = await http.post(ROOT, body: map);
      print('AddEmployee Response: ${response.body}');
      if(200 == response.statusCode){
        return response.body;
      }else{
        return "error";
      }
   }catch(e){
     return "error"; // return an empty list on error
   }
 }

 //Method untuk update employee dalam Database
 static Future<String> updateEmployee(String empId, String name, String email) async{
    try{
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_EMP_ACTION;
      map['emp_id'] = empId;
      map['name'] = name;
      map['email'] = email;
      final response = await http.post(ROOT, body: map);
      print('UpdateEmployee Response: ${response.body}');
      if(200 == response.statusCode){
        return response.body;
      }else{
        return "error";
      }
   }catch(e){
     return "error"; // return an empty list on error
   }
 }

//Method untuk Delete employee dalam Database
 static Future<String> deleteEmployee(String empId) async {
    try{
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_EMP_ACTION;
      map['emp_id'] = empId;
      final response = await http.post(ROOT, body: map);
      print('DeleteEmployee Response: ${response.body}');
      if(200 == response.statusCode){
        return response.body;
        
      }else{
        return "error";
      }
   }catch(e){
     return "error"; // return just an "error" string  to keep this simple.
   }
 }


}