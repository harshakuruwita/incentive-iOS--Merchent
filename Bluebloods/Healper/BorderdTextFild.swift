//
//  BorderdTextFild.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 9/5/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit

class BorderdTextFild: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.height))
       leftViewMode = .always
       layer.cornerRadius = 22.0
       layer.masksToBounds = true
       layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 1.5
        
       
    }

}
