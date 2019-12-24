//
//  BusStopsViewController.swift
//  BusStops
//
//  Created by Koh Sweesen on 23/5/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//thirdtesting

import UIKit
import CoreLocation




class BusStopsViewController: UICollectionViewController,UISearchResultsUpdating,CLLocationManagerDelegate,UICollectionViewDelegateFlowLayout {
    
    
    var busStopsForSearch = [BusStop]()
    var filteredBusStops = [BusStop]()
    var superfilteredBusStops = [BusStop]()
    var searchController = UISearchController(searchResultsController: nil)
    let locationManager = CLLocationManager()
    var userLatitude:Double = 1.3521
    var userLongitude:Double = -103.8189
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionView?.backgroundColor = currentTheme.nearbyVCBackgroundColor
        filteredBusStops = globalBusStopsVariable
        setupNavigationBar()
        CLStartUpdatingIfAvailable()
        superfilteredBusStops = assigningBusStopDistanceProperty(busStopsArray: filteredBusStops)
        
        collectionView?.register(BusStopsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        let rightReloadButton = UIBarButtonItem(title: "Map View", style: .plain, target: self, action: #selector(handleMapViewButton))
        rightReloadButton.tintColor = currentTheme.navTitleTextColor
        self.navigationItem.rightBarButtonItem = rightReloadButton
        
        
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                busStopsForSearch = globalBusStopsVariable
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
            busStopsForSearch = globalBusStopsVariable
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc func handleMapViewButton(){
        
        let cell = self.collectionView?.cellForItem(at: IndexPath(row: 0, section: 0)) as? BusStopsCollectionViewCell
        
        
        let ottherVC = MapViewChildVC()
        ottherVC.longitude = Double(userLongitude)
        ottherVC.BusStopString = cell?.descriptionView.text
        ottherVC.userLatitude = userLatitude
        ottherVC.userLongitude = userLongitude // every setup of variable must be before latitude
        ottherVC.latitude = Double(userLatitude)
        ottherVC.setupBusTimingChildVC(busStopCode: busStopsForSearch[0].BusStopCode)
        ottherVC.view.backgroundColor = .clear
        
        present(ottherVC, animated: true, completion: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    
    

    //CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return busStopsForSearch.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BusStopsCollectionViewCell
        cell.descriptionView.text = busStopsForSearch[indexPath.row].Description
        cell.roadNameView.text = "\(busStopsForSearch[indexPath.row].RoadName)" + "\n" + "\(busStopsForSearch[indexPath.row].BusStopCode)"
        cell.busStopCode = busStopsForSearch[indexPath.row].BusStopCode
        cell.mapView.removeFromSuperview()
        cell.cancelButton.removeFromSuperview()
        
        for item in globalBusStopsVariable{
            if item.BusStopCode == busStopsForSearch[indexPath.row].BusStopCode{
                cell.latitudeHere = item.Latitude
                cell.longitudeHere = item.Longitude
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        initialiseIndividualBusStopVCUponCellSelection(indexPath: indexPath)
        
       
//
//        self.addChildViewController(ottherVC)
//        self.view.addSubview(ottherVC.view)
//        ottherVC.didMove(toParentViewController: self)
//
//        let width = self.view.bounds.width
//        let height = self.view.bounds.height
//
//        ottherVC.view.frame = CGRect(x: 0, y: height, width: width, height: height)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: self.view.bounds.width / CGFloat(2.07))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

      return UIEdgeInsetsMake(10, 0, 0, 0)
    }
    

    
    //_______________________________   REFRACTED METHODS ___________________________________________________________________________________________
    
    func initialiseIndividualBusStopVCUponCellSelection(indexPath: IndexPath){
        let individualBusStopVC = ViewController()
        individualBusStopVC.busStopCode = busStopsForSearch[indexPath.row].BusStopCode
        individualBusStopVC.navigationItem.title = busStopsForSearch[indexPath.row].Description
        individualBusStopVC.roadName = busStopsForSearch[indexPath.row].RoadName
        navigationItem.searchController?.isActive = false
        self.navigationController?.pushViewController(individualBusStopVC, animated: true)
    }
    
    func CLStartUpdatingIfAvailable(){
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Nearby"
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

    
    fileprivate func UpdatingDataWithNewLocation() {
        
        superfilteredBusStops = assigningBusStopDistanceProperty(busStopsArray: filteredBusStops)
        superfilteredBusStops.sort{$0.Distance! < $1.Distance!}
        busStopsForSearch = superfilteredBusStops
        self.collectionView?.reloadData()
        locationManager.stopUpdatingLocation()
    }
    
    
    func assigningBusStopDistanceProperty(busStopsArray: [BusStop]) -> [BusStop]{
        
        if CLLocationManager.locationServicesEnabled() == false{
            return busStopsArray
        }else{
        
        
        var temporary = [BusStop]()
        for busStop in busStopsArray{
            var insideBusStop = busStop
            insideBusStop.Distance = busStop.calculateDistance(latitude: userLatitude, longitude: userLongitude, busStopLatitude: Double(busStop.Latitude), busStopLongitude: Double(busStop.Longitude))
            temporary.append(insideBusStop)
        }
        print("busStops Relocated")
        return temporary
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
        if let location = locations.last {
            userLatitude = location.coordinate.latitude
            userLongitude = location.coordinate.longitude
            UpdatingDataWithNewLocation()
        }
        
        if locations.isEmpty == false{
            self.locationManager.stopUpdatingLocation()
        }
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            
            if searchText.isEmpty == true{
                busStopsForSearch = superfilteredBusStops
                locationManager.startUpdatingLocation()
            }else{
                locationManager.stopUpdatingLocation()
                busStopsForSearch = superfilteredBusStops.filter{$0.RoadName.lowercased().contains(searchText.lowercased())}
                busStopsForSearch += superfilteredBusStops.filter{$0.Description.lowercased().contains(searchText.lowercased())}
                busStopsForSearch += superfilteredBusStops.filter{$0.BusStopCode.starts(with: searchText)}
            }
            
            collectionView?.reloadData()
        }
    }
}


