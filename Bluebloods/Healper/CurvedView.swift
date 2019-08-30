//
//  CurvedView.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/28/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit

class CurvedView: UIView {
    
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
        
        
        layer.cornerRadius = 6
        layer.masksToBounds =  false
    }
}

