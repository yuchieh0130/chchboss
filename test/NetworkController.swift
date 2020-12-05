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
    let baseURL = URL(string: "http://140.119.19.42:5000/")!
    
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
    
    func addSavedplaceData (data: [String: String], completion: @escaping(Int?) -> Void) {
        let saveplaceURL = baseURL.appendingPathComponent("insertSavedplace")
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
    
    func updateSavedplaceData (data: [String: String], completion: @escaping(Int?) -> Void) {
        let saveplaceURL = baseURL.appendingPathComponent("updateSavedplace")
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
    
    func deleteSavedplaceData (data: [String: String], completion: @escaping(Int?) -> Void) {
        let saveplaceURL = baseURL.appendingPathComponent("deleteSavedplace")
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
    
    func pushSavedPlaceData (data: [String: String], completion: @escaping([Any]?) -> Void) {
        let savedPlaceURL = baseURL.appendingPathComponent("pushSavedplace")
        var request = URLRequest(url: savedPlaceURL)
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
                    JSONSerialization.jsonObject(with: data) as? [String:Any],
                let status_code = jsonDictionary["status_code"],
                let user_data = jsonDictionary["data"] as? [[Any]]{
                completion([status_code,user_data])
                //print(jsonDictionary)
            } else {
                completion(nil)
            }
        }
        task.resume( )
    }
    
    func pushTrackData (data: [String: String], completion: @escaping([Any]?) -> Void) {
        let trackURL = baseURL.appendingPathComponent("pushTrack")
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
                    JSONSerialization.jsonObject(with: data) as? [String:Any],
                let status_code = jsonDictionary["status_code"],
                let user_data = jsonDictionary["data"] as? [[Any]],
                let last_track_id = jsonDictionary["last_track_id"]{
                completion([status_code,user_data, last_track_id])
                //print(jsonDictionary)
            } else {
                completion(nil)
            }
        }
        task.resume( )
    }
    
    func pushLocationData (data: [String: String], completion: @escaping([Any]?) -> Void) {
        let trackURL = baseURL.appendingPathComponent("pushLocation")
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
                    JSONSerialization.jsonObject(with: data) as? [String:Any],
                let status_code = jsonDictionary["status_code"],
                let user_data = jsonDictionary["data"] as? [[Any]]{
                completion([status_code,user_data])
                //print(jsonDictionary)
            } else {
                completion(nil)
            }
        }
        task.resume( )
    }
    
    func updateTrackData (data: [String: String], completion: @escaping(Int?) -> Void) {
        let trackURL = baseURL.appendingPathComponent("updateTrack")
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
    
    func deleteTrackData (data: [String: String], completion: @escaping(Int?) -> Void) {
        let trackURL = baseURL.appendingPathComponent("deleteTrack")
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
    
    func postSleepData (inBed: Bool, startDate: String, endDate: String, session_id: String, completion: @escaping(Int?) -> Void) {
        let sleepURL = baseURL.appendingPathComponent("sleep")
        var request = URLRequest(url: sleepURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
            "Content-Type")
        let data: [String: String] = ["session_id": session_id ,"in_bed": String(inBed), "start_date": startDate, "end_date": endDate]
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
    
    
    func register (email: String, password: String, user_name: String, completion: @escaping([Any]?) -> Void) {
        let registerURL = baseURL.appendingPathComponent("register")
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
            "Content-Type")
        let data: [String: String] = ["email": email, "password": password, "user_name": user_name]
        let jsonEncoder = JSONEncoder( )
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            if let data = data,
                let jsonDictionary = try?
                    JSONSerialization.jsonObject(with: data) as?
                        [String: Int], //[[Any]]
                let status_code = jsonDictionary["status_code"],
                let user_id = jsonDictionary["user_id"]{
                completion([status_code, user_id])
            } else {
                completion(nil)
            }
        }
        task.resume( )
    }
    
    //    func register (email: String, password: String, user_name: String, completion: @escaping([Any]?) -> Void) {
    //        let registerURL = baseURL.appendingPathComponent("register")
    //        var request = URLRequest(url: registerURL)
    //        request.httpMethod = "POST"
    //        request.setValue("application/json", forHTTPHeaderField:
    //           "Content-Type")
    //        let data: [String: String] = ["email": email, "password": password, "user_name": user_name]
    //        let jsonEncoder = JSONEncoder( )
    //        let jsonData = try? jsonEncoder.encode(data)
    //        request.httpBody = jsonData
    //        let task = URLSession.shared.dataTask(with: request)
    //            { (data, response, error) in
    //                    if let data = data,
    //                        let jsonDictionary = try?
    //                        JSONSerialization.jsonObject(with: data) as?
    //                        [String: Any],
    //                        let status_code = jsonDictionary["status_code"] as? Int,
    //                            let user_id = jsonDictionary["user_id"] as? Int{
    //                                completion([status_code, user_id])
    //                        } else {
    //                            completion(nil)
    //                        }
    //            }
    //        task.resume( )
    //    }
    
    func lineLogin (user_lineid: String, user_name: String, completion: @escaping([Any]?) -> Void) {
        let lineLoginURL = baseURL.appendingPathComponent("linelogin")
        var request = URLRequest(url: lineLoginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
            "Content-Type")
        let data: [String: String] = ["user_lineid": user_lineid, "user_name": user_name]
        let jsonEncoder = JSONEncoder( )
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            if let data = data,
                let jsonDictionary = try?
                    JSONSerialization.jsonObject(with: data) as?
                        [String: Any], //[[Any]]
                let status_code = jsonDictionary["status_code"] as? Int,
                let user_id = jsonDictionary["user_id"] as? Int,
                let user_name = jsonDictionary["user_name"]{
                completion([status_code, user_id, user_name])
            } else {
                completion(nil)
            }
        }
        task.resume( )
    }
    
    func login (email: String, password: String, completion: @escaping([Any]?) -> Void) {
        let loginURL = baseURL.appendingPathComponent("login")
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
            "Content-Type")
        let data: [String: String] = ["email": email, "password": password]
        let jsonEncoder = JSONEncoder( )
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            if let data = data,
                let jsonDictionary = try?
                    JSONSerialization.jsonObject(with: data) as?
                        [String: Any],
                let status_code = jsonDictionary["status_code"] as? Int,
                let user_id = jsonDictionary["user_id"] as? Int,
                let user_name = jsonDictionary["user_name"]{
                completion([status_code, user_id,user_name])
            } else {
                completion(nil)
            }
        }
        task.resume( )
    }
    
    //
    func searchFriend (user_id:String,completion: @escaping([Any]?) -> Void) {
        let trackURL = baseURL.appendingPathComponent("searchFriend")
        var request = URLRequest(url: trackURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
            "Content-Type")
        let data: [String: String] = ["user_id": user_id]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            if let data = data,
                let jsonDictionary = try?
                    JSONSerialization.jsonObject(with: data) as?
                        [String: Any],
                let status_code = jsonDictionary["status_code"],
                let friend = jsonDictionary["friend"] as? [[Any]] {
                completion([status_code,friend])
            } else {
                completion(nil)
            }
        }
        task.resume( )
    }
    
    func addFriendRequest (friendId: String, completion: @escaping(Int?) -> Void) {
        let trackURL = baseURL.appendingPathComponent("addFriendRequest")
        var request = URLRequest(url: trackURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
            "Content-Type")
        let user_id = "\(UserDefaults.standard.integer(forKey: "user_id"))"
        let data: [String: String] = ["user_id": user_id,"friend_id": friendId]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            if let data = data,
                let jsonDictionary = try?
                    JSONSerialization.jsonObject(with: data) as?
                        [String: Int],
                let status_code = jsonDictionary["status_code"]{
                completion(status_code)
            } else {
                completion(nil)
            }
        }
        task.resume( )
    }
    
    
    func searchFriendList (completion: @escaping([Any]?) -> Void) {
        let trackURL = baseURL.appendingPathComponent("searchFriendList")
        var request = URLRequest(url: trackURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
            "Content-Type")
        let user_id = "\(UserDefaults.standard.integer(forKey: "user_id"))"
        let data: [String: String] = ["user_id": user_id]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            //            print("data!")
            //            print(String(data: data!, encoding: .utf8))
            if let data = data,
                let jsonDictionary = try?
                    JSONSerialization.jsonObject(with: data) as?
                        [String: Any],
                let status_code = jsonDictionary["status_code"],
                let confirm_friendlist = jsonDictionary["confirm_friendlist"] as? [[Any]],
                let unconfirm_friendlist = jsonDictionary["unconfirm_friendlist"] as? [[Any]]{
                completion([status_code,confirm_friendlist,unconfirm_friendlist])
            } else {
                completion(nil)
            }
        }
        task.resume( )
    }
    
    
    func insertFriend (friendId: String, completion: @escaping(Int?) -> Void) {
        let trackURL = baseURL.appendingPathComponent("insertFriend")
        var request = URLRequest(url: trackURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
            "Content-Type")
        let user_id = "\(UserDefaults.standard.integer(forKey: "user_id"))"
        let data: [String: String] = ["user_id": user_id,"friend_id": friendId]
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
    
    
    func deleteFriend (friendId: String, completion: @escaping(Int?) -> Void) {
        let trackURL = baseURL.appendingPathComponent("deleteFriend")
        var request = URLRequest(url: trackURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
            "Content-Type")
        let user_id = "\(UserDefaults.standard.integer(forKey: "user_id"))"
        let data: [String: String] = ["user_id": user_id,"friend_id": friendId]
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
    
    func addEmoji (emoji: String, user_id:String, completion: @escaping(Int?) -> Void) {
        let trackURL = baseURL.appendingPathComponent("addEmoji")
        var request = URLRequest(url: trackURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
            "Content-Type")
        let data: [String: String] = ["user_id": user_id,"emoji": emoji]
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
    
    func rank (category: String,completion: @escaping([Any]?) -> Void) {
        let trackURL = baseURL.appendingPathComponent("rank")
        var request = URLRequest(url: trackURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
            "Content-Type")
        let user_id = "\(UserDefaults.standard.integer(forKey: "user_id"))"
        //let data: [String: String] = ["user_id": user_id,"category": category,"currenttime":currentTime]
        let data: [String: String] = ["user_id": user_id,"category": category]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            if let data = data,
                let jsonDictionary = try?
                    JSONSerialization.jsonObject(with: data) as?
                        [String: Any],
                let status_code = jsonDictionary["status_code"],
                let rank = jsonDictionary["rank"] as? [Any]{
                completion([status_code, rank])
            } else {
                completion(nil)
            }
        }
        task.resume( )
    }
    
    func logout (completion: @escaping(Int?) -> Void) {
        let loginURL = baseURL.appendingPathComponent("resetTrack")
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField:
            "Content-Type")
        let user_id = "\(UserDefaults.standard.integer(forKey: "user_id"))"
        let data: [String: String] = ["user_id": user_id]
        let jsonEncoder = JSONEncoder( )
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            if let data = data,
                let jsonDictionary = try?
                    JSONSerialization.jsonObject(with: data) as?
                        [String: Any],
                let status_code = jsonDictionary["status_code"] as? Int{
                completion(status_code)
            } else {
                completion(nil)
            }
        }
        task.resume( )
    }
    
    
}
