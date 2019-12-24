//
//  Theme.swift
//  busTodayWidget
//
//  Created by Koh Sweesen on 10/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit




let lightTheme = Theme(navBarColor: .white, navTitleTextColor: .black, toolBarColor: .white, toolBarIconTintAndTextColor: .gray,tableViewCellColor: .white,busTimingTextViewColor: .black,busTimingVCHeadView:.white,tableViewSeparatorColor: .lightGray,nearbyVCBackgroundColor:.white,settingsBackgroundColor: UIColor.init(red: 235/255, green: 235/255, blue: 242/255, alpha: 1))

let darkTheme = Theme(navBarColor: .black, navTitleTextColor: .white, toolBarColor: .black, toolBarIconTintAndTextColor: .white,tableViewCellColor: UIColor.init(red: 0.15, green: 0.15, blue: 0.15, alpha: 1),busTimingTextViewColor: UIColor.init(white: 1, alpha: 0.1),busTimingVCHeadView:UIColor.init(white: 1, alpha: 0.1),tableViewSeparatorColor:.darkGray,nearbyVCBackgroundColor:.darkGray,settingsBackgroundColor:.darkGray)

let currentTheme:Theme = lightTheme!


class Theme: NSObject {
    
    var navBarColor: UIColor
    var navTitleTextColor:UIColor
    var toolBarColor: UIColor
    var toolBarIconTintAndTextColor:UIColor
    var tableViewCellColor:UIColor
    var busTimingTextViewColor:UIColor
    var busTimingVCHeadView:UIColor
    var tableViewSeparatorColor:UIColor
    var nearbyVCBackgroundColor:UIColor
    var settingsBackgroundColor:UIColor
    
    init?(navBarColor:UIColor,navTitleTextColor:UIColor,toolBarColor:UIColor,toolBarIconTintAndTextColor:UIColor,tableViewCellColor:UIColor,busTimingTextViewColor:UIColor,busTimingVCHeadView:UIColor,tableViewSeparatorColor:UIColor,nearbyVCBackgroundColor:UIColor,settingsBackgroundColor:UIColor){
        self.navBarColor = navBarColor
        self.navTitleTextColor = navTitleTextColor
        self.toolBarColor = toolBarColor
        self.toolBarIconTintAndTextColor = toolBarIconTintAndTextColor
        self.tableViewCellColor = tableViewCellColor
        self.busTimingTextViewColor = busTimingTextViewColor
        self.busTimingVCHeadView = busTimingVCHeadView
        self.tableViewSeparatorColor = tableViewSeparatorColor
        self.nearbyVCBackgroundColor = nearbyVCBackgroundColor
        self.settingsBackgroundColor = settingsBackgroundColor
    }
    
}

