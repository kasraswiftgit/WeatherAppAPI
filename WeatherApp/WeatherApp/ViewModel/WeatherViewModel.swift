//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Kasra Hosseininejad on 10/11/25.
//

import Foundation
import Combine

// 1. @MainActor and ObservableObject setup
// @MainActor ensures all UI-related updates are safe (on the main thread).
// ObservableObject allows SwiftUI views to subscribe to its changes.

@MainActor
class WeatherViewModel: ObservableObject {
    
    // Instantiate your manager to handle the networking logic
    private let manager = WeatherManager()
    
    // 2. State Properties (@Published)
    // These properties automatically notify the SwiftUI View when their values change.
    @Published var cityName: String = "Loading..."
    @Published var currentTemp: String = "__"
    @Published var weatherDescription: String = "..."
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // 3. Implement the Fetching Logic (Task)
    func loadWeather(latitude: Double, longitude: Double) {
        
        // Reset state and activate loading indicator
        self.isLoading = true
        self.errorMessage = nil
        
        // Use Task to perform asynchronous network work off the main thread
        
        Task {
                    do {
                        // Await the result from the WeatherManager
                        let response = try await manager.fetchWeather(latitude: latitude, longitude: longitude)
                        
                        // On SUCCESS: Update Published properties with formatted data
                        // The @MainActor ensures these updates are safe for the UI.
                        self.cityName = response.name
                        
                        // Format the temperature (Double) into a clean, rounded string
                        self.currentTemp = "\(Int(response.main.temp.rounded()))°C"
                        
                        // Get the first weather condition description and capitalize it
                        self.weatherDescription = response.weather.first?.description.capitalized ?? "N/A"
                        
                    } catch {
                        // On FAILURE: Update error state
                        print("Weather Fetch Error: \(error)")
                        self.errorMessage = "Failed to load weather: \(error.localizedDescription)"
                        self.cityName = "Error"
                    }
                    
                    // Stop loading indicator (runs whether success or failure)
                    self.isLoading = false
                }
            }
        }
