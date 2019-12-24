

//
//  AppDelegate.swift
//  BusStops
//
//  Created by Koh Sweesen on 23/5/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMobileAds




var currentTheme:Theme = darkTheme!
var isLaunchedBefore = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        GADMobileAds.configure(withApplicationID: GADMobileAdsAPIKey)
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            isLaunchedBefore = false
            let busesToSave = [7,01112]
            UserDefaults.init(suiteName: "group.com.Sweesen.myWidget")?.setValue(busesToSave, forKey: "widget1")
        }
        
        GMSServices.provideAPIKey(GMSServicesAPIKey)
        
        let switchValue = UserDefaults.init().value(forKey: Keys.themeSwitchKey.rawValue) as? Bool
        if switchValue == true{
            currentTheme = darkTheme!
        }else if switchValue == false{
            currentTheme = lightTheme!
        }else{
            currentTheme = darkTheme!
        }
        
        if let isFavLocationOn = UserDefaults.init().value(forKey: Keys.shouldSortBusStopByLocationInFavouriteKey.rawValue) as? Bool{
            shouldSortBusStopsByLocationInFavourtie = isFavLocationOn
        }
        
        globalBusStopsVariable = self.getBusStopsInfo()
         me = self.getBusRoutesInfo()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = CustomTabBarController()
        //window?.rootViewController = BusRouteMapViewController()
//        let mapVC = UINavigationController(rootViewController: GoogleMapBusRouteViewController())
//        window?.rootViewController = mapVC
     //   window?.rootViewController = UINavigationController(rootViewController: BusRoutesChoosingVC())
        
        
//        DispatchQueue.global(qos: .background).async {
//            
//        }
       
        
        UINavigationBar.appearance().tintColor = .gray
        
        if currentTheme == darkTheme{
            UIApplication.shared.statusBarStyle = .lightContent
        }else if currentTheme == lightTheme{
            UIApplication.shared.statusBarStyle = .default
        }
        
        
        
        
        
        
        return true
    }
    
    func getBusRoutesInfo() -> [BusRoute] {
        var busRoutes = [BusRoute]()
        let path = Bundle.main.path(forResource: "BusRoutes1", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do{
            let data = try Data(contentsOf: url)
            let insideBusRoutes = try JSONDecoder().decode(mainBusRoute.self, from: data)
            busRoutes = insideBusRoutes.BusRoutes
            
        }
        catch{print("error getting busRoutes info")}
        return busRoutes
    }
    
    func getBusStopsInfo() -> [BusStop] {
        var busStops = [BusStop]()
        let path = Bundle.main.path(forResource: "BusStops1 2", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do{
            let data = try Data(contentsOf: url)
            let insideBusStops = try JSONDecoder().decode(main.self, from: data)
            busStops = insideBusStops.BusStops
        }
        catch{print("error getting busstops info")}
        return busStops
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

