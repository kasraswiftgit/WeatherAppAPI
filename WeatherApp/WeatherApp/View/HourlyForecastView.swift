import SwiftUI

struct HourlyForecastView: View {
    // Observes the ViewModel to access the hourlyItems array
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        // CRITICAL FIX: Only draw the forecast block if data is present.
        // This prevents the "dynamic member" crash that occurs when iterating over an empty array.
        if !viewModel.hourlyItems.isEmpty {
            VStack(alignment: .leading) {
                
                Text("HOURLY FORECAST")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                
                Divider()
                    .background(Color.white.opacity(0.5))
                
                // Horizontal Scrolling Container
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 25) {
                        // Loop through the processed hourly data (max 8 items)
                        ForEach(viewModel.hourlyItems) { item in
                            VStack(spacing: 8) {
                                // 1. Time (e.g., 1 PM)
                                Text(item.time)
                                    .font(.caption)
                                
                                // 2. Weather Icon (Mapped to SF Symbols)
                                Image(systemName: mapIconCodeToSFSymbol(iconCode: item.iconName))
                                    .font(.title3)
                                
                                // 3. Temperature
                                Text(item.temperature)
                                    .font(.headline)
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                }
            }
            .padding(.vertical, 5)
            .background(Color.white.opacity(0.15)) // Subtle background for the block
            .cornerRadius(10)
            .padding(.horizontal, 15)
        }
    }
    
    // Helper function to map OpenWeatherMap icon codes to native SF Symbols
    private func mapIconCodeToSFSymbol(iconCode: String) -> String {
        switch iconCode {
        case "01d", "01n": return "sun.max.fill"        // Clear Sky
        case "02d", "02n": return "cloud.sun.fill"      // Few Clouds
        case "03d", "03n": return "cloud.fill"          // Scattered Clouds
        case "04d", "04n": return "cloud.fill"          // Broken Clouds
        case "09d", "09n": return "cloud.rain.fill"     // Shower Rain
        case "10d", "10n": return "cloud.drizzle.fill"  // Rain
        case "11d", "11n": return "cloud.bolt.rain.fill"// Thunderstorm
        case "13d", "13n": return "snow"                // Snow
        case "50d", "50n": return "cloud.fog.fill"      // Mist
        default: return "questionmark.circle.fill"
        }
    }
}
