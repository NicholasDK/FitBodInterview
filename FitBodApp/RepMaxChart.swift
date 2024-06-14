//
//  RepMaxChart.swift
//  FitBodApp
//
//  Created by Nicholas Della Valle on 6/13/24.
//

import Charts
import SwiftUI

struct RepMaxChart: View {
    
    @ObservedObject var viewModel: ChartViewModel
    let weightPadding = 20

    init(viewModel: ChartViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack {
                FitBodExerciseRMView(set: viewModel.maxPR)
                    .padding(.bottom, 12)
               
                HStack {
                    Text("Range")
                        .font(.system(size: 14))
                    dateRangeComponentSelectorView(dateDisplay: viewModel.minDateDisplay, date: $viewModel.minDate)
                    Text("to")
                        .font(.system(size: 14))
                    dateRangeComponentSelectorView(dateDisplay: viewModel.maxDateDisplay, date: $viewModel.maxDate)
                }
                Chart(viewModel.displayData, content: {
                    LineMark(x: .value("Time", $0.date, unit: .day), y: .value("Max", $0.theoreticalMax))
                    PointMark(x: .value("Time", $0.date, unit: .day), y: .value("Max", $0.theoreticalMax))
                })
                .chartXAxis {
                    AxisMarks(preset: .aligned, values: .stride(by: .day, count: viewModel.strideCount)) { value in
                        AxisValueLabel(format: .dateTime.month().day())
                        AxisGridLine()
                        AxisTick()
                    }
                }
                .chartYScale(domain: [viewModel.lowest - weightPadding, viewModel.maxPR.theoreticalMax + weightPadding])
                .frame(height: 400)
                .padding(.horizontal, 8)
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    private func dateRangeComponentSelectorView(dateDisplay: String, date: Binding<Date>) -> some View {
        HStack {
            Text(dateDisplay)
                .font(.system(size: 14))
                .foregroundStyle(Color.blue)
            Image(systemName: "calendar")
                .font(.title3)
                .foregroundStyle(Color.blue)
        }
        .overlay{
            DatePicker(
                "",
                selection: date,
                displayedComponents: [.date]
            )
            .blendMode(.destinationOver)
        }
    }
}
