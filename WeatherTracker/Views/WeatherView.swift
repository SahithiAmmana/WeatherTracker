//
//  WeatherView.swift
//  WeatherTracker
//
//  Created by Sahithi Ammana on 1/19/25.
//


import SwiftUI

struct WeatherView: View {
    var weather: WeatherData
    
    var body: some View {
        VStack(spacing: 16) {
            if let currentWeather = weather.current {
                AsyncImage(url: URL(string: "https:\(currentWeather.condition.icon)")) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150)
            }
            
            HStack {
                Text(weather.location.name)
                    .font(.custom("Poppins-Medium", size: 30))
                
                Image(systemName: "location.fill")
                    .resizable()
                    .foregroundStyle(.black)
                    .frame(width: 25, height: 25, alignment: .center)
            }
            
            if let currentWeather = weather.current {
                Text("\(currentWeather.temp_c, specifier: "%g")°")
                    .font(.custom("Poppins-Medium", size: 70))
                    .padding(.bottom, 10)
                
                HStack {
                    DetailsView(title: "Humidity", value: "\(currentWeather.humidity)%")
                    
                    
                    DetailsView(title: "UV", value: String(format: "%g°", currentWeather.uv))
                    
                    DetailsView(title: "Feels like", value: String(format: "%g°", currentWeather.feelslike_c))
                }
                .padding(.all, 10)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(width: 300)
            } else {
                Text("Weather data not available")
            }
        }
        .padding()
    }
    
    struct DetailsView: View {
        let title: String
        let value: String
        
        var body: some View {
            VStack(spacing: 8) {
                Text(title)
                    .foregroundColor(.customGray)
                    .font(.custom("Poppins-Regular", size: 12))
                
                Text(value)
                    .font(.custom("Poppins-Regular", size: 15))
                    .foregroundColor(.gray)
            }
            .padding(.all, 10)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    WeatherView(weather: WeatherData.example)
}
