//
//  Model.swift
//  TestWorkWeatherApp
//
//  Created by Nikita Vesna on 24.06.2020.
//  Copyright © 2020 Nikita Vesna. All rights reserved.
//

import RealmSwift

 
class Cities: Object {

    @objc dynamic var name = ""
    @objc dynamic var country = ""
    @objc dynamic var id = 0

    convenience init(name: String, country: String, id: Int) {
        self.init()
        self.name = name
        self.country = country
        self.id = id
    }
}

/*
   override static func primaryKey() -> Int? {
       return id
   }
*/

struct Coordinates {
    let latitude: Double
    let longitude: Double
}
