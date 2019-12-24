//
//  CustomTabBarController.swift
//  BusStops
//
//  Created by Koh Sweesen on 27/5/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit

let launchView = UIView()

class CustomTabBarController: UITabBarController {


    override func viewDidLoad() {
        super.viewDidLoad()

//        viewControllers = [setupFavouriteVC(),setupBusStopsVC(),OthersViewController()]
        viewControllers = [setupOthersVC()]
       // setupLaunchView()
    }
    
    func setupLaunchView(){
        self.view.addSubview(launchView)
        launchView.frame = self.view.frame
        launchView.backgroundColor = .green
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBar.barTintColor = currentTheme.toolBarColor
        UITabBar.appearance().tintColor = UIColor.lightGray
        var newViewControllers = [UIViewController]()
        if viewControllers?.count == 3{
            newViewControllers = [viewControllers![2]]
            newViewControllers.insert(setupBusVC(), at: 0)
            newViewControllers.insert(setupBusStopsVC(), at: 0)
            newViewControllers.insert(setupFavouriteVC(), at: 0)
            viewControllers = newViewControllers
        }else{
            viewControllers = [setupFavouriteVC(),setupBusStopsVC(),setupBusVC(),setupOthersVC()]
        }
        
        reloadOtherVCViewAfterThemeChange()
        self.tabBar.isTranslucent = true
        
    }
    
    
    func reloadOtherVCViewAfterThemeChange(){
        viewControllers![2].tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: currentTheme.toolBarIconTintAndTextColor], for: .selected)
    }
    
    
    func setupBusStopsVC() -> UINavigationController{
        let layout = UICollectionViewFlowLayout()
        let busStopNavController = UINavigationController(rootViewController: BusStopsViewController(collectionViewLayout: layout))
        busStopNavController.tabBarItem.image = UIImage(named: "singaporeEmpty")
        let filledImage = UIImage(named: "singaporeFilled")
        busStopNavController.tabBarItem.selectedImage = filledImage
        busStopNavController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: currentTheme.toolBarIconTintAndTextColor], for: .selected)
        busStopNavController.title = "Nearby"
        return busStopNavController
    }
    
    func setupFavouriteVC() -> UINavigationController{
        let layout2 = UICollectionViewFlowLayout()
        layout2.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 500)
        let favNaVVC = UINavigationController(rootViewController: FavouriteViewController(collectionViewLayout: layout2))
        favNaVVC.tabBarItem.image = UIImage(named: "bookmarkEmpty")
        favNaVVC.tabBarItem.selectedImage = UIImage(named: "bookmarkFilled")
        favNaVVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: currentTheme.toolBarIconTintAndTextColor], for: .selected)
        favNaVVC.title = "Favourite"
        
        
        return favNaVVC
    }

    func setupOthersVC() -> UINavigationController{
        
        let otherVC2 = OthersViewController(style: .grouped)
        let otherVC = UINavigationController(rootViewController: otherVC2)
        otherVC.tabBarItem.image = UIImage(named: "settingsIcon")
        otherVC.tabBarItem.selectedImage = UIImage(named: "settingsIconFilled")
        otherVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: currentTheme.toolBarIconTintAndTextColor], for: .selected)
        otherVC.title = "Settings"
        return otherVC
        
        
    }
    
    func setupBusVC() -> UINavigationController{
        
        let VC = UINavigationController(rootViewController: BusRoutesChoosingVC())
        VC.title = "Bus"
        VC.tabBarItem.image = UIImage(named: "busIconEmpty")
        VC.tabBarItem.selectedImage = UIImage(named: "busIconFilled")?.withRenderingMode(.alwaysTemplate)
    VC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: currentTheme.toolBarIconTintAndTextColor], for: .selected)
        return VC
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

 
}
