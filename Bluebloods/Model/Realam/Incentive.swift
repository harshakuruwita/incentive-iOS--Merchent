//
//  Incentive.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 9/25/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import RealmSwift

class Incentive: Object {
    @objc dynamic var incentiveId = 0
    @objc dynamic var incentiveName = ""
    @objc dynamic var url = ""
    
    override static func primaryKey() -> String? {
           return "incentiveId"
       }
}

