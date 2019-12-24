//
//  OthersViewController.swift
//  BusStops
//
//  Created by Koh Sweesen on 8/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit
import SafariServices


protocol updateThemeAfterSwitchPressed {
        func handleOwnThemeColorChange()
}


let lightTheme = Theme(navBarColor: .white, navTitleTextColor: .black, toolBarColor: .white, toolBarIconTintAndTextColor: .gray,tableViewCellColor: .white,busTimingTextViewColor: UIColor.init(white: 0, alpha: 0.9),busTimingVCHeadView:.white,tableViewSeparatorColor: UIColor.init(red: 235/255, green: 235/255, blue: 242/255, alpha: 1),nearbyVCBackgroundColor:.white,settingsBackgroundColor: UIColor.init(red: 235/255, green: 235/255, blue: 242/255, alpha: 1),settingsHeaderTextColor:.lightGray, favouriteVCBackground: .white,favVCBackground:.white)

let darkTheme = Theme(navBarColor: .black, navTitleTextColor: .white, toolBarColor: .black, toolBarIconTintAndTextColor: .white,tableViewCellColor: UIColor.init(red: 0.15, green: 0.15, blue: 0.15, alpha: 1),busTimingTextViewColor: .clear,busTimingVCHeadView:UIColor.init(red: 42/255, green: 42/255, blue: 42/255, alpha:1),tableViewSeparatorColor:.darkGray,nearbyVCBackgroundColor:.darkGray,settingsBackgroundColor:.darkGray,settingsHeaderTextColor: .lightGray,favouriteVCBackground: .darkGray,favVCBackground: .white)

//UIColor.init(white: 0, alpha: 0.9)(lgith theme) 
//original bus timing text view color UIColor.init(white: 1, alpha: 0.1)(dark theme)

class OthersViewController: UITableViewController,updateThemeAfterSwitchPressed {
    
    func handleOwnThemeColorChange(){

        UINavigationBar.appearance().tintColor = .gray
        let attribute = [NSAttributedStringKey.foregroundColor:currentTheme.navTitleTextColor]
        self.navigationController?.navigationBar.titleTextAttributes = attribute
        self.navigationController?.navigationBar.largeTitleTextAttributes = attribute
        self.navigationController?.navigationBar.barTintColor = currentTheme.navBarColor
        self.tableView.backgroundColor = currentTheme.settingsBackgroundColor
        if currentTheme ==  darkTheme{
            self.tableView.separatorColor = .darkGray
        }
        self.tableView.reloadData()
        self.tabBarController?.viewWillAppear(true)
        print("This function is called")
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "cellID")
        self.tableView.backgroundColor = currentTheme.settingsBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.tableView.reloadData()
    }

    
 //   var settings: Array<String> = ["Dark Mode","Arrange Favourites by location","Tutorial","Show in Today Widget"]
    var settings: Array<String> = ["Dark Mode","Arrange Favourites by location","User Guide"]
    var moreInfo = ["Send us suggestions to improve the app!"]
   // var supportDeveloper = ["Donate","Go premium"]
    var supportDeveloper = [String]()


    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.barTintColor = currentTheme.navBarColor
        let attribute = [NSAttributedStringKey.foregroundColor:currentTheme.navTitleTextColor]
        self.navigationController?.navigationBar.titleTextAttributes = attribute
        self.navigationController?.navigationBar.largeTitleTextAttributes = attribute
    }
   
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return settings.count
        }else if section == 1{
            return moreInfo.count
        }else{
            return supportDeveloper.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as! SettingsTableViewCell
        cell.updateThemeDelegate = self
        cell.backgroundColor = currentTheme.tableViewCellColor
        
        if indexPath.section == 0{
            cell.mytext = settings[indexPath.row]
            if indexPath.row == 3{
                if let item = UserDefaults.init(suiteName: "group.com.Sweesen.myWidget")?.value(forKey: "widget1") as? NSArray{
                    cell.mytext = ""
                    cell.heightAnchor.constraint(equalToConstant: 120).isActive = true
                    cell.setupTodayWidgetCell(item: item)
                }
                
            }
            
        }else if indexPath.section == 1{
            cell.mytext = moreInfo[indexPath.row]
        }else{
            cell.mytext = supportDeveloper[indexPath.row]
        }
        
        cell.detailTextLabel?.text = "hesundieni"

        return cell
    }

    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UILabel()
        header.textColor = currentTheme.settingsHeaderTextColor
        header.heightAnchor.constraint(equalToConstant: 25).isActive = true
        header.font = UIFont.systemFont(ofSize: 12)
        header.insetsLayoutMarginsFromSafeArea = true
        header.backgroundColor = .clear
        
        if section == 0{
            header.text = ""
        }else if section == 1{
            header.text = "   MORE INFO"
        }else if section == 2{
           // header.text = "   SUPPORT THE DEVELOPER"
            header.text = ""
        }
        
        
        return header
    }
     
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 1{
            if moreInfo[indexPath.row] == "Send us suggestions to improve the app!"{
//                let newVC = SFSafariViewController(url: URL(string: "https://www.instagram.com/sweesen.koh/")!)
//                newVC.preferredBarTintColor = currentTheme.navBarColor
//                newVC.preferredControlTintColor = currentTheme.navTitleTextColor
//                present(newVC, animated: true, completion: nil)
                
                let email = "sweesenworkstation@gmail.com"
                
                if let url = URL(string: "mailto:\(email)") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                
            }
        }
        
        if indexPath.section == 0{
            if indexPath.row == 2{
                let flowlayout = UICollectionViewFlowLayout()
                flowlayout.scrollDirection = .horizontal
                let tutorialVC = TutorialCollectionViewController(collectionViewLayout: flowlayout)
                present(tutorialVC, animated: true, completion: nil)
            }
        }
        
        if indexPath.section == 0{
            if indexPath.row == 3{
                let BusVC = TodaySearchingBusVC(collectionViewLayout: UICollectionViewFlowLayout())
                self.navigationController?.pushViewController(BusVC, animated: true)
        }
        }
        
        self.tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}







