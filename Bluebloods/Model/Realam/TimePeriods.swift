//
//  TimePeriods.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 9/25/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import RealmSwift

class TimePeriods: Object {
    @objc dynamic var incentiveId = 0
    @objc dynamic var recuringid = 0
    @objc dynamic var timeperiodid = 0
    @objc dynamic var periodName = ""
    @objc dynamic var StartDate = ""
    @objc dynamic var EndDate = ""

    override static func primaryKey() -> String? {
        return "timeperiodid"
    }
}
