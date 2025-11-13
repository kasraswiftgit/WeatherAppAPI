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
    
}
