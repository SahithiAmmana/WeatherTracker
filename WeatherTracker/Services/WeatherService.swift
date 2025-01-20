//
//  WeatherService.swift
//  WeatherTracker
//
//  Created by Sahithi Ammana on 1/19/25.
//

import Foundation

class WeatherService {
    private let apiKey = "8655e98ce22148a39c2212505251701"
    private let baseURL = "https://api.weatherapi.com/v1/current.json"
    
    func fetchWeather(for city: String) async throws -> WeatherData {
        let urlString = "\(baseURL)?key=\(apiKey)&q=\(city)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherData.self, from: data)
    }
    
    func fetchLocations(for query: String) async throws -> [Location] {
        let url = URL(string: "https://api.weatherapi.com/v1/search.json?key=\(apiKey)&q=\(query)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let locations = try JSONDecoder().decode([Location].self, from: data)
            return locations
        } catch {
            return []
        }
    }
    
    func fetchWeatherForLocations(locations: [Location]) async throws -> [WeatherData] {
        try await withThrowingTaskGroup(of: WeatherData?.self) { group in
            for location in locations {
                group.addTask {
                    guard let weather = try? await self.fetchWeather(for: location.url ?? location.name) else {
                        return nil
                    }

                    return WeatherData(
                        location: location,
                        current: weather.current
                    )
                }
            }
            var results: [WeatherData] = []
            for try await weatherData in group.compactMap({ $0 }) {
                results.append(weatherData)
            }
            return results
        }
    }
}
