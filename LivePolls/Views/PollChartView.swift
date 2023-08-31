//
//  PollChartView.swift
//  LivePolls
//
//  Created by Abanoub Ashraf on 31/08/2023.
//

import SwiftUI
import Charts

struct PollChartView: View {
    let options: [Option]
    
    var body: some View {
        Chart {
            ForEach(options) { option in
                SectorMark(
                    ///
                    /// this one only makes it pie shape
                    ///
                    angle: .value("Count", option.count),
                    ///
                    /// adding this makes it dounut shape
                    ///
                    innerRadius: .ratio(0.618),
                    ///
                    /// inset between the parts of the chart
                    ///
                    angularInset: 1.5
                )
                .cornerRadius(8)
                .foregroundStyle(by: .value("Name", option.name))
            }
        }
    }
}

#Preview {
    PollChartView(options: [
        .init(count: 2, name: "PS5"),
        .init(count: 1, name: "Xbox SX"),
        .init(count: 2, name: "Switch"),
        .init(count: 1, name: "PC")
    ])
}
