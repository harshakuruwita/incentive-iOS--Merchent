//
//  ContactUs.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/7/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import SwiftyJSON
import NVActivityIndicatorView

class ContactUs: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var senderEmail: UITextField!
    @IBOutlet weak var messageTextFild: UITextView!
    @IBOutlet weak var navigationBarUiView: UIView!
    @IBOutlet weak var titleCount: UILabel!
    
    @IBOutlet weak var messageCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        senderEmail.layer.cornerRadius = 25.0
        senderEmail.layer.borderWidth = 0.7
        senderEmail.layer.borderColor = UIColor.gray.cgColor
        messageTextFild.delegate = self
         self.updateCharacterCount()
        senderEmail.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: senderEmail.frame.height))
        senderEmail.leftViewMode = .always
        
      
        // Do any additional setup after loading the view.
        
        messageTextFild.layer.cornerRadius = 18.0
        messageTextFild.layer.borderWidth = 0.7
        messageTextFild.layer.borderColor = UIColor.gray.cgColor
        colourSwitcher()
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func colourSwitcher() {
        navigationBarUiView.layer.backgroundColor = UIColor().colour1()
        

    }
    
    @IBAction func contactUsTap(_ sender: Any) {
        var messageHeadder = senderEmail.text!
        let message = messageTextFild.text!
        
        
        
        if(messageHeadder == ""){
            
            let banner = NotificationBanner(title: "Sorry", subtitle: "Please enter essage title ",  style: .danger)
            banner.show()
            
        }else if(message == ""){
            let banner = NotificationBanner(title: "Sorry", subtitle: "Please enter essage ",  style: .danger)
                       banner.show()
            
        }else{
            let json: JSON =  ["tittle": messageHeadder, "message": message]
                 
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
             RestClient.makeArryPostRequestWithToken(url: APPURL.contactsUs,arryParam: json, delegate: self, requestFinished: #selector(self.requestFinishedSync), requestFailed: #selector(self.requestFailedSync), tag: 1)
        }
        
    }
    

    
    
    func updateCharacterCount() {
        
        let summaryCount = self.senderEmail.text?.count
        let descriptionCount = self.messageTextFild.text.count

        self.messageCount.text = "\((0) + descriptionCount)/300"

        //self.descriptionCountLbl.text = "\((0) + descriptionCount)/500"
     }

     func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
     }


     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(textView == messageTextFild){
           return textView.text.count +  (text.count - range.length) <= 299
        }
        return false
     }
    
    @objc func requestFinishedSync(response:ResponseSwift){
           
           do {
            activityIndicator.stopAnimating()
               let userObj = JSON(response.responseObject!)
            let succsussMessage = userObj["response"]["success"].boolValue
            
            if(succsussMessage){
                let banner = NotificationBanner(title: "Success", subtitle: "Email has sent ",  style: .success)
                banner.show()
            }else{
                let banner = NotificationBanner(title: "Sorry", subtitle: "System error",  style: .danger)
                banner.show()
            }
            } catch let error {
                     print(error)
                 }
                 
             }
    
    @objc func requestFailedSync(response:ResponseSwift){
           activityIndicator.stopAnimating()
       }

}
