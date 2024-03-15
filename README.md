## Abouts

### Entity:

- The Entity class represents an object or data structure that encapsulates information
  and behavior related to a specific entity in a domain. It typically contains properties and
  methods to manage the state and behavior of the entity.

- Entities are commonly used to model real-world objects or concepts within an application,
  such as users, products, orders, etc. They provide a structured way to organize and manipulate
  data, enabling operations like creation, retrieval, update, and deletion (CRUD) within the
  application.

### Response:

- The Response class represents a response or result from an operation performed within
  an application. It encapsulates information about the outcome of the operation, including any data
  produced, status indicators, error messages, and other relevant metadata.

- Responses are used to communicate the outcome of operations, such as API requests,
  database queries, or internal function calls, within an application. They provide a standardized
  way to convey success, failure, or other states, allowing the application to handle and respond to
  different scenarios appropriately. Responses often include data payloads to convey results or
  errors back to the caller.

## Usage

### First, let's define a simple user entity:

```dart
import 'entity.dart';

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
```

### Now, let's define a method to create a user entity and return a response:

```dart
import 'response.dart';

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
```

### Next, let's define a method to retrieve a user entity by ID and return a response:

```dart
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
```

### Finally, let's create a main function to test our methods:

```dart
void main() {
  // Creating a new user
  Response<User> createUserResponse = createUser('Alice', 25);
  print(createUserResponse.message); // User created successfully
  print(createUserResponse.data); // User{id: 1634743202815, name: Alice, age: 25}

  // Fetching an existing user
  String userId = createUserResponse.data?.id ?? '';
  Response<User> getUserResponse = getUser(userId);
  print(getUserResponse.message); // User fetched successfully
  print(getUserResponse.data); // User{id: 1634743202815, name: John Doe, age: 30}
}
```
