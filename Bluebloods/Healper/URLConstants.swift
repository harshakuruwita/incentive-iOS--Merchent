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
      //  static let Globaluri = "https://www.dev.linkedassets.com"
     //  static let Localuri = "https://incentive-api-prod.azurewebsites.net/api/v1/"
       static let Localuri = "https://incentive-api-dev.azurewebsites.net/api/v1/"
        
        static let organizationUri = "https://incentive-app-module-uat.azurewebsites.net/"
     //   static let organizationUri = "https://2degrees.pcincentives.co.nz/"
    // static let organizationUri = "https://bluebloods-uat.pcincentives.co.nz/"
    }
    
    
//    private  static let GlobalDomain = Domains.Globaluri
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
          return LocalDomain  + "merchant/message/mobile_data"
      }
    
    static var resetPassword: String {
        return LocalDomain  + "auth/reset_password"
    }
    
    static var fetchKpiData: String {
        return LocalDomain  + "user/kpi/tbl/result?incentivefield="
    }
    
    static var fetchStoreDashbord: String {
           return LocalDomain  + "user/dashboard/store/table?&incentivefield="
       }
    
    static var fetchIndividualDashbord: String {
              return LocalDomain  + "user/dashboard/salesrep/kpi?&incentivefield="
          }
    
    static var fetchIndividualLeaderBordData: String {
        return LocalDomain  + "user/mobile/slaesrep/leaderboard?&incentivefield="
    }
    
    static var fetchStoreLeaderBordData: String {
        return LocalDomain  + "user/mobile/store/leaderboard?&incentivefield="
    }
    
    static var getUsersOfStoremanager: String {
        return LocalDomain  + "user/kpi/tbl/result?incentivefield="
    }
    
    static var editUserProfile: String {
        return LocalDomain  + "merchant/mobile/user/profile"
    }
    
    static var getOrganizationUri: String {
        return Domains.organizationUri
    }
    
    static var getOrganizationImages: String {
        return LocalDomain  + "merchant/mobile/assets"
    }
}

