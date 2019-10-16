//
//  PasswordReset.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 10/2/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import SwiftyJSON
import NotificationBannerSwift
import NVActivityIndicatorView
import RealmSwift

class PasswordReset: UIViewController {
    @IBOutlet weak var gradintView: UIView!
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var activitiIndicator: NVActivityIndicatorView!
    

    
    @IBOutlet weak var userNameTextFild: BorderdTextFild!

    @IBOutlet weak var dataFetchActivitiIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientLayer()
      
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
           
           view.endEditing(true)
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 31/255, green: 145/255, blue: 135/255, alpha: 1).cgColor, UIColor(red: 174/255, green: 203/255, blue: 191/255, alpha: 1).cgColor]
        self.gradintView.layer.addSublayer(gradientLayer)
        
        
        userNameTextFild.layer.cornerRadius = 25.0
        userNameTextFild.layer.masksToBounds = true
        userNameTextFild.layer.borderColor = UIColor.white.cgColor
        userNameTextFild.layer.borderWidth = 1.0
        
  
        
    }
    @IBAction func userLofinTap(_ sender: Any) {
      
     let emailAddressString = userNameTextFild.text!
     
        
  
        
        if(!emailAddressString.isValidEmail()){
            
            let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid email address",  style: .danger)
            banner.show()
        }else{
        
        activitiIndicator.startAnimating()
        
        let json: JSON =  ["email": emailAddressString]
            
       
       
        RestClient.makeArryPostRequestWithToken(url: APPURL.resetPassword,arryParam: json, delegate: self, requestFinished: #selector(self.requestFinishedSync), requestFailed: #selector(self.requestFailedSync), tag: 1)
 
    }

        
        
      
    
        }

    @objc func requestFinishedSync(response:ResponseSwift){
        
        do {
            activitiIndicator.stopAnimating()
            let userObj = JSON(response.responseObject!)
            
            if(userObj["response"]["code"].intValue == 200){
                let banner = NotificationBanner(title: "Success", subtitle: "The password reset email has been sent to your on-file email address.",  style: .success)
                banner.show()
                 self.performSegue(withIdentifier: "passwordResetSuccess", sender: nil)
                
            }else{
                let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid email address",  style: .danger)
                banner.show()
            }
        
            
        } catch let error {
            print(error)
        }
        
    }
    

    
    

    
    
    
    @objc func requestFailedSync(response:ResponseSwift){
        
    }
    
    
    
    @IBAction func unwindFromCreateUser(segue: UIStoryboardSegue) {
       print("unwind")
    }
    
    
}



