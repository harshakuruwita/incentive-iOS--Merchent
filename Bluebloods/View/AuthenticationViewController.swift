//
//  AuthenticationViewController.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/9/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import MSAL

class AuthenticationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let kClientID = "916d32d8-3071-40f2-a75d-762ac7342051"        
        // Additional variables for Auth and Graph API
        let kGraphURI = "https://graph.microsoft.com/v1.0/me/"
        let kScopes: [String] = ["https://graph.microsoft.com/user.read"]
        let kAuthority = "https://login.microsoftonline.com/common"
        var accessToken = String()
        var applicationContext : MSALPublicClientApplication?
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
