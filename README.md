# WeatherSwiftUIApp

A SwiftUI-based weather app that allows users to check current weather conditions by entering a city name. The app integrates with the OpenWeather API to fetch live weather data, displays search results, and persists the selected city using `UserDefaults`.

## Features

- **City Search**: 
  - The app fetches weather data by entering the name of a city.
  - Users can tap on the **search bar**, enter the city name, and then either:
    - Press the **search icon** on the keyboard, or
    - Use the **return key** to initiate the search for weather data.
  - If the city is not found, the app will inform the user with a message.
  
- **Weather Display**:
  - Displays current weather information for a selected city, including:
    - Temperature (Celsius/Fahrenheit)
    - Weather description (e.g., clear sky, rain)
    - Wind speed
    - Humidity levels
  
- **Search Result Card**: 
  - A card is shown with the search result, displaying the basic weather details for the city.
  
- **Card Interaction for More Details**:
  - After the search result card is displayed, users can **tap on the card** to see more detailed weather information, such as:
    - Hourly forecast
    - Extended weather descriptions (e.g., rain probability, visibility)
    - Detailed wind and humidity information

- **Local Storage (UserDefaults)**:
  - The app stores the selected city in **UserDefaults**, so users can persist their chosen city even after closing the app or restarting it.
  
- **Network Error Handling**:
  - The app checks if the entered city is valid and if the network is available before fetching weather data.
  
- **Dependency Injection**:
  - The app uses **dependency injection** to manage its dependencies, making the code more modular and testable.

## Installation

Follow these steps to get the project running on your local machine:

### 1. Clone the repository

Clone the repository to your local machine using the following command:

```bash
git clone https://github.com/shmiftari/WeatherSwiftUIApp.git
