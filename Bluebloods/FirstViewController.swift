//
//  FirstViewController.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/2/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import RealmSwift
import RealmSwift
import DropDown

class TimelineViewControler: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var filterbarLogo: UIImageView!
    @IBOutlet weak var navigationBarUiView: UIView!
    @IBOutlet weak var incentiveLbl: UILabel!
    
    @IBOutlet weak var recurungNameLbl: UILabel!
    
    
    @IBOutlet weak var timePeriodLbl: UILabel!
    
    
    @IBOutlet weak var filterbarUIView: UIView!
    var gradientLayer: CAGradientLayer!
    var incentives : Results<Incentive>?
    var Recurrings : Results<Recurring>?
    var TimePeriodss : Results<TimePeriods>?
    let incentivePicker = DropDown()
    let recuringPicker = DropDown()
    let timePeriodPicker = DropDown()
    var incentiveArry:[String] = []
    var incentiveidArry:[Int] = []
    
    var recuringidArry:[Int] = []
    var recuringTypeArry:[String] = []
    var recuringNameArry:[String] = []
    var selectedincentiveId = 0
    var selectedRecuringId = 0
    
    var timePeriodArry:[String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        filterbarLogo.layer.cornerRadius = filterbarLogo.frame.height / 2
        filterbarLogo.clipsToBounds = true
        colourSwitcher()
        
       
       loadIncentive()
        
        
        
        
        
        
        incentivePicker.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.selectedincentiveId = (self.incentiveidArry[index])
           
            self.incentiveLbl.text = self.incentiveArry[index]
            self.loadRecuring()
        }
        
        
        recuringPicker.selectionAction = { [unowned self] (index: Int, item: String) in
                   
                   self.selectedRecuringId = (self.recuringidArry[index])
                   self.recurungNameLbl.text = self.recuringNameArry[index]
                   self.loadRecuring()
               }
        
       
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
    
    func colourSwitcher() {
        navigationBarUiView.layer.backgroundColor = UIColor().colour1()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor().colour2(), UIColor().colour1()]
        self.filterbarUIView.layer.addSublayer(gradientLayer)
    }
    
    @IBAction func selectIncentive(sender: AnyObject) {
           
        incentivePicker.anchorView = incentiveLbl
       incentivePicker.dataSource = incentiveArry
           incentivePicker.topOffset = CGPoint(x: 0, y:-(incentivePicker.anchorView?.plainView.bounds.height)!)
           incentivePicker.show()
        }

    @IBAction func selectRecuringe(sender: AnyObject) {
              
           recuringPicker.anchorView = recurungNameLbl
          recuringPicker.dataSource = recuringNameArry
              incentivePicker.topOffset = CGPoint(x: 0, y:-(recuringPicker.anchorView?.plainView.bounds.height)!)
              recuringPicker.show()
           }
    
    @IBAction func pickTimePeriod(sender: AnyObject) {
                
             timePeriodPicker.anchorView = timePeriodLbl
            timePeriodPicker.dataSource = timePeriodArry
                timePeriodPicker.topOffset = CGPoint(x: 0, y:-(timePeriodPicker.anchorView?.plainView.bounds.height)!)
                timePeriodPicker.show()
             }
    
    func loadIncentive(){
        incentives  = try! Realm().objects(Incentive.self)
          
               for allIncentives in incentives!  {
                   print(allIncentives.incentiveName)
                   incentiveArry.append(allIncentives.incentiveName)
                   incentiveidArry.append(allIncentives.incentiveId)
               }
        selectedincentiveId = self.incentiveidArry[0]
        incentiveLbl.text = incentiveArry[0]
        loadRecuring()
    }
    
    
    
    func loadRecuring(){
        
        Recurrings  = try! Realm().objects(Recurring.self).filter("incentiveId = \(self.selectedincentiveId)")
        recuringidArry.removeAll()
        recuringTypeArry.removeAll()
        recuringNameArry.removeAll()
        for allRecurrings in Recurrings!  {
                   recuringidArry.append(allRecurrings.recuringid)
                   recuringTypeArry.append(allRecurrings.RecurringType)
                   recuringNameArry.append(allRecurrings.recuringname)
                   
               }
        
        if(recuringNameArry.count > 0){
        recurungNameLbl.text = recuringNameArry[0]
            selectedRecuringId = recuringidArry[0]
        }
        loadTimePeriod()
    }
    
    
    
    func loadTimePeriod(){
        
        TimePeriodss  = try! Realm().objects(TimePeriods.self).filter("recuringid = \(self.selectedRecuringId)")
        timePeriodArry.removeAll()
      
        for allTimePeriodss in TimePeriodss!  {
                   timePeriodArry.append(allTimePeriodss.periodName)
                 
                   
               }
        
         timePeriodLbl.text = timePeriodArry[0]
    }

}

