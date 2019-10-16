//
//  Recurring.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 9/25/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import RealmSwift

class Recurring: Object {
    @objc dynamic var incentiveId = 0
    @objc dynamic var recuringid = 0
    @objc dynamic var RecurringType = ""
    @objc dynamic var recuringname = ""
    
    override static func primaryKey() -> String? {
              return "recuringid"
          }
    
}

