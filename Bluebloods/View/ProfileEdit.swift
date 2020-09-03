//
//  ProfileEdit.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 3/19/20.
//  Copyright © 2020 Bluebloods. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import NotificationBannerSwift
import SwiftyJSON
import RealmSwift
import WSTagsField

class ProfileEdit: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var gradintView: UIView!
    var gradientLayer: CAGradientLayer!
    var secondrySaleIds :[Any] = []
    @IBOutlet weak var activitiIndicator: NVActivityIndicatorView!
    
    
    
    
    @IBOutlet weak var userNameTextFild: BorderdTextFild!
    @IBOutlet weak var mobileNumber: BorderdTextFild!
    
    @IBOutlet weak var sec_saled_id_3: BorderdTextFildkey!
    @IBOutlet weak var sec_saled_id_2: BorderdTextFildkey!
    @IBOutlet weak var sec_saled_id_1: BorderdTextFildkey!
    
    @IBOutlet weak var passwordTextFild: BorderdTextFild!
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientLayer()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
//        salseidTag.returnKeyType = .done
//        salseidTag.acceptTagOption = .space
//        salseidTag.placeholderAlwaysVisible = true
//        salseidTag.placeholder = "Press space to add"
        
        sec_saled_id_1.autocapitalizationType = .none
        sec_saled_id_2.autocapitalizationType = .none
        sec_saled_id_3.autocapitalizationType = .none
        
        
        mobileNumber.text = UserDefaults.standard.string(forKey: "mobilenumber")!
        userNameTextFild.text = UserDefaults.standard.string(forKey: "firstName")!
        passwordTextFild.text = UserDefaults.standard.string(forKey: "lastName")!
        
        guard let data = UserDefaults.standard.value(forKey: "salesIdArry") as? Data else { return }
        
        let json = JSON(data)
        if let items = json.array {
            for item in items {
                if let title = item.string {
                  //  salseidTag.addTag(title)
                    self.secondrySaleIds.append(title)
                }
            }
        }
        
       if let saleid_1 = json[0].string {
        sec_saled_id_1.text = saleid_1
        }
        if let saleid_2 = json[1].string {
        sec_saled_id_2.text = saleid_2
        }
        if let saleid_3 = json[2].string {
        sec_saled_id_3.text = saleid_3
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
    
    
    func checkForIllegalCharacters(string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: " !\"#$%&'()*+,/:;<=>?\\[\\\\\\]^`{|}~]{,}$")
            .union(.newlines)
            .union(.illegalCharacters)
            .union(.controlCharacters)
        
        if string.rangeOfCharacter(from: invalidCharacters) != nil {
        
            let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid secondry sales ID! Enter only alphanumeric value or email without spaces!",  style: .danger)
                           activitiIndicator.stopAnimating()
                           banner.show()
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
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.dismiss(animated: true)
        
        
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
    
    @IBAction func editUserTap(_ sender: Any) {
        
        let firstName = userNameTextFild.text!
        let lastName = passwordTextFild.text!
        let mobileNumbervalue = mobileNumber.text!
        let secv_saled_id_v1 = sec_saled_id_1.text!
        let secv_saled_id_v2 = sec_saled_id_2.text!
        let secv_saled_id_v3 = sec_saled_id_3.text!
        
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
        
        if(firstName == "" && lastName == "" && mobileNumbervalue==""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "First name or Last name or mobile number required!",  style: .danger)
            banner.show()
        }else if(self.checkForIllegalCharacters(string: secv_saled_id_v1) || self.checkForIllegalCharacters(string: secv_saled_id_v2) || self.checkForIllegalCharacters(string: secv_saled_id_v3)){
           
        }else if(secv_saled_id_v1 != "" && (secv_saled_id_v1 == secv_saled_id_v2 || secv_saled_id_v1 == secv_saled_id_v3)){
            
                 let banner = NotificationBanner(title: "Sorry", subtitle: "Secondary sales ID already exists!",  style: .danger)
                               banner.show()
            
        }else if(secv_saled_id_v2 != "" && (secv_saled_id_v2 == secv_saled_id_v1 || secv_saled_id_v2 == secv_saled_id_v3)){
           
                 let banner = NotificationBanner(title: "Sorry", subtitle: "Secondary sales ID already exists!",  style: .danger)
                               banner.show()
            
        }else if(secv_saled_id_v3 != "" && (secv_saled_id_v3 == secv_saled_id_v1 || secv_saled_id_v3 == secv_saled_id_v2)){
           
                 let banner = NotificationBanner(title: "Sorry", subtitle: "Secondary sales ID already exists!",  style: .danger)
                               banner.show()
            
        }else if(self.checkForIllegalCharactersmobile(string: mobileNumbervalue)){
           
        }
            
        else{
            
            activitiIndicator.startAnimating()
            
            let json: JSON =  ["firstName": firstName, "lastName": lastName, "mobileNo":mobileNumbervalue, "salesIdList":secondrySaleIds]
            
            print(json)
            
            RestClient.makeArryPostRequestWithToken(url: APPURL.editUserProfile,arryParam: json, delegate: self, requestFinished: #selector(self.requestFinishedSync), requestFailed: #selector(self.requestFailedSync), tag: 1)
            
        }
        
        
        
        
        
    }
    
    @objc func requestFinishedSync(response:ResponseSwift){
        
        do {
            let userObj = JSON(response.responseObject!)
            
            print("Response -\(userObj)")
            if(userObj["response"]["code"].int == 200){
                
                let firstName = userNameTextFild.text!
                let lastName = passwordTextFild.text!
                let mobileNumbervalue = mobileNumber.text!
                
                let banner = NotificationBanner(title: "Succes", subtitle: "Profile updated successfully.",  style: .success)
                activitiIndicator.stopAnimating()
                banner.show()
                
                
                if(firstName != "" ){
                    
                    UserDefaults.standard.set(firstName, forKey: "firstName")
                }
                if(lastName != "" ){
                    UserDefaults.standard.set(lastName, forKey: "lastName")
                }
                if(mobileNumbervalue != "" ){
                    UserDefaults.standard.set(mobileNumbervalue, forKey: "mobilenumber")
                }
                
                
                let scJson = JSON(secondrySaleIds)
                guard let rawData = try? scJson.rawData() else { return }
                UserDefaults.standard.setValue(rawData, forKey: "salesIdArry")
                
                
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
                
                
                self.dismiss(animated: true)
                
                
            }else if(userObj["response"]["code"].int == 400){
                let message = userObj["response"]["message"].stringValue
                let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid update!",  style: .danger)
                activitiIndicator.stopAnimating()
                banner.show()
            }else{
                 let message = userObj["response"]["message"].stringValue
                let banner = NotificationBanner(title: "Sorry", subtitle: message,  style: .danger)
                activitiIndicator.stopAnimating()
                banner.show()
            }
            
        } catch let error {
             let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid update!",  style: .danger)
                           activitiIndicator.stopAnimating()
                           banner.show()
        }
        
    }
    
    @objc func requestFailedSync(response:ResponseSwift){
        let banner = NotificationBanner(title: "Sorry", subtitle: "Invalid update!",  style: .danger)
        activitiIndicator.stopAnimating()
        banner.show()
        
    }
    
    
}
