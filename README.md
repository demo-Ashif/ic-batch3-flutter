# Flutter Stateful Apps - Learning Project

This project demonstrates three simple Flutter apps that use `setState()` for state management. Perfect for beginners learning Flutter state management concepts.

## Apps Included

1. **📝 To-Do App** - Add, remove, and mark tasks as complete
2. **🔢 Counter App** - Increment and decrement a number
3. **🧮 Calculator App** - Perform basic mathematical operations

## Understanding setState()

`setState()` is the simplest way to update the UI in Flutter when data changes. Here's how it works:

### What is setState()?

`setState()` is a method that tells Flutter "something in my widget's state has changed, please rebuild the UI to reflect these changes."

### How setState() Works

```dart
setState(() {
  // Code that changes your variables goes here
  myVariable = newValue;
});
```

### Code Before vs Inside setState()

**Code BEFORE setState():**
- This code runs first
- Usually includes validation, calculations, or data preparation
- Does NOT trigger UI updates

**Code INSIDE setState():**
- This code changes the actual state variables
- Flutter automatically rebuilds the UI after this
- Only put the code that changes your data here

### Example from Counter App:

```dart
void _increment() {
  // Code before setState() - validation, logging, etc.
  print('User pressed increment button');
  
  setState(() {
    // Code inside setState() - changes the actual data
    _count++;
  });
  
  // Code after setState() - UI has been updated
  print('Count is now: $_count');
}
```

### Key Points:

1. **Only put data changes inside setState()** - UI logic, validation, and other operations can go outside
2. **setState() triggers a rebuild** - Flutter automatically calls the `build()` method again
3. **Keep setState() calls minimal** - Don't put unnecessary code inside setState()
4. **setState() is synchronous** - The UI updates immediately after setState() completes

### When to Use setState():

- ✅ Simple state management
- ✅ Learning Flutter basics
- ✅ Small to medium apps
- ✅ When you need immediate UI updates

### When NOT to Use setState():

- ❌ Complex state management (use Provider, Bloc, etc.)
- ❌ Large applications
- ❌ When you need advanced state management features

## Getting Started

1. Clone this repository
2. Run `flutter pub get`
3. Run `flutter run`
4. Navigate through the apps to learn setState() concepts

## Project Structure

```
lib/
├── main.dart              # App entry point
├── home_screen.dart       # Navigation screen
├── todo_app.dart          # To-Do app with setState()
├── counter_app.dart       # Counter app with setState()
└── calculator_app.dart    # Calculator app with setState()
```
