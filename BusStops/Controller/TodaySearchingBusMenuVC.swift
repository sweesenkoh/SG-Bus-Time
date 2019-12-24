//
//  TodaySearchingBusMenuVC.swift
//  BusStops
//
//  Created by Koh Sweesen on 14/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import Foundation
import UIKit

class TodaySearchingBusMenuVC:ViewController{
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //        self.navigationController?.hero.isEnabled = true
        
        setupTableView()
        self.tableView.backgroundColor = currentTheme.tableViewCellColor
        self.tabBarController?.tabBar.isHidden = true
        findingBusesForThisBusStop()
        tableView.register(tableViewCustomCell.self, forCellReuseIdentifier: "cell")
        setupIndicatorView()
        self.view.backgroundColor = currentTheme.tableViewCellColor
        
        self.tableView.separatorColor = currentTheme.tableViewSeparatorColor
        self.tableView.separatorInset = .init(top: 0, left: 5, bottom: 0, right: 5)
        self.tableView.allowsMultipleSelection = true
        setupnavigationBarItem()
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCustomCell
        cell.busTimingBlackView.backgroundColor = .clear
        cell.busNumberLabel.text = sortedFilteredBusRoute[indexPath.row].ServiceNo
        cell.cellBusStopCode = busStopCode
        cell.busTimingText.isUserInteractionEnabled = false
        cell.secondBusTimingText.isUserInteractionEnabled = false
        cell.thirdBusTimingText.isUserInteractionEnabled = false
        
        
        return cell
    }
    
    
    var busesToSave = [String]()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if busesToSave.count > 6{
            self.tableView.cellForRow(at: indexPath)?.isSelected = false
        }else{
            busesToSave.append(sortedFilteredBusRoute[indexPath.row].ServiceNo!)
            print(busesToSave)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let temporaryBuses = busesToSave
        var returningThis = [String]()
        
        for item in temporaryBuses{
            if item != sortedFilteredBusRoute[indexPath.row].ServiceNo!{
                returningThis.append(item)
            }
        }
        
        busesToSave = returningThis
        print(busesToSave)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func setupnavigationBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleButton))
    }
    
    
    @objc func handleButton(){
        
        busesToSave.append(self.busStopCode!)
        UserDefaults.init(suiteName: "group.com.Sweesen.myWidget")?.setValue(busesToSave, forKey: "widget1")
        busesToSave.remove(at: busesToSave.count-1)
        let item = UserDefaults.init(suiteName: "group.com.Sweesen.myWidget")?.value(forKey: "widget1") as! NSArray
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
}

