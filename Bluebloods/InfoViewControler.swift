//
//  SecondViewController.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/2/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import WebKit

class InfoViewControler: UIViewController , WKNavigationDelegate, WKUIDelegate {
  
    @IBOutlet weak var infoWebView: WKWebView!
    @IBOutlet weak var filterBarLogo: UIImageView!
    
    @IBOutlet weak var navigationBarUiView: UIView!
    
    @IBOutlet weak var gradianentView: UIView!
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterBarLogo.layer.cornerRadius = filterBarLogo.frame.height / 2
        filterBarLogo.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        let tncURL =  "https://bluebloods.nz/prizes/monthly/"
        infoWebView.isUserInteractionEnabled = true
        infoWebView.navigationDelegate = self
        infoWebView.load(URLRequest(url: URL(string: tncURL)!))
        colourSwitcher()
    
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("1")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       print("2")
    }
    
    
    func colourSwitcher() {
        navigationBarUiView.layer.backgroundColor = UIColor().colour1()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor().colour2(), UIColor().colour1()]
        self.gradianentView.layer.addSublayer(gradientLayer)
    }
}

