//
//  UserLoginViewControler.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/26/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import SwiftyJSON
import NotificationBannerSwift
import NVActivityIndicatorView

class UserLoginViewControler: UIViewController {
    @IBOutlet weak var gradintView: UIView!
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var activitiIndicator: NVActivityIndicatorView!
    
    @IBOutlet weak var userNameTextFild: UITextField!
    @IBOutlet weak var passwordTextFild: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
createGradientLayer()
        // Do any additional setup after loading the view.
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 28/255, green: 169/255, blue: 226/255, alpha: 1).cgColor, UIColor(red: 227/255, green: 183/255, blue: 195/255, alpha: 1).cgColor]
        self.gradintView.layer.addSublayer(gradientLayer)
        
        
        userNameTextFild.layer.cornerRadius = 25.0
        userNameTextFild.layer.masksToBounds = true
        userNameTextFild.layer.borderColor = UIColor.white.cgColor
        userNameTextFild.layer.borderWidth = 1.0
        
        passwordTextFild.layer.cornerRadius = 25.0
        passwordTextFild.layer.masksToBounds = true
        passwordTextFild.layer.borderColor = UIColor.white.cgColor
        passwordTextFild.layer.borderWidth = 1.0
        
    }
    @IBAction func userLofinTap(_ sender: Any) {
        
     let emailAddressString = userNameTextFild.text!
     let passwordString = passwordTextFild.text!
        
        if(!emailAddressString.isValidEmail()){
            
            let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid email address",  style: .danger)
            banner.show()
        }else{
        
        activitiIndicator.startAnimating()
        
        let json: JSON =  ["Username": emailAddressString, "Password": passwordString]
        print(json)
        RestClient.makeArryPostRequestUrl(url: APPURL.userAuthLogin,arryParam: json, delegate: self, requestFinished: #selector(self.requestFinishedSync), requestFailed: #selector(self.requestFailedSync), tag: 1)
        
    }
        }

    @objc func requestFinishedSync(response:ResponseSwift){
        
        do {
            let userObj = JSON(response.responseObject)
            print(userObj)
            if(userObj["success"]).boolValue{
                
              activitiIndicator.startAnimating()
                
            }else{
               activitiIndicator.startAnimating()
            }
            
        } catch let error {
            print(error)
        }
        
    }
    
    @objc func requestFailedSync(response:ResponseSwift){
        print("requestFailed working")
    }
    
    
}


extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    
    
    
    
}
