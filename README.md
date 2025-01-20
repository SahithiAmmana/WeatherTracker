# WeatherTracker

## Overview
WeatherTracker is an iOS application that allows users to search for a city, view its current weather details, and save their preferred city. The app demonstrates clean architecture using Swift and SwiftUI, integrating weather data from WeatherAPI.com.

## Features

### Home Screen
- Displays weather information for a saved city, including:
  - City name.
  - Temperature.
  - Weather condition with an icon.
  - Humidity (%).
  - UV index.
  - "Feels like" temperature.
- If no city is saved, prompts the user to search for a city.

### Search Functionality
- Includes a search bar to query cities.
- Displays search results in a list.
- Selecting a city updates the home screen with the city's weather and saves the selection.

### Local Storage
- Uses `UserDefaults` to persist the selected city.
- Reloads the saved city's weather data on app launch.

## Tech Stack
- **Language**: Swift
- **Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **API Integration**: WeatherAPI.com
- **Local Storage**: UserDefaults

## API Integration
Weather data is fetched using WeatherAPI.com.
For more information about the API, refer to [WeatherAPI Documentation](https://www.weatherapi.com/docs/).

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/SahithiAmmana/WeatherTracker.git
   cd WeatherTracker
   ```

2. **Open the Project**:
   - Open `WeatherTracker.xcodeproj` in Xcode.

3. **API Key Setup**:
   - Obtain a free API key from [WeatherAPI.com](https://www.weatherapi.com/).
   - Add the API key to the project:
     1. Open `WeatherService.swift`.
     2. Replace `apiKey` with your WeatherAPI key.

4. **Build and Run**:
   - Select a simulator or a connected device.
   - Press `Cmd + R` to build and run the app.

## Architecture
The WeatherTracker app follows the MVVM (Model-View-ViewModel) architecture to ensure clean separation of concerns and testable code. Here's how the architecture is implemented:

- **Model**:
  - Represents the data layer of the app, including data structures like `WeatherData`, `Location`, and `CurrentWeather`.
  - Handles decoding data from the WeatherAPI responses and encapsulates the weather-related information.

- **View**:
  - Composed of SwiftUI views such as `WeatherHomeView`, `SearchView`, and `WeatherView`.
  - Responsible for rendering the UI based on the state provided by the ViewModel.
  - Utilizes SwiftUI bindings to reactively update the UI when the state changes.

- **ViewModel**:
  - Acts as a mediator between the Model and the View.
  - Contains business logic and manages the app's state, such as `WeatherViewModel`.
  - Handles tasks like fetching data from the API, storing and retrieving user preferences, and formatting data for display.
  - Uses dependency injection to enable testing and maintain modularity.

This architecture ensures a clear separation of concerns, making the app more maintainable, scalable, and testable.

## Error Handling
- Displays user-friendly messages for network errors or invalid city searches.
- Handles edge cases like empty search queries and API rate limits.
