//
//  UserRegistationCreateUser.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 9/5/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import SwiftyJSON
import NotificationBannerSwift
import DropDown
import NVActivityIndicatorView

class UserRegistationCreateUser: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    
    @IBOutlet weak var activitiIndicator: NVActivityIndicatorView!
    var userEmil : String?
    var password : String?
    var fullname : String?
    var storeid : Int?
    var userRoleValue : String?
    let dropDownRole = DropDown()
    let dropDownStore = DropDown()
    var gradientLayer: CAGradientLayer!
    var jsonArry = [String]()
    var storeJson:JSON = []
    
    
    @IBOutlet weak var firstNameFild: BorderdTextFild!
    @IBOutlet weak var lastNameFild: BorderdTextFild!
    @IBOutlet weak var salesIdFild: BorderdTextFild!
    @IBOutlet weak var storeIdFild: BorderdTextFild!
    @IBOutlet weak var phoneNumberFild: BorderdTextFild!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       createGradientLayer()
        storeButton.isHidden = true
    dropDownRole.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
        if(index == 0){
            self.userRoleValue = "SALES_REP"
            self.dropDownButton.setTitle("Sales Rep", for: .normal)
        }else{
             self.userRoleValue = "STORE_MANAGER"
             self.dropDownButton.setTitle("Store Manager", for: .normal)
            self.activitiIndicator.startAnimating()
            let json: JSON =  ["organizationId": AppConstants.organizationid]
            
            RestClient.makeArryPostRequestUrl(url: APPURL.getOrganization,arryParam: json, delegate: self, requestFinished: #selector(self.requestFinishedgetOrganization), requestFailed: #selector(self.requestFailedSync), tag: 1)
        }
        
        }
        
        dropDownStore.selectionAction = { [unowned self] (index: Int, item: String) in
            print(self.storeJson[index]["storeName"].stringValue)
            self.storeid = self.storeJson[index]["id"].intValue
        }

 
    }
    

    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 28/255, green: 169/255, blue: 226/255, alpha: 1).cgColor, UIColor(red: 227/255, green: 183/255, blue: 195/255, alpha: 1).cgColor]
       self.gradientView.layer.addSublayer(gradientLayer)
   
    }

    @IBAction func createUserTap(_ sender: Any) {
        
        let firstName = firstNameFild.text!
        let lastName = lastNameFild.text!
        let salesId = salesIdFild.text!
        let storeId = storeIdFild.text!
        let phoneNumber = phoneNumberFild.text!
        
        if (firstName == ""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "First name cannot be ampty",  style: .danger)
            banner.show()
        }
        else if (lastName == ""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "Last name cannot be ampty",  style: .danger)
            banner.show()
            
        }else if (salesId == ""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "salesId can  not be ampty",  style: .danger)
            banner.show()
        }else if (storeId == ""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "storeId can  not be ampty",  style: .danger)
            banner.show()
        }else if (phoneNumber == ""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "phoneNumber can  not be ampty",  style: .danger)
            banner.show()
        }else{
            
            let userJsonDatarest:[String : Any] = ["email":userEmil,"password":password,"fullname":fullname,"firstName":firstName,"lastName":lastName,"salesId":salesId,"currentStatus":"pending","mobileNo":phoneNumber,"userRole":userRoleValue,"storeId":storeid,"userType":"ORGANIZATION","salesIdList":[],"organizationId":AppConstants.organizationid]
            
            
            let json: JSON =  JSON(userJsonDatarest)
            activitiIndicator.startAnimating()
            RestClient.makeArryPostRequestUrl(url: APPURL.addUser,arryParam: json, delegate: self, requestFinished: #selector(self.requestFinishedgCreateUser), requestFailed: #selector(self.requestFailedSync), tag: 1)
          
        }
        
    }
    
    @IBAction func userRoleSelect(_ sender: Any) {
        
        
        dropDownRole.anchorView = storeButton
        dropDownRole.dataSource = ["Sales Rep", "Store Manager"]
               dropDownRole.topOffset = CGPoint(x: 0, y:-(dropDownRole.anchorView?.plainView.bounds.height)!)
        dropDownRole.show()
        
        
        
    }
    
    @IBAction func storeDropDownSelect(_ sender: Any) {

        dropDownStore.show()
    }
    
    
    @objc func requestFinishedgetOrganization(response:ResponseSwift){
        
        do {
            let userObj = JSON(response.responseObject!)
            print(userObj)
            if(userObj["response"]["code"].int == 200){
                dropDownStore.anchorView = storeButton
          
                dropDownStore.topOffset = CGPoint(x: 0, y:-(dropDownRole.anchorView?.plainView.bounds.height)!)
                dropDownStore.show()
                storeButton.isHidden = false
              
                let jsonArray = userObj["response"]["data"]
                storeJson = jsonArray
                for json in jsonArray.arrayValue {
                    let storeName = json["storeName"]
                    jsonArry.append(storeName.stringValue)
                  
                }
                dropDownStore.dataSource = jsonArry
                dropDownStore.width = 300
                storeButton.setTitle(jsonArry[0], for: .normal)
                storeid = userObj["response"]["data"][0]["id"].intValue
                dropDownStore.show()
                activitiIndicator.stopAnimating()
 
            }else{
               
            }
            
        } catch let error {
            print(error)
        }
        
    }
    
    
    
    @objc func requestFinishedgCreateUser(response:ResponseSwift){
        
        do {
            let userObj = JSON(response.responseObject!)
            print(userObj)
           
            
        } catch let error {
            print(error)
        }
        
    }
    
    
    @objc func requestFailedSync(response:ResponseSwift){
        
    }
    
}
