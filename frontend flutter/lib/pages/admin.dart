import 'package:flutter/material.dart';
import 'package:projet/Utilities/colors.dart';
import 'package:projet/api/http_service.dart';
import 'package:projet/models/food.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Future<List<Food>> foodList;
  late TextEditingController searchController;
  int minPrice = 0;
  int maxPrice = 100;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    refreshFoodList();
  }

  Future<void> refreshFoodList() async {
    if (searchController.text.isEmpty) {
      setState(() {
        foodList = HttpService().getFoods();
      });
    } else {
      setState(() {
        foodList = HttpService().getFoodsByName(searchController.text);
      });
    }
  }

  Future<void> refreshFoodListByPriceRange() async {
    setState(() {
      foodList = HttpService().getFoodsByPriceRange(minPrice, maxPrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
        backgroundColor: primaryclr,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: backgroundclr,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      refreshFoodList();
                    },
                    decoration: InputDecoration(
                      labelText: 'Search by name',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: whiteclr,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: RangeSlider(
                          values: RangeValues(
                            minPrice.toDouble(),
                            maxPrice.toDouble(),
                          ),
                          min: 0.0,
                          max: 100.0,
                          onChanged: (values) {
                            setState(() {
                              minPrice = values.start.toInt();
                              maxPrice = values.end.toInt();
                            });
                          },
                          activeColor: whiteclr,
                          inactiveColor: primaryclr,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          refreshFoodListByPriceRange();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: primaryclr, // Set the background color to orange
                        ),
                        child: Text('Search by Price Range'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Min Price: $minPrice, Max Price: $maxPrice',
                    style: TextStyle(color: whiteclr),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Food>>(
                future: foodList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: primaryclr),
                      ),
                    );
                  } else {
                    List<Food> foods = snapshot.data ?? [];
                    return buildFoodListView(foods);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add_food').then((value) {
            if (value == true) {
              refreshFoodList();
            }
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: primaryclr,
      ),
    );
  }

  Widget buildFoodListView(List<Food> foods) {
    return ListView.builder(
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return ListTile(
          title: Text(food.name, style: TextStyle(color: whiteclr)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Price: ${food.price}", style: TextStyle(color: whiteclr)),
              Text(
                "Description: ${food.description}",
                style: TextStyle(color: whiteclr),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: whiteclr),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditFoodForm(
                        item: food,
                        refreshList: refreshFoodList,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: whiteclr),
                onPressed: () {
                  _showDeleteConfirmationDialog(food.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(int id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation", style: TextStyle(color: primaryclr)),
          content: const Text("Are you sure you want to delete this item?", style: TextStyle(color: whiteclr)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel", style: TextStyle(color: primaryclr)),
            ),
            TextButton(
              onPressed: () async {
                await HttpService().deleteFood(id);
                refreshFoodList();
                Navigator.of(context).pop();
              },
              child: const Text("Delete", style: TextStyle(color: primaryclr)),
            ),
          ],
        );
      },
    );
  }
}

class AddFoodForm extends StatefulWidget {
  final void Function() onFoodAdded;

  AddFoodForm({Key? key, required this.onFoodAdded}) : super(key: key);

  @override
  _AddFoodFormState createState() => _AddFoodFormState();
}

class _AddFoodFormState extends State<AddFoodForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Food"),
        backgroundColor: primaryclr,
      ),
      body: Container(
        color: backgroundclr,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white),),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.white),),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: imageController,
                  decoration: InputDecoration(labelText: 'Image URL',
                    labelStyle: TextStyle(color: Colors.white),),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price',
                    labelStyle: TextStyle(color: Colors.white),),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Food newFood = Food(
                        name: nameController.text,
                        description: descriptionController.text,
                        image: imageController.text,
                        price: int.parse(priceController.text),
                      );
                      await HttpService().addFood(newFood);
                      widget.onFoodAdded();
                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: primaryclr,
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(color: whiteclr), // Set the text color to white
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditFoodForm extends StatefulWidget {
  final Food item;
  final void Function() refreshList;

  EditFoodForm({Key? key, required this.item, required this.refreshList}) : super(key: key);

  @override
  _EditFoodFormState createState() => _EditFoodFormState();
}

class _EditFoodFormState extends State<EditFoodForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController imageController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.name);
    descriptionController = TextEditingController(text: widget.item.description);
    imageController = TextEditingController(text: widget.item.image);
    priceController = TextEditingController(text: widget.item.price.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Food"),
        backgroundColor: primaryclr,
      ),
      body: Container(
      color: backgroundclr,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white),),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image URL',
                  labelStyle: TextStyle(color: Colors.white),),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price',
                  labelStyle: TextStyle(color: Colors.white),),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.item != null) {
                      Food updatedFood = Food(
                        id: widget.item.id,
                        name: nameController.text,
                        description: descriptionController.text,
                        image: imageController.text,
                        price: int.parse(priceController.text),
                      );
                      await HttpService().editFood(updatedFood);
                      widget.refreshList();
                      Navigator.pop(context);
                    } else {
                      print('Error: widget.item is null');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: primaryclr,
                ),
                child: Text(
                  'Update',
                  style: TextStyle(color: whiteclr),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
