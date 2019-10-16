//
//  AuthenticationViewController.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/9/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit


class AuthenticationViewController: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var storeLogo: UIImageView!
    
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
    }


 
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 31/255, green: 145/255, blue: 135/255, alpha: 1).cgColor, UIColor(red: 174/255, green: 203/255, blue: 191/255, alpha: 1).cgColor]
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
