//
//  UserRegistation.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 9/5/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import SwiftyJSON

class UserRegistation: UIViewController {
    @IBOutlet weak var gradientView: UIView!
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var emailAdderssFild: BorderdTextFild!
    @IBOutlet weak var newpasswordFild: BorderdTextFild!
    @IBOutlet weak var confirmpasswordFild: BorderdTextFild!
    @IBOutlet weak var fullNameFild: BorderdTextFild!
    var userEmil : String?
    var password : String?
    var fullname : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientLayer()
        // Do any additional setup after loading the view.
    }
    

    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 28/255, green: 169/255, blue: 226/255, alpha: 1).cgColor, UIColor(red: 227/255, green: 183/255, blue: 195/255, alpha: 1).cgColor]
        self.gradientView.layer.addSublayer(gradientLayer)
  
    }
    
    @IBAction func nextBtnTap(_ sender: Any) {
        
        let emailAdderss = emailAdderssFild.text!
        let newpassword = newpasswordFild.text!
        let confirmpassword = confirmpasswordFild.text!
        let fullName = fullNameFild.text!
        
        if(!emailAdderss.isValidEmail()){
            let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid email address",  style: .danger)
            banner.show()
            
        }else if (newpassword == ""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "Password cannot be ampty",  style: .danger)
            banner.show()
        }
        else if (newpassword != confirmpassword){
            let banner = NotificationBanner(title: "Sorry", subtitle: "Password not match",  style: .danger)
            banner.show()
            
        }else if (fullName == ""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "Full name can  not be ampty",  style: .danger)
            banner.show()
        }else{
            
            
             userEmil = emailAdderss
             password = newpassword
             fullname = fullName
            
            performSegue(withIdentifier: "openUserCreateView", sender: sender)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openUserCreateView") {
            let vc = segue.destination as! UserRegistationCreateUser
            vc.userEmil = userEmil
            vc.password = password
            vc.fullname = fullname
        }
    }

}
