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
import  WSTagsField

class UserRegistation: UIViewController, UITextViewDelegate {
    @IBOutlet weak var gradientView: UIView!
    var gradientLayer: CAGradientLayer!
    var textHeightConstraint: NSLayoutConstraint!
    var previousPosition:CGRect = CGRect.zero
    
    var amountOfLinesToBeShown: CGFloat = 6
  
    
  //  @IBOutlet weak var salesIDTAg: WSTagsField!
    @IBOutlet weak var contentScroleView: UIScrollView!
    @IBOutlet weak var emailAdderssFild: BorderdTextFild!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var firstNameFild: BorderdTextFild!
    @IBOutlet weak var lastNameFild: BorderdTextFild!
    @IBOutlet weak var salesIdFild: BorderdTextFild!
    @IBOutlet weak var storeIdFild: BorderdTextFild!
    @IBOutlet weak var phoneNumberFild: BorderdTextFild!
    @IBOutlet weak var sec_saled_id_2: BorderdTextFildkey!
    @IBOutlet weak var sec_saled_id_3: BorderdTextFildkey!
    
    @IBOutlet weak var sec_saled_id_1: BorderdTextFildkey!
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
    var secondrySaleIds :[Any] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientLayer()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        // contentScroleView.bounces = contentScroleView.contentOffset.y < contentScroleView.contentSize.height - contentScroleView.frame.height
        
        
      

       
        
               // var maxHeight: CGFloat = sec_saled_id_1.font.lineHeight * amountOfLinesToBeShown
        
//        salesIDTAg.returnKeyType = .done
//        salesIDTAg.acceptTagOption = .space
//        salesIDTAg.placeholderAlwaysVisible = true
//        salesIDTAg.placeholder = "Press space to add"
//        
//        
//        // Events
//        salesIDTAg.onDidAddTag = { field, tag in
//            
//            self.secondrySaleIds.append(tag.text)
//        }
//        
//        
//        salesIDTAg.onDidRemoveTag = { field, tag in
//            
//            self.secondrySaleIds.removeLast()
//        }
//        
//        salesIDTAg.onValidateTag = { tag, tags in
//            // custom validations, called before tag is added to tags list
//            print(tag.text)
//            if(self.checkForIllegalCharacters(string: tag.text)){
//                let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid sales ID! Enter only alphanumeric value without spaces!",  style: .danger)
//                banner.show()
//                return false
//            }else{
//                return true
//            }
//            
//            
//        }
        
        
        self.userRoleValue = "SALES_REP"
        let json: JSON =  ["organizationId": AppConstants.organizationid]
        
        
        
        RestClient.makeArryPostRequestUrl(url: APPURL.getOrganization,arryParam: json, delegate: self, requestFinished: #selector(self.requestFinishedgetOrganization), requestFailed: #selector(self.requestFailedSync), tag: 1)
        
        
        storeDropdownHolder.isHidden = true
        dropDownStore.width = UIScreen.main.bounds.width
        dropDownRole.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            if(index == 0){
                self.userRoleValue = "SALES_REP"
                // self.storeDropdownHolder.isHidden = true
                self.dropDownButton.setTitle("Sales Rep", for: .normal)
            }else{
                self.userRoleValue = "STORE_MANAGER"
                self.dropDownButton.setTitle("Store Manager", for: .normal)
                //self.activitiIndicator.startAnimating()
                
            }
            
        }
        
