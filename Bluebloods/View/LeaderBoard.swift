//
//  LeaderBoard.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/7/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import AAViewAnimator

class LeaderBoard: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var filterBarLogoLB: UIImageView!
    
    @IBOutlet weak var storeUiView: UIView!
    @IBOutlet weak var individualUiView: UIView!
    
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var individualButton: UIButton!
    

    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    let storeCellReuseIdentifier = "LeaderBordStoreCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterBarLogoLB.layer.cornerRadius = filterBarLogoLB.frame.height / 2
        filterBarLogoLB.clipsToBounds = true
        // Do any additional setup after loading the view.
        
        storeButton.backgroundColor = .clear
        storeButton.layer.cornerRadius = 18
        storeButton.layer.borderWidth = 1.5
        storeButton.layer.borderColor = UIColor(red: 28/255, green: 169/255, blue: 226/255, alpha: 1).cgColor
        
    }
    ///////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorStyle = .none
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LeaderBordStoreCell = tableView.dequeueReusableCell(withIdentifier: "LeaderBordStoreCell") as! LeaderBordStoreCell
      
        return cell
        }
    
    ///////////
   
    
    @IBAction func storeButtonClick(sender: AnyObject) {
        
         individualButton.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        
        storeButton.backgroundColor = .clear
        storeButton.layer.cornerRadius = 18
        storeButton.layer.borderWidth = 1.5
        storeButton.layer.borderColor = UIColor(red: 28/255, green: 169/255, blue: 226/255, alpha: 1).cgColor
        self.storeUiView.isHidden = false
        self.individualUiView.isHidden = true
    
        
        
    }
    
    @IBAction func individualButtonClick(sender: AnyObject) {
        
        storeButton.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        
        individualButton.backgroundColor = .clear
        individualButton.layer.cornerRadius = 18
        individualButton.layer.borderWidth = 1.5
        individualButton.layer.borderColor = UIColor(red: 28/255, green: 169/255, blue: 226/255, alpha: 1).cgColor
         self.individualUiView.isHidden = false
        self.storeUiView.isHidden = true
      
        
        
       
        
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
