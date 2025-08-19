# Countries of the World - Flutter App

A beautiful and responsive Flutter application that displays a comprehensive list of countries with search functionality, pull-to-refresh, and modern UI design.

## Features

✅ **Country List Page** - Displays all countries with beautiful cards  
✅ **Searchable Countries** - Search by country name, capital, or description  
✅ **Pull to Refresh** - Swipe down to refresh the country list  
✅ **Responsive UI** - Works seamlessly on different screen sizes  
✅ **State Management** - Uses Flutter BLoC pattern with Equatable  
✅ **API Integration** - Fetches data from external API  
✅ **Clean Architecture** - Well-organized, maintainable code structure  
✅ **Error Handling** - Proper loading, success, and error states  
✅ **Modern Design** - Material Design 3 with beautiful animations  

## API

The app fetches country data from: [https://countrylist.teamrabbil.com/api/country-list](https://countrylist.teamrabbil.com/api/country-list)

Each country includes:
- Country name
- Capital city
- Short description
- Flag image URL

## Project Structure

```
lib/
├── models/
│   └── country.dart              # Country data model with Equatable
├── repositories/
│   └── country_repository.dart   # API data layer
├── blocs/
│   ├── country_bloc.dart         # Business logic controller
│   ├── country_event.dart        # BLoC events
│   └── country_state.dart        # BLoC states
├── screens/
│   └── country_list_screen.dart  # Main screen with BLoC provider
├── widgets/
│   ├── searchable_country_list.dart  # Searchable list widget
│   └── country_list_item.dart        # Individual country card
└── main.dart                     # App entry point
```

## Dependencies

- **flutter_bloc**: ^8.1.6 - State management
- **equatable**: ^2.0.5 - Value equality
- **http**: ^1.1.0 - API integration

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## State Management

The app uses the BLoC (Business Logic Component) pattern:

- **Events**: `FetchCountries`, `RefreshCountries`
- **States**: `CountryInitial`, `CountryLoading`, `CountrySuccess`, `CountryError`
- **Repository Pattern**: Clean separation of data layer

## UI Features

- **Search Bar**: Real-time filtering of countries
- **Country Cards**: Beautiful cards with flag, name, capital, and description
- **Pull to Refresh**: Swipe down gesture to refresh data
- **Error Handling**: User-friendly error messages with retry options
- **Loading States**: Smooth loading indicators
- **Responsive Design**: Adapts to different screen sizes

## Architecture Benefits

- **Maintainable**: Clear separation of concerns
- **Testable**: Easy to unit test individual components
- **Scalable**: Easy to add new features
- **Clean Code**: Well-organized and readable code structure
- **Performance**: Efficient state management and UI updates

## Screenshots

The app features a modern, clean interface with:
- Blue-themed app bar with refresh button
- Search bar with shadow effects
- Country cards with flag images
- Smooth animations and transitions
- Responsive layout for all screen sizes

## Future Enhancements

- Country detail page
- Favorites functionality
- Offline support
- Dark theme
- Localization support
- Advanced filtering options
