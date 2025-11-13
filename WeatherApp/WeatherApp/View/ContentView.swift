//
//  ContentView.swift
//  WeatherApp
//
//  Created by Kasra Hosseininejad on 10/11/25.
//

import SwiftUI

struct ContentView: View {
    // Instantiate the ViewModel using @StateObject
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
            // ZStack for background and foreground content
            ZStack {
                // Optional: Background color/gradient
                LinearGradient(gradient: Gradient(colors: [.blue, .cyan]),
                               startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Conditional rendering based on ViewModel state
                    if viewModel.isLoading {
                        ProgressView("Fetching Weather...")
                            .tint(.white)
                    } else if let error = viewModel.errorMessage {
                        Text(viewModel.cityName) // Displays "Error"
                            .font(.largeTitle)
                        Text(error)
                            .foregroundColor(.red)
                    } else {
                        // Display the successful weather data
                        WeatherDisplay(viewModel: viewModel)
                    }
                }
                .foregroundColor(.white) // Sets default text color for clarity
            }
        .task {
            let naplesLat = 40.8518
            let naplesLong = 14.2681
            
            viewModel.loadWeather(latitude: naplesLat, longitude: naplesLong)
            
            
        }
        
    }
        
}

#Preview {
    ContentView()
}
