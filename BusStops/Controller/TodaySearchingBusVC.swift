//
//  TodaySearchingBusVC.swift
//  BusStops
//
//  Created by Koh Sweesen on 14/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import Foundation
import UIKit

class TodaySearchingBusVC: BusStopsViewController{
    
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationController?.navigationBar.barTintColor = UIColor.cyan
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let individualBusStopVC = TodaySearchingBusMenuVC()
        individualBusStopVC.busStopCode = busStopsForSearch[indexPath.row].BusStopCode
        individualBusStopVC.navigationItem.title = "Choose Buses"
        individualBusStopVC.roadName = busStopsForSearch[indexPath.row].RoadName
        navigationItem.searchController?.isActive = false
        self.navigationController?.pushViewController(individualBusStopVC, animated: true)
    }
    
    override func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Choose Bus Stop"
        let attribute = [NSAttributedStringKey.foregroundColor:currentTheme.navTitleTextColor]
        navigationController?.navigationBar.largeTitleTextAttributes = attribute
        navigationController?.navigationBar.titleTextAttributes = attribute
        navigationController?.navigationBar.barTintColor = currentTheme.navBarColor
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        if currentTheme == darkTheme{
            searchController.searchBar.barStyle = .blackOpaque
            searchController.searchBar.keyboardAppearance = .dark
        }else if currentTheme == lightTheme{
            searchController.searchBar.barStyle = .default
            searchController.searchBar.keyboardAppearance = .light
        }
        
        searchController.searchBar.tintColor = currentTheme.navTitleTextColor
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
}
