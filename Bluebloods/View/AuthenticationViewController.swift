//
//  AuthenticationViewController.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/9/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import MSAL

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var storeLogo: UIImageView!
    
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeLogo.layer.cornerRadius = storeLogo.frame.size.width/2
        storeLogo.clipsToBounds = true
        createGradientLayer()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }


 
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 28/255, green: 169/255, blue: 226/255, alpha: 1).cgColor, UIColor(red: 227/255, green: 183/255, blue: 195/255, alpha: 1).cgColor]
        self.gradientView.layer.addSublayer(gradientLayer)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
