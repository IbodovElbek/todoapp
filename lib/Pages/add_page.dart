import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Services/todoapi_service.dart';
import '../Utils/Snacbar_helper.dart';

class AddToDoPage extends StatefulWidget {
  final Map? todo;
  AddToDoPage({super.key, this.todo});
  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}
class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  bool isEdit=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo=widget.todo;
    if(todo !=null){
      isEdit=true;
      final title=todo['title'];
      final description=todo['description'];
      titlecontroller.text=title;
      descriptioncontroller.text=description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit?  "Edit Page":"Add Todo"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            TextField(
              controller: titlecontroller,
              decoration: InputDecoration(hintText: "Title"),
            ),
            TextField(
              controller: descriptioncontroller,
              decoration: InputDecoration(
                hintText: "Description",
              ),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed:isEdit? UpdateDate: SubmitData,
              child: Text(
                 isEdit?"Update": "Sumit"),
            )
          ],
        ),
      ),
    );
  }
  Future<void>UpdateDate()async{
    final todo=widget.todo;
    if(todo==null){
      print("You can not updated without todo data");
      return;
    }
    //Get the Data from form
    final id=todo['_id'];
    final title = titlecontroller.text;
    final description = descriptioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

  final IsSuccess=await TodoService.UpdateDate(body, id);

    if(IsSuccess){
      showSuccessMessage(context, message: "Updating Succsess");
    }
    else{
      showErrorMessage(context,message:"Updating failed");
    }
  }
  Future<void> SubmitData() async {
    //Get the Data from form
    final title = titlecontroller.text;
    final description = descriptioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
 //  Submit data to the server

    final issuccess = await TodoService.CreateDate(body);
    if(issuccess){
      titlecontroller.text='';
      descriptioncontroller.text='';
      showSuccessMessage(context, message: "Ceated Succsess");
    }
    else{
      showErrorMessage(context,message:"Created failed");
    }
  }



}
