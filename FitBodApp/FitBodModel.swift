//
//  FitBodModel.swift
//  FitBodApp
//
//  Created by Nicholas Della Valle on 6/13/24.
//

import Foundation

enum FitBodErrorParseError: Error {
    case invalidDateError
    case invalidRepsType
    case invalidWeightType
    case badInputFile
}

struct WorkoutSet: Codable, Identifiable {
    
    let id = UUID()
    var date: Date
    var exercise: String
    var reps: Int
    var weight: Double
    var theoreticalMax: Int
    
    private static let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "MMM d yyyy"
            return df
        }()
    
    init(date: Date, exericse: String, reps: Int, weight: Double) {
        self.exercise = exericse
        self.date = date
        self.reps = reps
        self.weight = weight
        self.theoreticalMax = WorkoutSet.calculateMax(weight: weight, reps: reps)
    }
    
    static func calculateMax(weight: Double, reps: Int) -> Int {
        return Int(weight / (1.0278 - (0.0278*Double(reps))))
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        exercise = try container.decode(String.self, forKey: .exercise)
        
        let stringDate = try container.decode(String.self, forKey: .date)
                
        if let decodedDate = WorkoutSet.dateFormatter.date(from: stringDate) {
            date = decodedDate
        } else {
            throw FitBodErrorParseError.invalidDateError
        }
        
        //Reps and weight should be numbers
        
        if let repsInt = Int(try container.decode(String.self, forKey: .reps)) {
            reps = repsInt
        } else {
            throw FitBodErrorParseError.invalidRepsType
        }
        
        if let weightDouble = Double(try container.decode(String.self, forKey: .weight)) {
            weight = weightDouble
        } else {
            throw FitBodErrorParseError.invalidWeightType
        }
        
        theoreticalMax = WorkoutSet.calculateMax(weight: weight, reps: reps)
    
    }
    
}
