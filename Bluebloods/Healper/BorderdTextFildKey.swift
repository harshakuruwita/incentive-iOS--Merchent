//
//  BorderdTextFildKey.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 4/3/20.
//  Copyright © 2020 Bluebloods. All rights reserved.
//

import UIKit

class BorderdTextFildkey: UITextView {

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        
     //   leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.height))
    //   leftViewMode = .always
       layer.cornerRadius = 18.0
       layer.masksToBounds = true
       layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 1.5
        
       
    }
    
    
//  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//      let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//      return newText.count <= 4
//    }
}
