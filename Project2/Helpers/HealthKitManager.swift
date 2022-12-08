//
//  HealthKitManager.swift
//  Project2
//
//  Created by Clayton Judge on 12/7/22.
//

import Foundation
import HealthKit

class HealthKitManager {
    private var healthStore = HKHealthStore()
    
    @Published var isAuthorized = false
    
    func setUpHealthRequest() {
        if HKHealthStore.isHealthDataAvailable(), let stepCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) {
            healthStore.requestAuthorization(toShare: [stepCount], read: [stepCount]) { success, error in
                if success {
                    self.isAuthorized = true
                    self.startObservation()
                    
                } else if let e = error{
                    // handle your error here
                    print(e.localizedDescription)
                }
            }
        }
    }
    
    func startObservation(){
        guard let stepQuantityType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        
        let observerQuery = HKObserverQuery(sampleType: stepQuantityType, predicate: nil){ (query, completionHandler, errorOrNil) in
            if let error = errorOrNil {
                // Properly handle the error.
                print(error.localizedDescription)
                return
            }
            
            
            if let user = AuthManager.shared.user{
                let startDay = Calendar.current.startOfDay(for: user.start_day.dateValue())
                
                self.readStepCount(startDay: startDay) { step in
                    print("in the closure \(step)")
                    if step != 0.0 {
                        DispatchQueue.main.async {
                            //calculate how much they have remaining
                            PCViewModel.shared.userStepCount = Int(step) - user.steps
                        }
                    }
                }
            }
        }
        
        healthStore.execute(observerQuery)
    }
    
    func readStepCount(startDay: Date, completion: @escaping (Double) -> Void) {
        guard let stepQuantityType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        let now = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDay, end: now, options: .strictStartDate)
        
        
        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let e = error{
                print(e.localizedDescription)
            }

            guard let result = result, let sum = result.sumQuantity() else {
                print("problem in step completion")
                completion(0.0)
                return
            }

            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        healthStore.execute(query)
    }
}
