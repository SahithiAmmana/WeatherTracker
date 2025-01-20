//
//  WeatherViewModel.swift
//  WeatherTracker
//
//  Created by Sahithi Ammana on 1/19/25.
//

import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var savedCityWeather: WeatherData?
    @Published var searchQuery: String = ""
    @Published var isSearching: Bool = false
    @Published var errorMessage: String? = nil
    @Published var searchResults: [WeatherData] = []
    
    var weatherService: WeatherService
    private let userDefaultsKey = "SavedCity"
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
        loadSavedCityWeather()
    }
    
    func fetchWeather(for city: String) async {
        do {
            let weatherData = try await weatherService.fetchWeather(for: city)
            self.savedCityWeather = weatherData
            saveCity(city)
        } catch let error as WeatherServiceError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func searchLocations(for query: String) async {
        guard !query.isEmpty else { return }
        isSearching = true
        errorMessage = nil
        do {
            let locations = try await weatherService.fetchLocations(for: query)
            if locations.isEmpty {
                errorMessage = WeatherServiceError.noResults.errorDescription
            } else {
                searchResults = try await weatherService.fetchWeatherForLocations(locations: locations)
            }
        } catch let error as WeatherServiceError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = WeatherServiceError.unknownError.errorDescription
        }
        isSearching = false
    }
    
    func saveCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: userDefaultsKey)
        searchResults = []
    }
    
    func loadSavedCityWeather() {
        guard let savedCity = UserDefaults.standard.string(forKey: userDefaultsKey) else {
            self.errorMessage = "Failed to load weather for the saved city."
            return
        }
        Task {
            await fetchWeather(for: savedCity)
        }
    }
}
