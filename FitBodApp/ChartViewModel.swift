//
//  ChartViewModel.swift
//  FitBodApp
//
//  Created by Nicholas Della Valle on 6/13/24.
//

import Foundation

class ChartViewModel: ObservableObject {
    
    var data: [WorkoutSet] = []
    @Published var displayData: [WorkoutSet] = []
    let exercise: String
    let maxPR: WorkoutSet
    @Published var lowest: Int
    @Published var strideCount: Int = 60
    @Published var minDate = Date() {
        didSet {
            updateDateRange()
        }
    }
    @Published var maxDate = Date() {
        didSet {
            updateDateRange()
        }
    }
    
    let dateFormatter = DateFormatter()
    
    init(data: [WorkoutSet], exercise: String, max: WorkoutSet) {
        self.data = data
        self.exercise = exercise
        self.maxPR = max
        
        self.displayData = data
        
        lowest = data.sorted(using: KeyPathComparator(\.theoreticalMax)).first?.theoreticalMax ?? 0
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        if let firstEntry = data.first?.date {
            minDate = firstEntry
        }
        
        if let lastEntry = data.last?.date {
            maxDate = lastEntry
        }
    }

    func updateDateRange() {
        
        let preferredTickPoints: Double = 6.0
        
        //Filter data by requested range
        self.displayData = data.filter({ $0.date <= self.maxDate && $0.date >= self.minDate})
        
        //Take the actual min and max data points in that range to display as many tick points on graph as possible
        let first = self.displayData.first?.date ?? self.minDate
        let last = self.displayData.last?.date ?? self.maxDate
        
        //stride count is used to indicate distance between tick points on x axis
        if let numberOfDays = Calendar.current.dateComponents([.day], from: first, to: last).day {
            let count = Double(numberOfDays) / preferredTickPoints
            strideCount =  Int(count.rounded(.up))
        }
        
        //Used in View so we don't have too much empty vertical space on bottom of graph
        lowest = displayData.sorted(using: KeyPathComparator(\.theoreticalMax)).first?.theoreticalMax ?? 0
        print()
    }
    
    var minDateDisplay: String {
        return dateFormatter.string(from: self.minDate)
    }
    
    var maxDateDisplay: String {
        return dateFormatter.string(from: self.maxDate)
    }
    
    
}
