//
//  WeatherService.swift
//  WeatherTracker
//
//  Created by Sahithi Ammana on 1/19/25.
//

import Foundation

class WeatherService {
    private let apiKey = ""
    private let baseURL = "https://api.weatherapi.com/v1/current.json"
    
    func fetchWeather(for city: String) async throws -> WeatherData {
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)&q=\(city)") else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw WeatherServiceError.invalidResponse
            }
            return try JSONDecoder().decode(WeatherData.self, from: data)
        } catch URLError.notConnectedToInternet {
            throw WeatherServiceError.noNetwork
        } catch is DecodingError {
            throw WeatherServiceError.decodingError
        } catch {
            throw WeatherServiceError.unknownError
        }
    }
    
    func fetchLocations(for query: String) async throws -> [Location] {
        guard let url = URL(string: "https://api.weatherapi.com/v1/search.json?key=\(apiKey)&q=\(query)") else {
            throw WeatherServiceError.invalidResponse
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw WeatherServiceError.invalidResponse
            }
            
            let locations = try JSONDecoder().decode([Location].self, from: data)
            if locations.isEmpty {
                throw WeatherServiceError.noResults
            }
            return locations
        } catch URLError.notConnectedToInternet {
            throw WeatherServiceError.noNetwork
        } catch is DecodingError {
            throw WeatherServiceError.decodingError
        } catch {
            throw WeatherServiceError.unknownError
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
            
            if results.isEmpty {
                throw WeatherServiceError.noResults
            }
            
            return results
        }
    }
}

enum WeatherServiceError: Error, LocalizedError {
    case noNetwork
    case invalidResponse
    case noResults
    case decodingError
    case unknownError
    
    var errorDescription: String {
        switch self {
        case .noNetwork:
            return "No internet connection. Please check your network and try again."
        case .invalidResponse:
            return "Invalid response from the server."
        case .noResults:
            return "No results found. Try searching for a city."
        case .decodingError:
            return "Failed to decode data."
        case .unknownError:
            return "An unknown error occurred. Please try again."
        }
    }
}
