//
//  UserRegistationCreateUser.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 9/5/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit

class UserRegistationCreateUser: UIViewController {


    @IBOutlet weak var gradientView: UIView!
    var gradientLayer: CAGradientLayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       createGradientLayer()

        // Do any additional setup after loading the view.
    }
    

    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 28/255, green: 169/255, blue: 226/255, alpha: 1).cgColor, UIColor(red: 227/255, green: 183/255, blue: 195/255, alpha: 1).cgColor]
       self.gradientView.layer.addSublayer(gradientLayer)
        
        
        
        
    }

}
