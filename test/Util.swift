//
//  Util.swift
//  test
//
//  Created by 謝宛軒 on 2020/3/10.
//  Copyright © 2020 AppleInc. All rights reserved.
//

import Foundation

class Util: NSObject {
    
    /*get db document path*/
    class func getPath(_ fileName: String) -> String{
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        print("Datebase Path: \(fileUrl.path)")
        return fileUrl.path
    }
    
    /*build simulator's database*/
    //write"Util.copyDatabase("project.db")"in AppDelegate
    class func copyDatabase(_ fileName: String){
        let dbPath = getPath("project.db")
        let fileManager = FileManager.default
        
        //檢查，沒有創過db才會新建db
        if !fileManager.fileExists(atPath: dbPath){
            let bundle = Bundle.main.resourceURL
            let file = bundle?.appendingPathComponent(fileName)
            var error: NSError?
            do{
                try fileManager.copyItem(atPath: (file?.path)!, toPath: dbPath)
            }catch let error1 as NSError{
                error = error1
            }
            if error == nil{
                print("error in db")
            }else{
                print("success!!!")
            }
        }
    }

}
