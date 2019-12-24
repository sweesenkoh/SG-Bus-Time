//
//  SettingsTableViewCell.swift
//  BusStops
//
//  Created by Koh Sweesen on 14/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import Foundation
import UIKit


class SettingsTableViewCell:UITableViewCell{
    
    var updateThemeDelegate:updateThemeAfterSwitchPressed?

    
    var mytext:String = "" {
        didSet{
            self.textLabel?.text = mytext
            self.textLabel?.textColor = currentTheme.navTitleTextColor
            if mytext == "Dark Mode"{
                self.setupThemeSwitch()
            }
            if mytext == "Arrange Favourites by location"{
                self.setupFavouriteSwitch()
            }
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    let busesTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    func setupBusesTextView(item:NSArray){
        busesTextView.removeFromSuperview()
        busesTextView.textColor = currentTheme.navTitleTextColor
        busesTextView.backgroundColor = currentTheme.tableViewCellColor
        self.addSubview(busesTextView)
        busesTextView.setupConstraint(TopAnchorTo: self.busStopNameLabel.bottomAnchor, TopPadding: 0, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 20, RightAnchorTo: self.rightAnchor, RightPadding: -16, ViewWidth: nil, ViewHeight: 25, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        
        
        var stringToPresent:String = ""
        var constant:Int = 0
        for it in item{
            let string = it as! String
            if string.count != 5{
                if constant == item.count-2{
                    stringToPresent = stringToPresent + string
                }else{
                    stringToPresent = stringToPresent + string + ", "
                }
            }
            constant += 1
        }
        busesTextView.text = stringToPresent
    }
    
    let busStopNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    func setupBusStopNameLabel(item:NSArray){
        busStopNameLabel.removeFromSuperview()
        busStopNameLabel.textColor = currentTheme.navTitleTextColor
        busStopNameLabel.backgroundColor = currentTheme.tableViewCellColor
        self.addSubview(busStopNameLabel)
        busStopNameLabel.setupConstraint(TopAnchorTo: self.line.bottomAnchor, TopPadding: 5, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 20, RightAnchorTo: self.rightAnchor, RightPadding: -16, ViewWidth: nil, ViewHeight: 25, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        
        let busCode = item.lastObject as? String
        
        for item in globalBusStopsVariable{
            if item.BusStopCode == busCode{
                busStopNameLabel.text = item.Description
            }
        }
        
    }
    
    let title = UILabel()
    
    func setupWidgetTitle(){
        title.removeFromSuperview()
        self.addSubview(title)
        title.text = "Today Widget 1"
        title.textColor = currentTheme.navTitleTextColor
        title.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 16, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 20, RightAnchorTo: self.rightAnchor, RightPadding: 16, ViewWidth: nil, ViewHeight: 20, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    let line = UIView()
    
    func setupLine(){
        line.removeFromSuperview()
        self.addSubview(line)
        line.backgroundColor = currentTheme.tableViewSeparatorColor
        line.setupConstraint(TopAnchorTo: self.title.bottomAnchor, TopPadding: 16, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 16, RightAnchorTo: self.rightAnchor, RightPadding: 0, ViewWidth: nil, ViewHeight: 0.3, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    func setupTodayWidgetCell(item:NSArray){
        
        setupWidgetTitle()
        setupLine()
        setupBusStopNameLabel(item: item)
        setupBusesTextView(item: item)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let themeSwitch = UISwitch()
    
    func setupThemeSwitch(){
        themeSwitch.onTintColor = .lightGray
        themeSwitch.addTarget(self, action: #selector(handleThemeSwitch), for: .valueChanged)
        if currentTheme == darkTheme{
            themeSwitch.isOn = true
        }else{
            themeSwitch.isOn = false
        }
        self.addSubview(themeSwitch)
        themeSwitch.translatesAutoresizingMaskIntoConstraints = false
        themeSwitch.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 8, BottomAnchorTo: self.bottomAnchor, BottomPadding: -8, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.rightAnchor, RightPadding: -16, ViewWidth: 40, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    
    @objc func handleThemeSwitch(){
        
        if self.themeSwitch.isOn == true{
            currentTheme = darkTheme!
            UIApplication.shared.statusBarStyle = .lightContent
            self.removeFromSuperview()
            UserDefaults.init().set(true, forKey: Keys.themeSwitchKey.rawValue)
            updateThemeDelegate?.handleOwnThemeColorChange()
        }
        
        if self.themeSwitch.isOn == false{
            currentTheme = lightTheme!
            UIApplication.shared.statusBarStyle = .default
            self.removeFromSuperview()
            UserDefaults.init().set(false, forKey: Keys.themeSwitchKey.rawValue)
            updateThemeDelegate?.handleOwnThemeColorChange()
            
        }
        
        
    }
    
    let favouriteSwitch = UISwitch()
    
    func setupFavouriteSwitch(){
        favouriteSwitch.onTintColor = .lightGray
        favouriteSwitch.addTarget(self, action: #selector(handleFavouriteSwitch), for: .valueChanged)

        favouriteSwitch.isOn = shouldSortBusStopsByLocationInFavourtie

        self.addSubview(favouriteSwitch)
        favouriteSwitch.translatesAutoresizingMaskIntoConstraints = false
        favouriteSwitch.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 8, BottomAnchorTo: self.bottomAnchor, BottomPadding: -8, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.rightAnchor, RightPadding: -16, ViewWidth: 40, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    @objc func handleFavouriteSwitch(){
        
        
        if favouriteSwitch.isOn == true{
            UserDefaults.init().set(true, forKey: Keys.shouldSortBusStopByLocationInFavouriteKey.rawValue)
            shouldSortBusStopsByLocationInFavourtie = true
        
        }else{
            UserDefaults.init().set(false, forKey: Keys.shouldSortBusStopByLocationInFavouriteKey.rawValue)
            
            shouldSortBusStopsByLocationInFavourtie = false
        }
        
        
    }
    
    
}
