//
//  SecondViewController.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/2/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import WebKit
import DropDown
import RealmSwift
import RealmSwift

class InfoViewControler: UIViewController , WKNavigationDelegate, WKUIDelegate {
  
    @IBOutlet weak var infoWebView: WKWebView!
    @IBOutlet weak var filterBarLogo: UIImageView!
    
    @IBOutlet weak var navigationBarUiView: UIView!
    
    @IBOutlet weak var incentiveLbl: UILabel!
    @IBOutlet weak var gradianentView: UIView!
    var gradientLayer: CAGradientLayer!
    
    var incentives : Results<Incentive>?
    let incentivePicker = DropDown()
    var incentiveArry:[String] = []
    var incentiveidArry:[Int] = []
    var incentiveUri:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterBarLogo.layer.cornerRadius = filterBarLogo.frame.height / 2
        filterBarLogo.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        loadIncentive()
        if(incentiveUri.count > 0){
        let tncURL =  incentiveUri[0]
        
        print(incentiveUri)
        infoWebView.isUserInteractionEnabled = true
        infoWebView.navigationDelegate = self
        infoWebView.load(URLRequest(url: URL(string: tncURL)!))
        }
        colourSwitcher()
        
        
        incentivePicker.selectionAction = { [unowned self] (index: Int, item: String) in
                   
            self.incentiveLbl.text = self.incentiveArry[index]
            
            ///
            if(self.incentiveUri.count > 0){
                let tncURL =  self.incentiveUri[index]
            
                print(tncURL)
                self.infoWebView.isUserInteractionEnabled = true
                self.infoWebView.navigationDelegate = self
                self.infoWebView.load(URLRequest(url: URL(string: tncURL)!))
            }
            ///
            
                   
               }
    
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
    
    func loadIncentive(){
           incentives  = try! Realm().objects(Incentive.self)
                  
                  for allIncentives in incentives!  {
                      print(allIncentives.incentiveName)
                      incentiveArry.append(allIncentives.incentiveName)
                      incentiveidArry.append(allIncentives.incentiveId)
                    incentiveUri.append(allIncentives.url)
                  }
           
           incentiveLbl.text = incentiveArry[0]
           
       }
    
    @IBAction func selectIncentive(sender: AnyObject) {
             
          incentivePicker.anchorView = incentiveLbl
         incentivePicker.dataSource = incentiveArry
             incentivePicker.topOffset = CGPoint(x: 0, y:-(incentivePicker.anchorView?.plainView.bounds.height)!)
             incentivePicker.show()
          }
}

