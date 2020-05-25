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
import RealmSwift

class UserLoginViewControler: UIViewController {
    @IBOutlet weak var gradintView: UIView!
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var activitiIndicator: NVActivityIndicatorView!
    

    
    @IBOutlet weak var userNameTextFild: BorderdTextFild!
    

    @IBOutlet weak var passwordTextFild: BorderdTextFild!
    
    

    @IBOutlet weak var dataFetchActivitiIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientLayer()
        //loginSuccessView.isHidden = true
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
        
        passwordTextFild.layer.cornerRadius = 25.0
        passwordTextFild.layer.masksToBounds = true
        passwordTextFild.layer.borderColor = UIColor.white.cgColor
        passwordTextFild.layer.borderWidth = 1.0
        
    }
    @IBAction func userLofinTap(_ sender: Any) {
      
     let emailAddressString = userNameTextFild.text!
     let passwordString = passwordTextFild.text!
        
        if(emailAddressString == "" || passwordString == ""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "E-mail and password required!",  style: .danger)
                      banner.show()
        }
        
       else if(!emailAddressString.isValidEmail()){
            
            let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid email address!",  style: .danger)
            banner.show()
        }else{
        
        activitiIndicator.startAnimating()
        
        let json: JSON =  ["Username": emailAddressString, "Password": passwordString,"domain":APPURL.getOrganization]
            
     
       
        RestClient.makeArryPostRequestUrl(url: APPURL.userAuthLogin,arryParam: json, delegate: self, requestFinished: #selector(self.requestFinishedSync), requestFailed: #selector(self.requestFailedSync), tag: 1)
 
    }

        
        
      
    
        }

    @objc func requestFinishedSync(response:ResponseSwift){
        
        do {
            let userObj = JSON(response.responseObject!)
            
            print("Response -\(userObj)")
            if(userObj["response"]["code"].int == 200){
                
                
                //loginSuccessView.isHidden = false
              //  dataFetchActivitiIndicator.startAnimating()
                fetchUserData(access_token: userObj["response"]["data"]["access_token"].stringValue)
                
            }else if(userObj["response"]["code"].int == 400){
                let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid username or password!",  style: .danger)
                activitiIndicator.stopAnimating()
                banner.show()
            }else{
                let banner = NotificationBanner(title: "Sorry", subtitle: "Service error!",  style: .danger)
                              activitiIndicator.stopAnimating()
                              banner.show()
            }
            
        } catch let error {
            print(error)
        }
        
    }
    
    @objc func requestFinishedFetch(response:ResponseSwift){
        
        do {
            let userObj = JSON(response.responseObject!)
            print(userObj)
            activitiIndicator.stopAnimating()
            if(userObj["response"]["code"].int == 200){
               
               
                if(userObj["response"]["code"].int == 200){
                    
                    let user = userObj["response"]["data"]["user"]
                    let salesIds = userObj["response"]["data"]["salesIds"]
                    let organization = userObj["response"]["data"]["org"]
                    let organizationTheam = userObj["response"]["data"]["org"]["OrganizationTheme"]
                    var theamJson = JSON.init(parseJSON:organizationTheam.stringValue)
                    
                    let dbUser = UserModel()
                    let dbOrganization = Organization()
                    let dbOrganizationTheme = OrganizationTheme()
                    
                    UserDefaults.standard.set(user["firstName"].stringValue, forKey: "firstName")
                    UserDefaults.standard.set(user["lastName"].stringValue, forKey: "lastName")
                    UserDefaults.standard.set(user["mobileNo"].stringValue, forKey: "mobilenumber")
                    
                    guard let rawData = try? salesIds.rawData() else { return }
                    UserDefaults.standard.setValue(rawData, forKey: "salesIdArry")
                    
               
                    
                    dbUser.userType =  user["userType"].stringValue
                    dbUser.userRole =  user["userRole"].stringValue
                    dbUser.userId =  user["userId"].intValue
                    dbUser.updateAt =  user["updateAt"].stringValue.toNSDate()
                    dbUser.token =  user["token"].stringValue
                    dbUser.storeId =  user["storeId"].intValue
                    dbUser.storeName = userObj["response"]["data"]["storeName"].stringValue
                    dbUser.salesId =  user["salesId"].stringValue
                    if(salesIds.count > 0){
                        dbUser.salesId_second =  salesIds[0].stringValue
                    }else{
                        dbUser.salesId_second =  "-"
                    }
                    
                    
                    
                    dbUser.regionId =  user["regionId"].intValue
                    dbUser.organizationId =  user["organizationId"].intValue
                    dbUser.mobileNo =  user["mobileNo"].stringValue
                    dbUser.lastName =  user["lastName"].stringValue
                    dbUser.firstName =  user["firstName"].stringValue
                    dbUser.email =  user["email"].stringValue
                    dbUser.currentStatus =  user["currentStatus"].stringValue
                    dbUser.createdAt =  user["createdAt"].stringValue.toNSDate()
                    dbUser.azureId =  user["azureId"].stringValue
                    
                    dbOrganization.id = organization["id"].intValue
                    dbOrganization.Country = organization["Country"].stringValue
                    dbOrganization.LoginEmail = organization["LoginEmail"].stringValue
                    dbOrganization.ContactPersonName = organization["ContactPersonName"].stringValue
                    dbOrganization.ContactNumber = organization["ContactNumber"].stringValue
                    dbOrganization.ContactEmail = organization["ContactEmail"].stringValue
                    dbOrganization.CompanyStatus = organization["CompanyStatus"].stringValue
                    dbOrganization.CompanyName = organization["CompanyName"].stringValue
                    dbOrganization.CompanyDomain = organization["CompanyDomain"].stringValue
                    dbOrganization.CompanyAddress = organization["CompanyAddress"].stringValue
                    dbOrganization.City = organization["City"].stringValue
                    
                    dbOrganizationTheme.color1 = theamJson["color1"].stringValue
                    dbOrganizationTheme.color2 = theamJson["color2"].stringValue
                    dbOrganizationTheme.logoLarge = theamJson["logoLarge"][0]["path"].stringValue
                    dbOrganizationTheme.uid = theamJson["uid"].stringValue
                    dbOrganizationTheme.logoSmall = theamJson["logoSmall"][0]["path"].stringValue
                    dbOrganizationTheme.path = theamJson["path"].stringValue
                    
                    
                    
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(dbUser)
                        realm.add(dbOrganization)
                        realm.add(dbOrganizationTheme)
                    }
                    
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    UserDefaults.standard.set(user["token"].stringValue, forKey: "token")
                    Switcher.updateRootVC()
                }
                
            }else {
                
                if let message = userObj["response"]["message"].string {
                    activitiIndicator.stopAnimating()
                    let banner = NotificationBanner(title: "Sorry", subtitle:message,  style: .danger)
                                   banner.show()
                }else{
                    activitiIndicator.stopAnimating()
                    let banner = NotificationBanner(title: "Sorry", subtitle:"User doesn't have permission to login!",  style: .danger)
                    banner.show()
                }
                
                
               
  
            }
            
        } catch let error {
            print(error)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is PasswordReset
        {
            userNameTextFild.text = ""
            passwordTextFild.text! = ""
        }else if segue.destination is UserRegistation
        {
            userNameTextFild.text = ""
            passwordTextFild.text! = ""
        }
    }
    
    func fetchUserData(access_token:String) {
        
        let uri = APPURL.fetchUserData
        RestClient.makeGetRequst(url: uri,access_token: access_token, delegate: self, requestFinished: #selector(self.requestFinishedFetch), requestFailed: #selector(self.requestFailedSync), tag: 1)
    }
    
    
    
    @objc func requestFailedSync(response:ResponseSwift){
        
    }
    
    
    
    @IBAction func unwindFromCreateUser(segue: UIStoryboardSegue) {
       print("unwind")
    }
    
    func mockData() {
        if let path = Bundle.main.path(forResource: "fetchUserData", ofType: "JSON") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                
                
                /////////////
                let userObj = JSON(jsonObj)
                if(userObj["response"]["code"].int == 200){
                    
                    let user = userObj["response"]["data"]["user"]
                    let organization = userObj["response"]["data"]["org"]
                    let organizationTheam = userObj["response"]["data"]["org"]["OrganizationTheme"]
                     var theamJson = JSON.init(parseJSON:organizationTheam.stringValue)
                    
                    
                    let dbUser = UserModel()
                    let dbOrganization = Organization()
                    let dbOrganizationTheme = OrganizationTheme()
                   
                    
                    dbUser.userType =  user["userType"].stringValue
                    dbUser.userRole =  user["userRole"].stringValue
                    dbUser.userId =  user["userId"].intValue
                    dbUser.updateAt =  user["updateAt"].stringValue.toNSDate()
                    dbUser.token =  user["token"].stringValue
                    dbUser.storeId =  user["storeId"].intValue
                    dbUser.salesId =  user["salesId"].stringValue
                    dbUser.regionId =  user["regionId"].intValue
                    dbUser.organizationId =  user["organizationId"].intValue
                    dbUser.mobileNo =  user["mobileNo"].stringValue
                    dbUser.lastName =  user["lastName"].stringValue
                    dbUser.firstName =  user["firstName"].stringValue
                    dbUser.email =  user["email"].stringValue
                    dbUser.currentStatus =  user["currentStatus"].stringValue
                    dbUser.createdAt =  user["createdAt"].stringValue.toNSDate()
                    dbUser.azureId =  user["azureId"].stringValue
                    
                    dbOrganization.id = organization["id"].intValue
                    dbOrganization.Country = organization["Country"].stringValue
                    dbOrganization.LoginEmail = organization["LoginEmail"].stringValue
                    dbOrganization.ContactPersonName = organization["ContactPersonName"].stringValue
                    dbOrganization.ContactNumber = organization["ContactNumber"].stringValue
                    dbOrganization.ContactEmail = organization["ContactEmail"].stringValue
                    dbOrganization.CompanyStatus = organization["CompanyStatus"].stringValue
                    dbOrganization.CompanyName = organization["CompanyName"].stringValue
                    dbOrganization.CompanyDomain = organization["CompanyDomain"].stringValue
                    dbOrganization.CompanyAddress = organization["CompanyAddress"].stringValue
                    dbOrganization.City = organization["City"].stringValue
                    
                    dbOrganizationTheme.color1 = theamJson["color1"].stringValue
                    dbOrganizationTheme.color2 = theamJson["color2"].stringValue
                    dbOrganizationTheme.logoLarge = theamJson["logoLarge"][0]["path"].stringValue
                    dbOrganizationTheme.uid = theamJson["uid"].stringValue
                    dbOrganizationTheme.logoSmall = theamJson["logoSmall"][0]["path"].stringValue
                    dbOrganizationTheme.path = theamJson["path"].stringValue

                    
                   
                    
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(dbUser)
                        realm.add(dbOrganization)
                        realm.add(dbOrganizationTheme)
                    }
 
                    UserDefaults.standard.set(true, forKey: "firstName")
                    Switcher.updateRootVC()
                }else{
                  
                }
                ////////////
                
                
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
}



