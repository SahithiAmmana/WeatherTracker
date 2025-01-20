//
//  LocationResultView.swift
//  WeatherTracker
//
//  Created by Sahithi Ammana on 1/19/25.
//

import SwiftUI

struct LocationResultView: View {
    @State var locationWeather: WeatherData
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(locationWeather.location.name)
                    .font(.custom("Poppins-Medium", size: 30))
                    .padding(.top, 8)
                
                if let currentWeather = locationWeather.current {
                    Text("\(currentWeather.temp_c, specifier: "%g")°")
                        .font(.custom("Poppins-Medium", size: 60))
                } else {
                    Text("Weather Data Unavailable")
                }
            }
            
            Spacer()
            
            if let currentWeather = locationWeather.current {
                AsyncImage(url: URL(string: "https:\(currentWeather.condition.icon)")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 80)
            }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 16)
        .foregroundStyle(.black)
    }
}
