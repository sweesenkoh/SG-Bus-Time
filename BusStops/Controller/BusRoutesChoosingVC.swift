//
//  BusRoutesChoosingVC.swift
//  BusStops
//
//  Created by Koh Sweesen on 25/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import Foundation
import UIKit

class BusRoutesChoosingVC:UITableViewController,UISearchResultsUpdating{
   
    var arrayOfBuses = [BusRoute]()
    var arrayOfBusesAfterSearching = [BusRoute]()
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupNavigationBar()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupMyArrayData()
        arrayOfBusesAfterSearching = arrayOfBuses
        self.view.backgroundColor = .darkGray
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }


    
    func setupNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Buses"
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
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            
            if searchText.isEmpty == true{
                arrayOfBusesAfterSearching = arrayOfBuses
            }else{
                arrayOfBusesAfterSearching = arrayOfBuses.filter{($0.ServiceNo?.lowercased().contains(searchText.lowercased()))!}
//                arrayOfBusesAfterSearching += arrayOfBuses.filter{$0.Description.lowercased().contains(searchText.lowercased())}
//                busStopsForSearch += superfilteredBusStops.filter{$0.BusStopCode.starts(with: searchText)}
            }
            
           self.tableView.reloadData()
        }
    }
    
    func setupMyArrayData(){
        
        //first step is to separate out buses into both their directions
        var busesWithDirection1 = [BusRoute]()
        var busesWithDirection2 = [BusRoute]()

        for bus in me{
            if bus.Direction == 2{
                busesWithDirection2.append(bus)
            }else{
                busesWithDirection1.append(bus)
            }
        }


        //Second Step: Removing duplicates based on service number

        var busesDirection1AfterFilteringDuplicates = [BusRoute]()
        var busesDirection2AfterFilteringDuplicates = [BusRoute]()

        var checker:String = ""
        for bus in busesWithDirection1{

            if bus.ServiceNo == checker{}else{
                checker = bus.ServiceNo!
                busesDirection1AfterFilteringDuplicates.append(bus)
            }
        }

        var checker2:String = ""
        for bus in busesWithDirection2{

            if bus.ServiceNo == checker2{}else{
                checker2 = bus.ServiceNo!
                busesDirection2AfterFilteringDuplicates.append(bus)
            }
        }


        //Third step, sort the buses in accending order



        let busesDirection1SortedInAccendingOrder = sortingArray(busRouteArray: busesDirection1AfterFilteringDuplicates)

        let busesDirection2SortedInAccendingOrder = sortingArray(busRouteArray: busesDirection2AfterFilteringDuplicates)


        let newCombinedArray = busesDirection1SortedInAccendingOrder + busesDirection2SortedInAccendingOrder

        let newCombinedSortedArray = sortingArray(busRouteArray: newCombinedArray)
        arrayOfBuses = newCombinedSortedArray
//
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfBusesAfterSearching.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arrayOfBusesAfterSearching[indexPath.row].ServiceNo
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.light)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        
        let routeGoogleVC = GoogleMapBusRouteViewController()
        routeGoogleVC.busNumber = arrayOfBusesAfterSearching[indexPath.row].ServiceNo!
        self.searchController.resignFirstResponder()
        self.searchController.isActive = false
        self.navigationController?.pushViewController(routeGoogleVC, animated: true)
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func sortingArray(busRouteArray: [BusRoute]) -> [BusRoute]{
        
        let uselessArray = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        let originalArray = busRouteArray
        var finalArray = [BusRoute]()
        var superFinalArray = [BusRoute]()
        var separationArray = [separator]()
        var holdNR = [BusRoute]()
        var indices = [Int]()
        var index: Int = 0
        
        for busRoute in originalArray{
            
            
            
            for useless in uselessArray{
                if String((busRoute.ServiceNo?.last)!) == useless {
                    separationArray.append(separator(busNumber: busRoute.ServiceNo!, busNumberCharacter: useless))
                    var newSerViceNo = busRoute.ServiceNo
                    newSerViceNo?.removeLast()
                    finalArray.append(BusRoute(ServiceNo: newSerViceNo, Operator: busRoute.Operator, Direction: busRoute.Direction, StopSequence: busRoute.StopSequence, BusStopCode: busRoute.BusStopCode, Distance: busRoute.Distance, WD_FirstBus: busRoute.WD_FirstBus, WD_LastBus: busRoute.WD_LastBus, SAT_FirstBus: busRoute.SAT_FirstBus, SAT_LastBus: busRoute.SAT_LastBus, SUN_FirstBus: busRoute.SUN_FirstBus, SUN_LastBus: busRoute.SUN_LastBus))
                    //                        indices.append(index)                }
                }else if String((busRoute.ServiceNo?.first)!) == useless{
                    holdNR.append(busRoute)
                }
            }
            finalArray.append(BusRoute(ServiceNo: busRoute.ServiceNo, Operator: busRoute.Operator, Direction: busRoute.Direction, StopSequence: busRoute.StopSequence, BusStopCode: busRoute.BusStopCode, Distance: busRoute.Distance, WD_FirstBus: busRoute.WD_FirstBus, WD_LastBus: busRoute.WD_LastBus, SAT_FirstBus: busRoute.SAT_FirstBus, SAT_LastBus: busRoute.SAT_LastBus, SUN_FirstBus: busRoute.SUN_FirstBus, SUN_LastBus: busRoute.SUN_LastBus))
            
            //            index = index + 1
            
        }
        
        for item in finalArray{
            
            for useless in uselessArray{
                if String((item.ServiceNo?.last)!) == useless || String((item.ServiceNo?.first)!) == useless{
                    indices.append(index)
                    
                }
            }
            index = index + 1
        }
        
        var newindices = indices.removeDuplicates()
        newindices.sort{$0>$1}
        
        for index in newindices{
            finalArray.remove(at: index)
        }
        
        
        finalArray.sort{Int($0.ServiceNo!)! < Int($1.ServiceNo!)!}
        
        
        var checker: Int = 0
        var loopChecker:Int = 0
        var preventDuplicate: String?
        var preventDuplicate2:String?
        var preventDuplicate3:String?
        var mainPreventDuplicate:BusRoute?
        var mainPreventDuplicate2:BusRoute?
        var mainchecker: Int = 0
        
        for item in finalArray{
            for item2 in separationArray{
                
                if item.ServiceNo == String(item2.busNumber)[0...(item2.busNumber.count-2)] && (item2.busNumber != preventDuplicate) && (item2.busNumber != preventDuplicate2) && (item2.busNumber != preventDuplicate3){
                    superFinalArray.append(BusRoute(ServiceNo: "\(item.ServiceNo!)"+"\(item2.busNumberCharacter)", Operator: item.Operator, Direction: item.Direction, StopSequence: item.StopSequence, BusStopCode: item.BusStopCode, Distance: item.Distance, WD_FirstBus: item.WD_FirstBus, WD_LastBus: item.WD_LastBus, SAT_FirstBus: item.SAT_FirstBus, SAT_LastBus: item.SAT_LastBus, SUN_FirstBus: item.SUN_FirstBus, SUN_LastBus: item.SUN_LastBus))
                    
                    if loopChecker == 2{preventDuplicate3 = item2.busNumber;checker=3}
                    else if loopChecker == 1 {preventDuplicate2 = item2.busNumber;checker = 2;loopChecker=2}else{preventDuplicate = item2.busNumber;checker = 1;loopChecker=1}
                    
                }
                
                
                
            }
            loopChecker = 0
            if checker == 0 && (item.ServiceNo != mainPreventDuplicate?.ServiceNo) && (item.ServiceNo != mainPreventDuplicate2?.ServiceNo){
                superFinalArray.append(item)
                if mainchecker == 1{mainPreventDuplicate2 = item}else{
                    mainPreventDuplicate = item;mainchecker = 1
                }
            }
            checker = 0
            
        }
        
        superFinalArray = superFinalArray + holdNR
        
        return superFinalArray
        
    }
    
}
