import 'package:flutter/material.dart';
import 'package:flutter_entity/flutter_entity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Entity',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Response<User> getUser(String userId) {
    final response = Response<User>();
    try {
      // Simulate fetching user data from a database or external API
      User user = User(id: userId, name: 'John Doe', age: 30);

      // Simulate a successful response with the fetched user entity
      return response.withData(user, message: 'User fetched successfully');
    } catch (e) {
      // If an error occurs during user retrieval, return an error response
      return response.withException('Failed to fetch user');
    }
  }

  Response<User> createUser(String name, int age) {
    final response = Response<User>();
    try {
      // Simulate creating a user entity with an auto-generated ID and timestamp
      User user = User(name: name, age: age);

      // Simulate a successful response with the created user entity
      return response.withData(user, message: 'User created successfully');
    } catch (e) {
      // If an error occurs during user creation, return an error response
      return response.withException('Failed to create user');
    }
  }

  @override
  void initState() {
    super.initState();
    // Creating a new user
    Response<User> createUserResponse = createUser('Alice', 25);
    print(createUserResponse.message); // User created successfully
    print(createUserResponse
        .data); // User{id: 1634743202815, name: Alice, age: 25}

    // Fetching an existing user
    String userId = createUserResponse.data?.id ?? '';
    Response<User> getUserResponse = getUser(userId);
    print(getUserResponse.message); // User fetched successfully
    print(getUserResponse
        .data); // User{id: 1634743202815, name: John Doe, age: 30}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: Text(getUser("userId").beautify),
        ),
      ),
    );
  }
}

class User extends Entity<EntityKey> {
  String? name;
  int? age;

  User({
    String? id,
    int? timeMills,
    this.name,
    this.age,
  }) : super(id: id, timeMills: timeMills);

  @override
  String toString() {
    return 'User{id: $id, name: $name, age: $age, timeMills: $timeMills}';
  }
}
