//
//  FitBodNavController.swift
//  FitBodApp
//
//  Created by Nicholas Della Valle on 6/13/24.
//

import Foundation
import SwiftUI
import UIKit

class FitBodNavController: UINavigationController {}

extension FitBodNavController: FitBodRMViewDelegate {
    
    func didSelectExercise(exerciseRMViewModel: ChartViewModel) {
        let chartHostingViewController = UIHostingController(rootView: RepMaxChart(viewModel: exerciseRMViewModel))
        self.pushViewController(chartHostingViewController, animated: true)
    }

}
