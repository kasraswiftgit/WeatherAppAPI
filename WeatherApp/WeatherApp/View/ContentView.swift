//
//  ContentView.swift
//  WeatherApp
//
//  Created by Kasra Hosseininejad on 10/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        // Full screen background
        LinearGradient(gradient: Gradient(colors: [.blue, .cyan]),
                       startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all)
        .overlay(
            // Vertical scrolling container
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView("Loading Weather...")
                            .tint(.white)
                            .padding(.top, 150)
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)").foregroundColor(.red)
                    } else {
                        // 1. Current Conditions (Main Large Text)
                        WeatherDisplay(viewModel: viewModel)
                            .padding(.top, 50)
                        
                        // 2. Hourly Forecast Block
                        HourlyForecastView(viewModel: viewModel)
                        
                        // 3. Daily Min/Max Summary Bar
                        DailySummaryView(viewModel: viewModel)
                        
                        // NOTE: You can add other detailed blocks here (e.g., wind, humidity)
                    }
                }
            }
        )
        // CRITICAL: Call the new function to load all data
        .task {
            // Use your target location (Naples coordinates example)
            viewModel.loadAllWeather(latitude: 40.8518, longitude: 14.2681)
        }
        .foregroundColor(.white)
    }
}

// NOTE: Ensure your existing WeatherDisplay struct is still available and functioning.

#Preview {
    ContentView()
}
