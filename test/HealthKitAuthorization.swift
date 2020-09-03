//
//  HealthKitAuthorization.swift
//  test
//
//  Created by HsinJou Hung on 2020/9/2.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitAuthorization {

private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
}

class func authorizeHealthKit(completion: @escaping (Bool, Error?, Bool) -> Swift.Void) {
    //1. Check to see if HealthKit Is Available on this device
    guard HKHealthStore.isHealthDataAvailable( ) else {
        completion(false, HealthkitSetupError.notAvailableOnDevice, false)
        return
    }
    //2. Prepare the data types that will interact with HealthKit
    // Birth Date
    guard let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
        else {
            completion(false, HealthkitSetupError.dataTypeNotAvailable, false)
            return
    }
    //3. Prepare a list of types you want HealthKit to read
    let healthKitTypesToRead: Set<HKObjectType> = [sleepAnalysis,
                                                   HKObjectType.workoutType( )]
    //4. Request Authorization
    HKHealthStore( ).requestAuthorization(toShare: nil,
            read: healthKitTypesToRead) { (success, error) in
                   let sleepAnalysisAuthorizationStatus = HKHealthStore( ).authorizationStatus(for: sleepAnalysis)

                if (sleepAnalysisAuthorizationStatus == .sharingAuthorized) {
                        completion(success, error, true)
                } else {
                     completion(success, error, false)
                }
            }
               
    }
}
