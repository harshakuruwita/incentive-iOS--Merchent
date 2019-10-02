//
//  URLConstants.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/26/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import Foundation

struct APPURL {
    
    private struct Domains {
        static let Globaluri = "https://www.dev.linkedassets.com"
        static let Localuri = "http://192.168.1.21:8080/api/v1/"
     
    }
    
    
    private  static let GlobalDomain = Domains.Globaluri
    private  static let LocalDomain = Domains.Localuri
  
    
    
    static var userAuthLogin: String {
        return LocalDomain  + "auth/mobile/token"
    }
    
    static var fetchUserData: String {
        return LocalDomain  + "user/mobile/profile"
    }
    
    static var getOrganization: String {
        return LocalDomain  + "merchant/mobile/stores"
    }
    
    static var addUser: String {
        return LocalDomain  + "merchant/mobile/user"
    }
    
    static var getFilter: String {
          return LocalDomain  + "user/incentive"
      }
    
    static var contactsUs: String {
        return LocalDomain  + "merchant/contact"
    }
    
    static var sendToken: String {
          return LocalDomain  + "message/mobile_data"
      }
}
