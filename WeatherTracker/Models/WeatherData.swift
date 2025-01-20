//
//  WeatherData.swift
//  WeatherTracker
//
//  Created by Sahithi Ammana on 1/19/25.
//

struct WeatherData: Codable, Identifiable {
    var id: Int? { location.id }
    var location: Location
    var current: CurrentWeather? = nil
    
    static let example = WeatherData(
        location: Location(
            id: 349134,
            name: "Hyderabad",
            url: "hyderabad-telangana-india"
        ),
        current: CurrentWeather(
            temp_c: 22.8,
            feelslike_c: 21.0,
            condition: Condition(
                text: "Sunny",
                icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
            ),
            humidity: 55,
            uv: 5.0
        )
    )
}

struct CurrentWeather: Codable {
    let temp_c: Double
    let feelslike_c: Double
    let condition: Condition
    let humidity: Int
    let uv: Double
}

struct Condition: Codable {
    let text: String
    let icon: String
}

struct Location: Codable, Identifiable {
    var id: Int? = nil
    var name: String
    var url: String? = nil
}
