import SwiftUI

// This struct focuses only on how the data looks.
struct WeatherDisplay: View {
    // Receives the existing ViewModel instance and observes its changes
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            // City Name
            Text(viewModel.cityName)
                .font(.largeTitle)
                
            // Temperature (Replicating the large, thin Apple style)
            Text(viewModel.currentTemp)
                .font(.system(size: 80, weight: .thin))
                .padding(.bottom, 15)
            
            // Description
            Text(viewModel.weatherDescription)
                .font(.title2)
                .padding(.bottom, 5)
        }
    }
}
