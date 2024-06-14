//
//  FitBodExerciseRMView.swift
//  FitBodApp
//
//  Created by Nicholas Della Valle on 6/13/24.
//

import SwiftUI

struct FitBodExerciseRMView: View {
    
    let set: WorkoutSet
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(set.exercise)
                    .font(.system(size: 24, weight: .bold))
                Text("One Rep Max \u{2022} lbs")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.gray.opacity(0.7))
            }
            Spacer()
            Text("\(Int(set.theoreticalMax))")
                .font(.title)
        }
    }
}

#Preview {
    FitBodExerciseRMView(set: WorkoutSet(date: Date(), exericse: "Jump Squat", reps: 30, weight: 0.0))
}