        dropDownStore.selectionAction = { [unowned self] (index: Int, item: String) in
            let storeName = self.storeJson[index]["storeName"].stringValue
            self.storeButton.setTitle(storeName, for: .normal)
            self.storeid = self.storeJson[index]["id"].intValue
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
          let fixedWidth = textView.frame.size.width
          textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
          let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
          var newFrame = textView.frame
          newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
          textView.frame = newFrame
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 25
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
        let secv_saled_id_v1 = sec_saled_id_1.text!
         let secv_saled_id_v2 = sec_saled_id_2.text!
         let secv_saled_id_v3 = sec_saled_id_3.text!
      
        let phoneNumber = phoneNumberFild.text!
        secondrySaleIds.removeAll()
        if(secv_saled_id_v1 != "" && !self.checkForIllegalCharacters(string: secv_saled_id_v1) ){
            self.secondrySaleIds.append(secv_saled_id_v1)
        }
        if(secv_saled_id_v2 != "" && !self.checkForIllegalCharacters(string: secv_saled_id_v2) ){
                   self.secondrySaleIds.append(secv_saled_id_v2)
               }
        if(secv_saled_id_v3 != "" && !self.checkForIllegalCharacters(string: secv_saled_id_v3) ){
            self.secondrySaleIds.append(secv_saled_id_v3)
        }
        
        if(emailAdderss == "" ){
            if (firstName == "" || lastName == "" || phoneNumber == "" || salesId == ""){
                let banner = NotificationBanner(title: "Sorry", subtitle: "Please fill the required data!",  style: .danger)
                banner.show()
            }else{
                let banner = NotificationBanner(title: "Sorry", subtitle: "E-mail is required!",  style: .danger)
                banner.show()
            }
        }
            
        else if(!emailAdderss.isValidEmail()){
            let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid e-mail address!",  style: .danger)
            banner.show()
            
        }else if(firstName == "" ){
            if (emailAdderss == "" || lastName == "" || phoneNumber == "" || salesId == ""){
                let banner = NotificationBanner(title: "Sorry", subtitle: "Please fill the required data!",  style: .danger)
                banner.show()
            }else{
                let banner = NotificationBanner(title: "Sorry", subtitle: "First name is required!",  style: .danger)
                banner.show()
            }
        }
        else if(lastName == "" ){
            if (emailAdderss == "" || firstName == "" || phoneNumber == "" || salesId == ""){
                let banner = NotificationBanner(title: "Sorry", subtitle: "Please fill the required data!",  style: .danger)
                banner.show()
            }else{
                let banner = NotificationBanner(title: "Sorry", subtitle: "Last name is required!",  style: .danger)
                banner.show()
            }
        } else if(salesId == "" ){
            if (emailAdderss == "" || firstName == "" || phoneNumber == "" || lastName == ""){
                let banner = NotificationBanner(title: "Sorry", subtitle: "Please fill the required data!",  style: .danger)
                banner.show()
            }else{
                let banner = NotificationBanner(title: "Sorry", subtitle: "Sales id is required!",  style: .danger)
                banner.show()
            }
        }
            
        else if(salesId.containsWhiteSpace()){
            if (emailAdderss == "" || firstName == "" || phoneNumber == "" || lastName == ""){
                let banner = NotificationBanner(title: "Sorry", subtitle: "Please fill the required data!",  style: .danger)
                banner.show()
            }else{
                let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid sales ID! No spaces allowed!",  style: .danger)
                banner.show()
            }
        }
            
        else if(self.checkForIllegalCharacters(string: salesId)){
            if (emailAdderss == "" || firstName == "" || phoneNumber == "" || lastName == ""){
                let banner = NotificationBanner(title: "Sorry", subtitle: "Please fill the required data!",  style: .danger)
                banner.show()
            }else{
                let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid sales ID! Enter only alphanumeric value without spaces!",  style: .danger)
                banner.show()
            }
        }
            
        else if(phoneNumber == "" ){
            if (emailAdderss == "" || firstName == "" || salesId == "" || lastName == ""){
                let banner = NotificationBanner(title: "Sorry", subtitle: "Please fill the required data!",  style: .danger)
                banner.show()
            }else{
                let banner = NotificationBanner(title: "Sorry", subtitle: "Phone number is required!",  style: .danger)
                banner.show()
            }
        }else if(secv_saled_id_v1.containsWhiteSpace() || secv_saled_id_v2.containsWhiteSpace() || secv_saled_id_v3.containsWhiteSpace()){
             let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid secondry sales ID! No spaces allowed!",  style: .danger)
                           banner.show()
        }else if(salesId == secv_saled_id_v1 || salesId == secv_saled_id_v2 ||
            salesId == secv_saled_id_v3 ){
             let banner = NotificationBanner(title: "Sorry", subtitle: "Sales ID already exists!",  style: .danger)
                           banner.show()
        }else if(secv_saled_id_v1 != "" && (secv_saled_id_v1 == secv_saled_id_v2 || secv_saled_id_v1 == secv_saled_id_v3)){
            
                 let banner = NotificationBanner(title: "Sorry", subtitle: "Secondary sales ID already exists!",  style: .danger)
                               banner.show()
            
        }else if(secv_saled_id_v2 != "" && (secv_saled_id_v2 == secv_saled_id_v1 || secv_saled_id_v2 == secv_saled_id_v3)){
           
                 let banner = NotificationBanner(title: "Sorry", subtitle: "Secondary sales ID already exists!",  style: .danger)
                               banner.show()
            
        }else if(secv_saled_id_v3 != "" && (secv_saled_id_v3 == secv_saled_id_v1 || secv_saled_id_v3 == secv_saled_id_v2)){
           
                 let banner = NotificationBanner(title: "Sorry", subtitle: "Secondary sales ID already exists!",  style: .danger)
                               banner.show()
            
        }else if(self.checkForIllegalCharactersmobile(string: phoneNumber)){
           
        }
        
        else if(self.checkForIllegalCharacters(string: secv_saled_id_v1) || self.checkForIllegalCharacters(string: secv_saled_id_v2) || self.checkForIllegalCharacters(string: secv_saled_id_v3)){
            let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid secondry sales ID! Enter only alphanumeric value without spaces!",  style: .danger)
            banner.show()
        }
        else{
            
            let userJsonDatarest:[String : Any] = ["email":emailAdderss,"firstName":firstName,"lastName":lastName,"organizationId":Int(AppConstants.organizationid),"currentStatus":"pending","mobileNo":Int(phoneNumber),"userRole":userRoleValue,"storeId":storeid,"userType":"ORGANIZATION","salesIdList":secondrySaleIds,"salesId":salesId,"domain":APPURL.getOrganizationUri]
            
            print(JSON(userJsonDatarest))
            let json: JSON =  JSON(userJsonDatarest)
            activitiIndicator.startAnimating()
            RestClient.makeArryPostRequestUrl(url: APPURL.addUser,arryParam: json, delegate: self, requestFinished: #selector(self.requestFinishedgCreateUser), requestFailed: #selector(self.requestFailedSync), tag: 1)
        }
        
    }
    
    func checkForIllegalCharacters(string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~].{,}$")
            .union(.newlines)
            .union(.illegalCharacters)
            .union(.controlCharacters)
        
        if string.rangeOfCharacter(from: invalidCharacters) != nil {
            print ("Illegal characters detected in file name")
            // Raise an alert here
            return true
        } else {
            return false
        }}
    
