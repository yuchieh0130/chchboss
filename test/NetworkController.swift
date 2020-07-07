//
//  File.swift
//  test
//
//  Created by 謝宛軒 on 2020/7/6.
//  Copyright © 2020 AppleInc. All rights reserved.
//
import Foundation
import UIKit

class NetworkController {
// API URL
    let baseURL = URL(string: "http://140.119.19.18:5000/")!
    func postLocationData (data: [String: String], completion: @escaping(Int?) -> Void) {
        let locationURL = baseURL.appendingPathComponent("insertLocation")
        var request = URLRequest(url: locationURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
           "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
                if let data = data,
                    let jsonDictionary = try?
                    JSONSerialization.jsonObject(with: data) as?
                    [String: Int],
                    let status_code = jsonDictionary["status_code"] {
                            completion(status_code)
                    } else {
                        completion(nil)
                    }
        }
        task.resume( )
    }
    func postSaveplaceData (data: [String: String], completion: @escaping(Int?) -> Void) {
            let saveplaceURL = baseURL.appendingPathComponent("insertSaveplace")
            var request = URLRequest(url: saveplaceURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField:
               "Content-Type")
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(data)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request)
            { (data, response, error) in
                    if let data = data,
                        let jsonDictionary = try?
                        JSONSerialization.jsonObject(with: data) as?
                        [String: Int],
                        let status_code = jsonDictionary["status_code"] {
                                completion(status_code)
                        } else {
                            completion(nil)
                        }
            }
            task.resume( )
        }

    func postTrackData (data: [String: String], completion: @escaping(Int?) -> Void) {
            let trackURL = baseURL.appendingPathComponent("insertTrack")
            var request = URLRequest(url: trackURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField:
               "Content-Type")
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(data)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request)
            { (data, response, error) in
                    if let data = data,
                        let jsonDictionary = try?
                        JSONSerialization.jsonObject(with: data) as?
                        [String: Int],
                        let status_code = jsonDictionary["status_code"] {
                                completion(status_code)
                        } else {
                            completion(nil)
                        }
            }
            task.resume( )
        }
//    func postCategoryData (data: [String: String], completion: @escaping(Int?) -> Void) {
//            let categoryURL = baseURL.appendingPathComponent("insertCategory")
//            var request = URLRequest(url: categoryURL)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField:
//               "Content-Type")
//            let jsonEncoder = JSONEncoder()
//            let jsonData = try? jsonEncoder.encode(data)
//            request.httpBody = jsonData
//            let task = URLSession.shared.dataTask(with: request)
//            { (data, response, error) in
//                    if let data = data,
//                        let jsonDictionary = try?
//                        JSONSerialization.jsonObject(with: data) as?
//                        [String: Int],
//                        let status_code = jsonDictionary["status_code"] {
//                                completion(status_code)
//                        } else {
//                            completion(nil)
//                        }
//            }
//            task.resume( )
//        }
//}


}
