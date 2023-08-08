import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

List<Map<String, dynamic>> _items = [];

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Map<String, dynamic>> _items = [];

  String selectedType = "Expense";
  String selectedCategory = "Food";
  String description = "";
  double amount = 0;
  double totalBalance = 0;

  final _shoppingBox = Hive.box('shopping_box');

  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    final data = _shoppingBox.keys.map((key) {
      final item = _shoppingBox.get(key);
      return {
        "key": key,
        "selectedType": item["selectedType"],
        "Category": item["Category"],
        "subtitle": item["subtitle"],
        "amount": item["amount"],
      };
    }).toList();
    setState(() {
      _items = data.reversed.toList();
      if (selectedType == "Expense") {
        totalBalance = totalBalance - amount;
      } else {
        totalBalance = totalBalance + amount;
      }
       description = "";
      amount = 0.0;
    });
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _shoppingBox.add(newItem);
    _refreshItems();

  }

    Future<void> _updateItem( int itemKey , Map<String, dynamic> item) async {
    await _shoppingBox.put(itemKey ,item);
    _refreshItems();
     ScaffoldMessenger.of(context).showSnackBar ( 
      const SnackBar (content: Text("An item has been updated")));

  }

    Future<void> _deleteItem(int itemKey ) async {
    await _shoppingBox.delete(itemKey);
    _refreshItems();

    ScaffoldMessenger.of(context).showSnackBar (
      const SnackBar (content: Text("An item has been deleted")));

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Welcome...."),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(right: 10, left: 10, bottom: 20, top: 80),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Your Balance",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total Balance:- ",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.currency_rupee,
                    color: Colors.grey,
                  ),
                  Text(
                    "$totalBalance",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30))),
                      child: ElevatedButton(
                          onPressed: () {
                             _showfrom(context, null);
                          }, child: Text("New Record")),
                    ),
                  )),
              SizedBox(
                height: 35,
              ),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: Row(
                  children: [
                    const SizedBox(
                      height: 40,
                      width: 30,
                      // padding: EdgeInsets.all(20),
                      child: Icon(Icons.arrow_circle_up_sharp,
                          color: Colors.green),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 12),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Income",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Text(
                          //   "2002",
                          //   style: TextStyle(
                          //     color: Color.fromARGB(255, 255, 255, 255),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 40,
                          width: 30,
                          // padding: EdgeInsets.all(20),
                          child: Icon(Icons.arrow_circle_down_rounded,
                              color: Colors.red),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 12),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Expense",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Text(
                              //   "199.5",
                              //   style: TextStyle(
                              //     color: Color.fromARGB(255, 255, 255, 255),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _items.length,
                itemBuilder: (_, index) {
                  final currentItem = _items[index];

                  Color textColor;
                  if (currentItem["selectedType"] == "Expense") {
                    textColor = Colors.red;
                  } else {
                    textColor = Colors.green;
                  }
                  return  
                    Column(
                      children: [
                        ListTile(
                                onTap: () {},
                                leading: Icon(
                                  currentItem["selectedType"] == "Expense"
                                      ? Icons.arrow_circle_down_rounded
                                      : Icons.arrow_circle_up_rounded,
                                  color: textColor,
                                ),
                                hoverColor: const Color.fromARGB(255, 44, 44, 44),
                                title: Text(
                                  currentItem["Category"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  currentItem["subtitle"],
                                  style: TextStyle(color: Color.fromARGB(255, 170, 168, 168)),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      currentItem["selectedType"] == "Expense"
                                          ? "-${currentItem["amount"]}"
                                          : "+${currentItem["amount"]}",
                                      style: TextStyle(
                                        color: currentItem["selectedType"] == "Expense"
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                    SizedBox(width: 4,),
                                                                IconButton(onPressed: (){
                                                                  _showfrom(context, currentItem["key"]);
                                              
                                                                }, icon: Icon(Icons.edit, color: Colors.grey,)),
                                              
                                    IconButton(onPressed: (){
                                      _deleteItem( currentItem["key"]);
                                    }, icon: Icon(Icons.delete_forever ,  color: Colors.grey,))
                                  ],
                           
                                ),
                                  
                              ),
                              Divider(
                          color: Colors.grey,
                        ),
                      ],
                    );
                    
                      
                    
                  
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          _showfrom(context, null);
          // Navigator.push(context, MaterialPageRoute(builder: (context)=> ExpenseTracker()));
          //  print(_items.length);
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _showfrom(BuildContext ctx, int? itemKey) async {

    if(itemKey != null){
      final existingItem = 
      _items.firstWhere((element) => element['key']== itemKey);
      selectedType=existingItem['selectedType'];
      selectedCategory=existingItem['Category'];
            description=existingItem['subtitle'];
      amount=existingItem['amount'];


    }
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: <String>['Expense', 'Income']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue!;
                    });
                  },
                  style: TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey)),
                    labelText: "Description",
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),

                SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: <String>[
                    'Other',
                    'Bills',
                    'Clothes',
                    'Eating Out',
                    'Education',
                    'Entertainment',
                    'Food',
                    'Fruits',
                    'Fuel',
                    'General',
                    'Gifts',
                    'Holidays',
                    'Home',
                    'Job',
                    'Kids',
                    'Misc',
                    'Music',
                    'Pets',
                    'Shopping',
                    'Sports',
                    'Tickets',
                    'Transportation',
                    'Travel',
                    'Wages',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  style: TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey)),
                    labelText: "Description",
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 16),

                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                  style: TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey)),
                    labelText: "Description",
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),

                SizedBox(height: 16),

                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      amount = double.tryParse(value) ?? 0.0;
                    });
                  },
                  style: TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey)),
                    labelText: "Amount",
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),

                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                   
                if(itemKey != null){
     _updateItem(itemKey, {
        "selectedType": selectedType,
                      "Category": selectedCategory,
                      "subtitle": description,
                      "amount": amount,
                      "totalBalance": totalBalance
     })    .whenComplete(() => Navigator.pop(context));


    }else{
       _createItem({
                      "selectedType": selectedType,
                      "Category": selectedCategory,
                      "subtitle": description,
                      "amount": amount,
                      "totalBalance": totalBalance
                    })    .whenComplete(() => Navigator.pop(context));
    }

               

                  },
                  child: Text("Add Transaction"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}