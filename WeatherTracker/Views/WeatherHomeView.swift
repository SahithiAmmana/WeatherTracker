//
//  WeatherHomeView.swift
//  WeatherTracker
//
//  Created by Sahithi Ammana on 1/19/25.
//

import SwiftUI

struct WeatherHomeView: View {
    @StateObject private var viewModel = WeatherViewModel(weatherService: WeatherService())
    @State private var searchText: String = ""
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                Spacer().frame(height: 20)
                SearchView(searchText: $searchText, isSearchFieldFocused: $isSearchFieldFocused) { query in
                    Task {
                        await viewModel.searchLocations(for: query)
                    }
                }
                                
                if viewModel.isSearching {
                    searchingView
                } else if !viewModel.searchResults.isEmpty {
                    searchResultsView
                } else if !searchText.isEmpty {
                    noResultsView
                } else {
                    savedCityView
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            viewModel.loadSavedCityWeather()
        }
    }
    
    private var savedCityView: some View {
        Group {
            if let savedCityWeather = viewModel.savedCityWeather {
                WeatherView(weather: savedCityWeather)
            } else {
                VStack {
                    Spacer()
                    Text("No City Selected")
                        .font(.custom("Poppins-Medium", size: 30))
                    Text("Please Search For A City")
                        .font(.custom("Poppins-Medium", size: 15))
                        .padding(.top, 2)
                    Spacer()
                }
            }
        }
    }
    
    private var searchResultsView: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(viewModel.searchResults, id: \.location.url) { weather in
                    Button(action: {
                        viewModel.saveCity(weather.location.name)
                        searchText = ""
                        isSearchFieldFocused = false
                        viewModel.loadSavedCityWeather()
                    }) {
                        LocationResultView(locationWeather: weather)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
    }
    
    private var noResultsView: some View {
        VStack {
            Text("No results found. Try searching for a city.")
                .font(.custom("Poppins-Regular", size: 20))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
    }
    
    private var searchingView: some View {
        VStack {
            ProgressView("Searching...")
            Spacer()
        }
    }
}

struct SearchView: View {
    @Binding var searchText: String
    @FocusState.Binding var isSearchFieldFocused: Bool
    let onSearch: (String) -> Void
    
    var body: some View {
        HStack {
            TextField(
                "Search Location",
                text: $searchText,
                onEditingChanged: { isEditing in
                    if !isEditing {
                        onSearch(searchText)
                    }
                })
            .padding(.all, 13)
            .focused($isSearchFieldFocused)
            .autocorrectionDisabled()
            .font(.custom("Poppins-Regular", size: 15))
            
            Button(action: {
                onSearch(searchText)
                isSearchFieldFocused = false
            }) {
                Image(systemName: "magnifyingglass")
                    .padding(.all, 15)
                    .foregroundStyle(.gray)
            }
            
        }
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
    }
}

#Preview {
    WeatherHomeView()
}
