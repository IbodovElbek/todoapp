import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Services/todoapi_service.dart';
import '../Utils/Snacbar_helper.dart';
import 'add_page.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchToDo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchToDo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child: Text("No item ToDo",style: Theme.of(context).textTheme.headline3,),),
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id=item["_id"]as String;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text("${index + 1}"),
                    ),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(
                      onSelected:(value){
                        if(value=='edit'){
                        //Go to Edit Page
                          navigationToEditPage(item);
                        }
                        else if(value=='delete'){
                        //  Delete item
                          deletebyId(id);
                        }
                      } ,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(child: Text('Edit'),value: 'edit',),
                          PopupMenuItem(child: Text('Delete'),value: 'delete',),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigationToAddPage,
        label: Text("Add Todo"),
      ),
    );
  }

  Future<void> navigationToEditPage(Map item)async {

    final route = MaterialPageRoute(
      builder: (context) => AddToDoPage(todo:item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading=true;
    });
    fetchToDo();

  }

  Future<void> navigationToAddPage()async {

    final route = MaterialPageRoute(
      builder: (context) => AddToDoPage(),
    );
   await Navigator.push(context, route);
   setState(() {
     isLoading=true;
   });
    fetchToDo();

  }



  Future<void> deletebyId(String id)async{
  //  delete the item
  //  remove itne from list
    final issuccsess=await TodoService.deleteByid(id);
    if(issuccsess){
    //  Remove item
      final filtered=items.where((element) => element['_id']!=id).toList();
      setState(() {
        items=filtered;
      });
    }else{
      showErrorMessage(context,message:"Deleteing Failed");
    }
  }

  Future<void> fetchToDo() async {
   final response=await TodoService.FetchData(items);
    if (response!=null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context,message:"something went wrong");
    }
    setState(() {
      isLoading = false;
    });


  }



}
