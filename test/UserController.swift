//
//  UserController.swift
//  test
//
//  Created by HsinJou Hung on 2020/9/13.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import HealthKit

class UserController {
    
    var inBedTime: Bool?
    var asleepTime: Bool?
    var sleepStart: Date?
    var sleepEnd: Date?
    
    class func getMostRecentSample(for sampleType: HKSampleType,
                                   completion: @escaping ([HKSample]?, Error?) -> Swift.Void) {
        var myAnchor = HKQueryAnchor.init(fromValue: 0)
        let anchorQuery = HKAnchoredObjectQuery(type: sampleType,
                                                predicate: nil,
                                                anchor: myAnchor,
                                                limit: HKObjectQueryNoLimit) { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
                                                    
                                                    DispatchQueue.main.async {
                                                        print(sampleType)
                                                        myAnchor = newAnchor!
                                                        
                                                        guard let samples = samplesOrNil,
                                                            let _ = samples.last as? HKQuantitySample else {
                                                                print("Nil for", sampleType)
                                                                completion(nil, errorOrNil)
                                                                return
                                                        }
                                                        print("Not nil for", sampleType)
                                                        completion(samples, nil)
                                                    }
        }
        anchorQuery.updateHandler = { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            
            DispatchQueue.main.async {
                
                myAnchor = newAnchor!
                
                guard let samples = samplesOrNil,
                    let _ = samples.last as? HKQuantitySample else {
                        print("Nil for", sampleType)
                        completion(nil, errorOrNil)
                        return
                }
                completion(samples, nil)
            }
            
            
            
        }
        HKHealthStore().enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion:  { (success: Bool, error: Error?) in
            debugPrint("enableBackgroundDeliveryForType handler called for \(sampleType) - success: \(success), error: \(error)")
            HKHealthStore().execute(anchorQuery)
        })
        
        
    }
    class func getCategoryTypeData(for sampleType: HKCategoryType, completion: @escaping ([HKSample]?, Error?) -> Swift.Void){
        var myAnchor = HKQueryAnchor.init(fromValue: 0)
        let anchorQuery = HKAnchoredObjectQuery(type: sampleType,
                                                predicate: nil,
                                                anchor: myAnchor,
                                                limit: HKObjectQueryNoLimit) { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
                                                    
                                                    DispatchQueue.main.async {
                                                        
                                                        print(sampleType)
                                                        myAnchor = newAnchor!
                                                        
                                                        guard let result = samplesOrNil else {
                                                            print("Nil for", sampleType)
                                                            completion(nil, errorOrNil)
                                                            return
                                                        }
                                                        print("Not nil for", sampleType)
                                                        completion(result, nil)
                                                    }
        }
        anchorQuery.updateHandler = { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            
            DispatchQueue.main.async {
                
                print(sampleType)
                myAnchor = newAnchor!
                
                guard let result = samplesOrNil else {
                    print("Nil for", sampleType)
                    completion(nil, errorOrNil)
                    return
                }
                print("Not nil for", sampleType)
                completion(result, nil)
            }
            
            
            
        }
        HKHealthStore().enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion:  { (success: Bool, error: Error?) in
            debugPrint("enableBackgroundDeliveryForType handler called for \(sampleType) - success: \(success), error: \(error)")
            HKHealthStore().execute(anchorQuery)
        })
    }
}

