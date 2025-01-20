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
    @Published var errorMessage: String?
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
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func searchLocations(for query: String) async {
        guard !query.isEmpty else { return }
        isSearching = true
        do {
            let locations = try await weatherService.fetchLocations(for: query)
            let weatherDetails = try await weatherService.fetchWeatherForLocations(locations: locations)
            searchResults = weatherDetails
        } catch {
            errorMessage = "Failed to fetch search results: \(error.localizedDescription)"
            searchResults = []
        }
        isSearching = false
    }
    
    func saveCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: userDefaultsKey)
        searchResults = []
    }
    
    func loadSavedCityWeather() {
        if let savedCity = UserDefaults.standard.string(forKey: userDefaultsKey) {
            Task {
                await fetchWeather(for: savedCity)
            }
        }
    }
}
