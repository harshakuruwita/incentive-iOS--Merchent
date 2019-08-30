//
//  Organization.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/28/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import RealmSwift

class Organization: Object {
    @objc dynamic var id = 0
    @objc dynamic var Country = ""
    @objc dynamic var LoginEmail = ""
    @objc dynamic var ContactPersonName = ""
    @objc dynamic var ContactNumber = ""
    @objc dynamic var ContactEmail = ""
    @objc dynamic var CompanyStatus = ""
    @objc dynamic var CompanyName = ""
    @objc dynamic var CompanyDomain = ""
    @objc dynamic var CompanyAddress = ""
    @objc dynamic var City = ""
  
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
