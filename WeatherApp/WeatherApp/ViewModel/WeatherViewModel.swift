import Foundation
import Combine
import MapKit // Required if using map types

// MARK: - UI Helper Models (Structs are correct)

// UI Helper: Used for the horizontal scrolling forecast
struct HourlyForecastItem: Identifiable {
    let id = UUID()
    let time: String        // e.g., "1 PM"
    let temperature: String // e.g., "18°"
    let iconName: String    // e.g., "cloud.sun.fill" (SFSymbol name)
}

// UI Helper: Used for the single min/max display bar
struct DailySummary {
    var minTemp: String = "--"
    var maxTemp: String = "--"
}

// --- WeatherViewModel Class ---

@MainActor
class WeatherViewModel: ObservableObject {
    
    // Dependencies
    private let manager = WeatherManager()
    
    // MARK: - Published State Properties (Non-optional defaults are CRITICAL)
    
    // Current Weather State
    @Published var cityName: String = "Loading Location"
    @Published var currentTemp: String = "--°"
    @Published var weatherDescription: String = "Fetching data"

    // Forecast State
    @Published var hourlyItems: [HourlyForecastItem] = []
    @Published var dailySummary = DailySummary()
    
    // UI State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Core Loading Function
    
    // Renamed for consistency with the ContentView call
    func loadAllWeather(latitude: Double, longitude: Double) {
        // Reset state and activate loading indicator
        self.isLoading = true
        self.errorMessage = nil
        self.hourlyItems = []
        self.dailySummary = DailySummary()
        
        Task {
            do {
                // 1. Await Current Conditions
                let currentResponse = try await manager.fetchWeather(latitude: latitude, longitude: longitude)
                
                // Update current weather UI elements
                self.cityName = currentResponse.name
                self.currentTemp = "\(Int(currentResponse.main.temp.rounded()))°C"
                self.weatherDescription = currentResponse.weather.first?.description.capitalized ?? "N/A"
                
                // 2. Await 5-Day Forecast
                let forecastResponse = try await manager.fetchFiveDayForecast(latitude: latitude, longitude: longitude)
                
                // 3. Process the forecast data
                self.processForecast(list: forecastResponse.list)
                
            } catch {
                // Handle error for either call
                print("Weather loading error: \(error)")
                self.errorMessage = "Failed to load all weather data."
                self.cityName = "Error"
            }
            
            self.isLoading = false
        }
    }
    
    // MARK: - Processing Helpers
    
    private func processForecast(list: [ForecastListItem]) {
        
        // 1. Hourly Forecast (Get the next 8 intervals)
        let nextEightHours = Array(list.prefix(8))
        
        self.hourlyItems = nextEightHours.map { item in
            HourlyForecastItem(
                time: self.timeString(from: item.dt),
                temperature: "\(Int(item.main.temp.rounded()))°",
                iconName: item.weather.first?.icon ?? "cloud"
            )
        }
        
        // 2. Daily Min/Max (Find the true min/max for the current day)
        
        let today = Calendar.current.startOfDay(for: Date())
        let currentDayForecast = list.filter { item in
            Date(timeIntervalSince1970: item.dt) >= today
        }
        
        let overallMin = currentDayForecast.min(by: { $0.main.tempMin < $1.main.tempMin })?.main.tempMin ?? 0
        let overallMax = currentDayForecast.max(by: { $0.main.tempMax < $1.main.tempMax })?.main.tempMax ?? 0
        
        self.dailySummary.minTemp = "\(Int(overallMin.rounded()))°"
        self.dailySummary.maxTemp = "\(Int(overallMax.rounded()))°"
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "ha"
        return formatter.string(from: date)
    }
}
