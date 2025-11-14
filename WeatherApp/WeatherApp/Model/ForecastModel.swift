//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Kasra Hosseininejad on 14/11/25.
//

import Foundation

// MARK: - 1. Weather Condition (Reused in Current and Forecast API)
// This structure holds the description and icon code (e.g., "04d")
struct WeatherCondition: Decodable {
    let id: Int             // Condition ID
    let main: String        // e.g., "Clouds"
    let description: String // e.g., "scattered clouds"
    let icon: String        // Icon code for fetching the image/SFSymbol
}

// MARK: - 2. Main Forecast Data (3-Hour Block Temperature Info)
// Nested structure for the temperature details within a single forecast list item
struct MainForecast: Decodable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    
    // CodingKeys required for snake_case JSON keys
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - 3. Forecast List Item (One 3-Hour Slot)
// Represents a single entry in the /forecast array
struct ForecastListItem: Decodable {
    let dt: TimeInterval    // Unix timestamp
    let main: MainForecast  // Nested temperature data
    let weather: [WeatherCondition] // Nested condition array
}

// MARK: - 4. Root Forecast Response
// The top-level structure for the /forecast API response
struct FiveDayForecastResponse: Decodable {
    let list: [ForecastListItem] // The main array of all 3-hour forecasts
    let city: CityInfo           // City metadata
}

// Nested structure for basic city information
struct CityInfo: Decodable {
    let name: String
    let country: String
}
