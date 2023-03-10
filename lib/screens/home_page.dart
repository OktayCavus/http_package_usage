import 'package:flutter/material.dart';
import 'package:http_pack_usage/model/pets_model.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Pets petsData2 ;
  String errorMessage = '';
  bool isDataLoaded = false;

  // ! CALL API
  Future <Pets> getData() async {
  var url = Uri.parse('https://jatinderji.github.io/users_pets_api/users_pets.json');
  var response = await http.get(url);
  if(response.statusCode == 200){
    Pets petsData = petsFromJson(response.body);
    setState(() {
      isDataLoaded = true;
    });
    return petsData;
  }else {
    errorMessage = '${response.statusCode} : ${response.body} ';
    return Pets(data: []);
  }
}

assingData () async {
  petsData2 = await getData();
}

@override
  void initState() {
    assingData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HTTP Pack Usage'),),
      body: isDataLoaded ?
          errorMessage.isNotEmpty ?
          Text(errorMessage) : petsData2.data.isEmpty ?
          const Text('No Data') : ListView.builder(
            itemCount: petsData2.data.length,
            itemBuilder: (context, index) => pageBuild(index)) :
          const Center(child: CircularProgressIndicator(),)
    );
  }

  Widget pageBuild(int index) {
    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(petsData2.data[index].petImage),),
            trailing: petsData2.data[index].isFriendly ? const Icon(Icons.pets , color: Colors.green,) : const Icon(Icons.do_not_touch, color: Colors.red,),
            title: Text(petsData2.data[index].userName),
            subtitle: Text(petsData2.data[index].petName),
          ),
        ),
      ],
    );
  }
}

