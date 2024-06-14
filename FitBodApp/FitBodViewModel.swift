//
//  FitBodViewModel.swift
//  FitBodApp
//
//  Created by Nicholas Della Valle on 6/13/24.
//

import Foundation
import SwiftCSV

class FitBodViewModel: ObservableObject {
    
    var setsGroupedByName: [String:[WorkoutSet]] = [:]
    @Published var repMaxes: [WorkoutSet] = []
    @Published var error: Error?
    
    @MainActor
    func readWorkoutData(filePath: String) {
        
        //asynchrounously process the file of workout data in case data set is large
        Task {
            processFileAtPath(filePath)
        }

    }
    
    func processFileAtPath(_ filepath: String) {
        do {
            let workoutValues = try String(contentsOfFile: filepath)
            
            //Add header row to allow parsing easily into Model
            let header = "date,exercise,reps,weight\n"
            let results = try CSV<Named>(string: header + workoutValues)
            
            let json = try JSONSerialization.data(withJSONObject: results.rows)
            let decoder = JSONDecoder()
            let decodedSets = try decoder.decode([WorkoutSet].self, from: json)
            
            //creates a mapping of exerise name to all the sets for that exercise which is saved in a property
            //to be used in further calculations
            setsGroupedByName = Dictionary(grouping: decodedSets, by: {$0.exercise})
            
            //store rep maxes as the published data for the primary view of the app
            repMaxes = calculate1RMs()
            
        } catch {
            self.error = error
        }
    }
    
    
    private func calculate1RMs() -> [WorkoutSet] {
        
        var output1RMs: [WorkoutSet] = []
        
        for exercise in setsGroupedByName.keys {
            
            //Sort the Sets by theoretical max, greatest first and take that first set as the max for that exercise
            if let maxSet = setsGroupedByName[exercise]?.sorted(using: KeyPathComparator(\.theoreticalMax, order: .reverse)).first {
                output1RMs.append(maxSet)
            }
        }
        
        //return an array of Max sets (one for each exercise)
        return output1RMs
    }
    
    func chartViewModelForExercise(max: WorkoutSet) -> ChartViewModel {
        return ChartViewModel(data: self.maxSetsSortedByDate(exerciseName: max.exercise, sets: self.setsGroupedByName), exercise: max.exercise, max: max)
    }
    

    private func maxSetsSortedByDate(exerciseName: String, sets: [String:[WorkoutSet]]) -> [WorkoutSet] {
        
        //pull sets from the Exercise->[Sets] Mapping
        guard let setsForExercise = sets[exerciseName] else { return [] }
        
        //Group sets by date
        let groupedbyDate = Dictionary(grouping: setsForExercise, by: { $0.date })
        
        var maxesByDate: [WorkoutSet] = []
        
        //For each date, take the greatest theoretical max on that day
        //This data will be used for charting and in order to see useful clean chart, we don't care about any other sets on that day except the one
        //that resulted in greatest max
        for date in groupedbyDate.keys {
            if let maxOnDay = groupedbyDate[date]?.sorted(using: KeyPathComparator(\.theoreticalMax, order: .reverse)).first {
                maxesByDate.append(maxOnDay)
            }
        }
        
        //return the 1RM for each date sorted in ascending date order
        return maxesByDate.sorted(using: KeyPathComparator(\.date))
    }
    

    
}
