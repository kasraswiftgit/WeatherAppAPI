//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Kasra Hosseininejad on 10/11/25.
//

import Foundation

class WeatherManager {
    
    private let apiKey = "303707732fd81d36c795622c0a3d4b16"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let baseForecastURL = "https://api.openweathermap.org/data/2.5/forecast" // NEW ENDPOINT!
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        
        let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&lang=en&units=metric"
        
        guard let url = URL(string: urlString) else {
            
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            // If the server returns 404, 500, or any other error code, throw a response error.
            throw URLError(.badServerResponse)  
            
            
        }
        
        do {
            let decoder = JSONDecoder()
            
            // The compiler needs to know you're decoding to WeatherResponse.self
            let decodedResponse = try decoder.decode(WeatherResponse.self, from: data)
            
            // You MUST explicitly return the result here
            return decodedResponse
        } catch {
            // If decoding fails, the function throws the error, satisfying the
            // "throws -> WeatherResponse" requirement.
            throw error
        }
        
    }
    
    func fetchFiveDayForecast(latitude: Double, longitude: Double) async throws -> FiveDayForecastResponse {
            
            // 1. Construct the URL for the /forecast endpoint
            let urlString = "\(baseForecastURL)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
            
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            // 2. Perform the Network Request
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // 3. Check the HTTP Response Status
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            // 4. Decode the Data into the new Model structure
            do {
                let decoder = JSONDecoder()
                // CRITICAL: Decode into the new root struct
                let decodedResponse = try decoder.decode(FiveDayForecastResponse.self, from: data)
                
                return decodedResponse
            } catch {
                print("FiveDayForecast decoding error: \(error)")
                throw error
            }
        }
            
        
    
}
