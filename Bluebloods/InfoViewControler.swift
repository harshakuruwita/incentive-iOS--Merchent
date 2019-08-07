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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterBarLogo.layer.cornerRadius = filterBarLogo.frame.height / 2
        filterBarLogo.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        let tncURL =  "https://bluebloods.nz/prizes/monthly/"
        infoWebView.isUserInteractionEnabled = true
        infoWebView.navigationDelegate = self
        infoWebView.load(URLRequest(url: URL(string: tncURL)!))
    
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("1")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       print("2")
    }
}

