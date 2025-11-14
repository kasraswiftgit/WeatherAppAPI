import SwiftUI

struct DailySummaryView: View {
    // Observes the ViewModel to access the dailySummary data
    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
        // Since viewModel.dailySummary is a struct with non-optional String properties,
        // we can safely access its members directly here.
        HStack {
            // Placeholder/Label
            Text("TODAY'S FORECAST")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            // Daily Low Temperature (L: 14°)
            Text("L: \(viewModel.dailySummary.minTemp)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
            
            // Daily High Temperature (H: 22°)
            Text("H: \(viewModel.dailySummary.maxTemp)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
        }
        // Styling to match the Apple Weather app's subtle bar
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal, 15)
    }
}
