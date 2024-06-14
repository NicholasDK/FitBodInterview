//
//  FitBodAppTests.swift
//  FitBodAppTests
//
//  Created by Nicholas Della Valle on 6/13/24.
//

import XCTest
@testable import FitBodApp

final class FitBodAppTests: XCTestCase {

    let fitbodViewModel = FitBodViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor func testEmpty() throws {
        guard let filepath = Bundle.main.path(forResource: "workoutEmpty", ofType: "txt") else {
            XCTAssert(false, "file Not found")
            return
        }
        
        fitbodViewModel.readWorkoutData(filePath: filepath)
        XCTAssert(fitbodViewModel.repMaxes.isEmpty, "Expected no data")
        XCTAssert(fitbodViewModel.setsGroupedByName.isEmpty, "Expected no data")
        
    }
      
      func testInvalid() throws {
        guard let filepath = Bundle.main.path(forResource: "workoutDataInvalid", ofType: "txt") else {
            XCTAssert(false, "file Not found")
            return
        }
        
        fitbodViewModel.processFileAtPath(filepath)
   
        XCTAssert(fitbodViewModel.repMaxes.isEmpty, "Expected no data")
        XCTAssert(fitbodViewModel.setsGroupedByName.isEmpty, "Expected no data")
        XCTAssert(fitbodViewModel.error != nil, "Expected error")
        
    }

    func testValid() throws {
        guard let filepath = Bundle.main.path(forResource: "workoutDataShort", ofType: "txt") else {
            XCTAssert(false, "file Not found")
            return
        }
        
        fitbodViewModel.processFileAtPath(filepath)
        
        XCTAssert(fitbodViewModel.error == nil, "Expected no error")
        
        let rms = fitbodViewModel.repMaxes
        
        XCTAssert(rms.count == 4, "Expected 4 RM sets")
        let maxCurl = rms.filter { $0.exercise ==  "Barbell Curl"}.first?.theoreticalMax
        XCTAssert(maxCurl == 100, "Expected 100 1RM")
        
        //Int(weight / (1.0278 - (0.0278*Double(reps))))
        //6,45
        if let maxDeadlift = rms.filter ({ $0.exercise ==  "Deadlift"}).first {
            XCTAssert(maxDeadlift.theoreticalMax == 52, "Expected 52 1RM")
            let chartVM = fitbodViewModel.chartViewModelForExercise(max: maxDeadlift)
            XCTAssert(chartVM.data.count == 2, "Expected 2 Deadlift sets")
            XCTAssert(chartVM.lowest == 45, "Expected  low of 45")
        } else {
            XCTAssert(false, "Expected Deadlift max")
        }
        
        
    }
    
    

}
