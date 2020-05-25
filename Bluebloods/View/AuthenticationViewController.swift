//
//  AuthenticationViewController.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/9/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import SwiftyJSON
import NotificationBannerSwift
import NVActivityIndicatorView
import SDWebImage
import RealmSwift


class AuthenticationViewController: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var storeLogo: UIImageView!
    @IBOutlet weak var bgImage: UIImageView!
    
    @IBOutlet weak var SiginButton: UIButton!
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGradientLayer()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        SiginButton.layer.cornerRadius = 5
        SiginButton.layer.borderWidth = 1
        SiginButton.layer.borderColor = UIColor.white.cgColor
        
        
        
        let json: JSON =  ["merchantId": AppConstants.organizationid]
                  
           
        RestClient.makeArryPostRequestUrl(url: APPURL.getOrganizationImages,arryParam: json, delegate: self, requestFinished: #selector(self.requestFinishedSync), requestFailed: #selector(self.requestFailedSync), tag: 1)
    }


 
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 31/255, green: 145/255, blue: 135/255, alpha: 1).cgColor, UIColor(red: 174/255, green: 203/255, blue: 191/255, alpha: 1).cgColor]
        self.gradientView.layer.addSublayer(gradientLayer)
    }
    
    @objc func requestFinishedSync(response:ResponseSwift){
          
          do {
              let userObj = JSON(response.responseObject!)
              
              print("Response -\(userObj)")
            
            let storeLogoPath  = userObj["response"]["data"]["AgentTheme"]["background"][0]["url"].stringValue
                 bgImage.sd_setImage(with: URL(string: storeLogoPath), placeholderImage: UIImage(named: "placeholder.png"))
              
          } catch let error {
              print(error)
          }
          
      }
   @objc func requestFailedSync(response:ResponseSwift){
       
   }
   

}
