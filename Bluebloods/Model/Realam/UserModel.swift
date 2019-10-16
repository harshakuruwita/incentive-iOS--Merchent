//
//  UserModel.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/28/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import RealmSwift

class UserModel: Object {
    @objc dynamic var userType = ""
    @objc dynamic var userRole = ""
    @objc dynamic var userId = 0
    @objc dynamic var updateAt = NSDate()
    @objc dynamic var token = ""
    @objc dynamic var storeId = 0
    @objc dynamic var storeName = ""
    @objc dynamic var salesId = ""
    @objc dynamic var regionId = 0
    @objc dynamic var organizationId = 0
    @objc dynamic var mobileNo = ""
    @objc dynamic var lastName = ""
    @objc dynamic var firstName = ""
    @objc dynamic var email = ""
    @objc dynamic var currentStatus = ""
    @objc dynamic var createdAt = NSDate()
    @objc dynamic var azureId = ""
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}
