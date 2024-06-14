//
//  FitBod1RMView.swift
//  FitBodApp
//
//  Created by Nicholas Della Valle on 6/13/24.
//

import SwiftUI

protocol FitBodRMViewDelegate: AnyObject {
    func didSelectExercise(exerciseRMViewModel: ChartViewModel)}

struct FitBod1RMListView: View {
    
    weak var delegate: FitBodRMViewDelegate?
    
    fileprivate init() {}
    
    init(delegate: FitBodRMViewDelegate) {
        self.delegate = delegate
    }
    
    @ObservedObject var viewModel = FitBodViewModel()
    
    var body: some View {
        List(viewModel.repMaxes) { max in
            FitBodExerciseRMView(set: max)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .contentShape(Rectangle())
                .padding(.vertical, 12)
                .onTapGesture {
                    delegate?.didSelectExercise(exerciseRMViewModel: viewModel.chartViewModelForExercise(max: max))
                }
        }
        .scrollContentBackground(.hidden)
        .onAppear {
            guard let filepath = Bundle.main.path(forResource: "workoutData", ofType: "txt") else {
                return
            }
            viewModel.readWorkoutData(filePath: filepath)
        }
    }
    
    
}

#Preview {
    FitBod1RMListView()
}
