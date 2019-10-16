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
import DropDown
import NVActivityIndicatorView


class UserRegistation: UIViewController {
    @IBOutlet weak var gradientView: UIView!
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var emailAdderssFild: BorderdTextFild!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var firstNameFild: BorderdTextFild!
    @IBOutlet weak var lastNameFild: BorderdTextFild!
    @IBOutlet weak var salesIdFild: BorderdTextFild!
    @IBOutlet weak var storeIdFild: BorderdTextFild!
    @IBOutlet weak var phoneNumberFild: BorderdTextFild!
    
    @IBOutlet weak var activitiIndicator: NVActivityIndicatorView!
    @IBOutlet weak var storeDropdownHolder: UIView!
    
    

    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var userEmil : String?
    var password : String?
    var fullname : String?
    var storeid : Int?
    var userRoleValue : String?
    let dropDownRole = DropDown()
    let dropDownStore = DropDown()
    var jsonArry = [String]()
    var storeJson:JSON = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientLayer()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        storeDropdownHolder.isHidden = true
        dropDownStore.width = UIScreen.main.bounds.width
        dropDownRole.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            if(index == 0){
                self.userRoleValue = "SALES_REP"
                self.storeDropdownHolder.isHidden = true
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
            let storeName = self.storeJson[index]["storeName"].stringValue
            self.storeButton.setTitle(storeName, for: .normal)
            self.storeid = self.storeJson[index]["id"].intValue
        }
    }
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }

    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 31/255, green: 145/255, blue: 135/255, alpha: 1).cgColor, UIColor(red: 174/255, green: 203/255, blue: 191/255, alpha: 1).cgColor]
        self.gradientView.layer.addSublayer(gradientLayer)
  
    }
    
    @IBAction func nextBtnTap(_ sender: Any) {
        
        let emailAdderss = emailAdderssFild.text!
        let firstName = firstNameFild.text!
        let lastName = lastNameFild.text!
        let salesId = salesIdFild.text!
        let storeId = storeIdFild.text!
        let phoneNumber = phoneNumberFild.text!
        
        if(!emailAdderss.isValidEmail()){
            let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid email address",  style: .danger)
            banner.show()
            
        }else if (firstName == ""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "First name cannot be ampty",  style: .danger)
            banner.show()
        }
        else if (lastName == ""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "Last name cannot be ampty",  style: .danger)
            banner.show()
            
        }else if (salesId == ""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "Sales id can  not be ampty",  style: .danger)
            banner.show()
        }else if (storeId == ""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "Store id can  not be ampty",  style: .danger)
            banner.show()
        }else if (phoneNumber == ""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "Phone number can  not be ampty",  style: .danger)
            banner.show()
        }
        else{
            
            let userJsonDatarest:[String : Any] = ["email":emailAdderss,"firstName":firstName,"lastName":lastName,"salesId":Int(salesId),"currentStatus":"pending","mobileNo":Int(phoneNumber),"userRole":userRoleValue,"storeId":storeid,"userType":"ORGANIZATION","salesIdList":[],"organizationId":Int(AppConstants.organizationid)]
            
            print(JSON(userJsonDatarest))
            let json: JSON =  JSON(userJsonDatarest)
            activitiIndicator.startAnimating()
            RestClient.makeArryPostRequestUrl(url: APPURL.addUser,arryParam: json, delegate: self, requestFinished: #selector(self.requestFinishedgCreateUser), requestFailed: #selector(self.requestFailedSync), tag: 1)
        }
        
    }
    

    
    
    /////////
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
                
                dropDownStore.cornerRadius = 8
                dropDownStore.topOffset = CGPoint(x: 0, y:(dropDownRole.anchorView?.plainView.bounds.height)!)
                dropDownStore.show()
                storeDropdownHolder.isHidden = false
                
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
            activitiIndicator.stopAnimating()
            let userObj = JSON(response.responseObject!)
            print(userObj)
            if(userObj["response"]["code"].int == 200){
                
                let alert = UIAlertController(title: "Success", message: "User creation successful please login using username and password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                  //  performSegue(withIdentifier: "rederectUserLogin", sender: nil)
                    self.performSegue(withIdentifier: "rederectUserLogin", sender: nil)
                }))
                
                
                self.present(alert, animated: true)
               
                
                
            }else{
                
            }
            
            
        } catch let error {
            print(error)
            activitiIndicator.stopAnimating()
        }
        
    }
    
    
    @objc func requestFailedSync(response:ResponseSwift){
        
    }
    ////////

}
