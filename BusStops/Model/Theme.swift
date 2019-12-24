//
//  Theme.swift
//  BusStops
//
//  Created by Koh Sweesen on 8/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit

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
    var settingsHeaderTextColor:UIColor
    var favouriteVCBackground: UIColor
    var favVCBackground:UIColor
    
    init?(navBarColor:UIColor,navTitleTextColor:UIColor,toolBarColor:UIColor,toolBarIconTintAndTextColor:UIColor,tableViewCellColor:UIColor,busTimingTextViewColor:UIColor,busTimingVCHeadView:UIColor,tableViewSeparatorColor:UIColor,nearbyVCBackgroundColor:UIColor,settingsBackgroundColor:UIColor,settingsHeaderTextColor:UIColor,favouriteVCBackground:UIColor,favVCBackground:UIColor){
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
        self.settingsHeaderTextColor = settingsHeaderTextColor
        self.favouriteVCBackground = favouriteVCBackground
        self.favVCBackground = favVCBackground
    }
    
}
