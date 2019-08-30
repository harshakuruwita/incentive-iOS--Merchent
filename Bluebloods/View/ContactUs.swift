//
//  ContactUs.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/7/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit

class ContactUs: UIViewController {

    @IBOutlet weak var senderEmail: UITextField!
    @IBOutlet weak var messageTextFild: UITextView!
    @IBOutlet weak var navigationBarUiView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        senderEmail.layer.cornerRadius = 25.0
        senderEmail.layer.borderWidth = 0.7
        senderEmail.layer.borderColor = UIColor.gray.cgColor
        
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

}