    func checkForIllegalCharactersmobile(string: String) -> Bool {
             let invalidCharacters = CharacterSet(charactersIn: " !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~].{,}$")
                 .union(.newlines)
                 .union(.illegalCharacters)
                 .union(.controlCharacters)
             
             if string.rangeOfCharacter(from: invalidCharacters) != nil {
             
                 let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid mobile number! Enter only numeric value without spaces!",  style: .danger)
                                activitiIndicator.stopAnimating()
                                banner.show()
                 return true
             } else {
                 return false
             }}
    
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
                
                //                dropDownStore.cornerRadius = 8
                //                dropDownStore.topOffset = CGPoint(x: 0, y:(dropDownRole.anchorView?.plainView.bounds.height)!)
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
                if(jsonArry.count > 0){
                     storeButton.setTitle(jsonArry[0], for: .normal)
                }
               
                storeid = userObj["response"]["data"][0]["id"].intValue
                // dropDownStore.show()
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
                
                let alert = UIAlertController(title: "Success", message: "Your account is created successfully, please check your e-mail for verification link to activate your account.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    //  performSegue(withIdentifier: "rederectUserLogin", sender: nil)
                    self.performSegue(withIdentifier: "rederectUserLogin", sender: nil)
                }))
                
                
                self.present(alert, animated: true)
                
                
                
            }else{
                let message = userObj["response"]["message"].stringValue
                let banner = NotificationBanner(title: "Sorry", subtitle: message,  style: .danger)
                banner.show()
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

extension String {
    
    func containsWhiteSpace() -> Bool {
        
        // check if there's a range for a whitespace
        let range = self.rangeOfCharacter(from: .whitespacesAndNewlines)
        
        // returns false when there's no range for whitespace
        if let _ = range {
            return true
        } else {
            return false
        }
    }
    
    
}
