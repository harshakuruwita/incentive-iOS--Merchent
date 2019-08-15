//
//  FirstViewController.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/2/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit

class TimelineViewControler: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var filterbarLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        filterbarLogo.layer.cornerRadius = filterbarLogo.frame.height / 2
        filterbarLogo.clipsToBounds = true
    }

    
    ///////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
   
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.row < 2){
            return 138
        }else{
             return 170
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row < 2){
        let cell:DashbordPointsCell = tableView.dequeueReusableCell(withIdentifier: "DashbordPointsCell") as! DashbordPointsCell
        
        return cell
        }else{
            let cell:DashbordBonuASPCell = tableView.dequeueReusableCell(withIdentifier: "DashbordBonuASPCell") as! DashbordBonuASPCell
            
            return cell
        }
    }
    
    ///////////

}

