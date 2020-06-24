//
//  StorageManager.swift
//  TestWorkWeatherApp
//
//  Created by Nikita Vesna on 24.06.2020.
//  Copyright © 2020 Nikita Vesna. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ city: Cities) {
        try! realm.write {
            realm.add(city)
        }
    }
    
    /*
    static func deleteObject(_ city: Cities) {
        try! realm.write{
            realm.delete(city)
        }
    }
    */
}
