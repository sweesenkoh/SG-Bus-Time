//
//  GoogleMapBusRouteViewController.swift
//  BusStops
//
//  Created by Koh Sweesen on 25/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import CoreLocation


// To initiate this VC, one must provide bus number


class GoogleMapBusRouteViewController:UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate{
    
    
    var busDirection:Int = 1
    var busNumber:String = ""{
        didSet{
            setupViews()
        }
    }
    var locationManager = CLLocationManager()
    var mylocation:CLLocation?{
        didSet{
            mapView.animate(toLocation: (mylocation?.coordinate)!)
            let camera = GMSCameraPosition.camera(withLatitude: (mylocation?.coordinate.latitude)!, longitude: (mylocation?.coordinate.longitude)!, zoom: 14)
            mapView.animate(to: camera)
        }
    }
    
    var detailBarViewHeight:CGFloat = 90
    var streetViewHeight:CGFloat = 180
    
    
    
    func setupViews(){
        createMapView()
        mapView.isMyLocationEnabled = true
        setupNavigationBar()
    }
    
    
//    func setupThisViewIfNotProperlyInitialsied(){
//        let failureText = UITextView()
//        failureText.frame = self.view.frame
//        failureText.text = "Perhaps you need to indicate the bus number and bus direction befor initialising this view controller"
//        failureText.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.light)
//        self.view.addSubview(failureText)
//    }
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = currentTheme.navBarColor
       
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    func setupNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Bus \(busNumber)"
        let attribute = [NSAttributedStringKey.foregroundColor:currentTheme.navTitleTextColor]
        navigationController?.navigationBar.largeTitleTextAttributes = attribute
        navigationController?.navigationBar.titleTextAttributes = attribute
        navigationController?.navigationBar.barTintColor = currentTheme.navBarColor
        
        let rightReloadButton = UIBarButtonItem(title: "Switch Direction", style: .plain, target: self, action: #selector(handleSwitchDirectionButton))
        rightReloadButton.tintColor = currentTheme.navTitleTextColor
        self.navigationItem.rightBarButtonItem = rightReloadButton
    }
    
    @objc func handleSwitchDirectionButton(){
        
        mapView.isMyLocationEnabled = true
        locationManager.startUpdatingLocation()
        streetView.removeFromSuperview()
        //check if direction 2 is available:
        var isDirection2Available = false
        
        if busDirection == 1{
            
            for item in me{
                if item.ServiceNo == busNumber && item.Direction == 2{
                    isDirection2Available = true
                }
            }
            
            
            
            if isDirection2Available{
                busDirection = 2
 
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.detailBarView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.detailBarView.frame.width, height: self.detailBarView.frame.height)
                    
                    self.mapView.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    
                }, completion: { (true) in
                   
                    self.mapView.removeFromSuperview()
                    self.detailBarView.removeFromSuperview()
                    self.setupViews()
                })
                
                
                
            }else{
                busDirection = 1
                
                let alert = UIAlertController(title: "This bus has only one direction.", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                alert.addAction(.init(title: "Dismiss", style: .cancel, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
            
            }
            
        }else{
            
            busDirection = 1
            
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.detailBarView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.detailBarView.frame.width, height: self.detailBarView.frame.height)
                
                self.mapView.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
            }, completion: { (true) in
                
                self.mapView.removeFromSuperview()
                self.detailBarView.removeFromSuperview()
                self.setupViews()
            })
            
        }
        
        
        
        
        
        
    }
    
    let detailBarView : UIView = {
        let detailView = UIView()
        detailView.backgroundColor = currentTheme.navBarColor
        return detailView
    }()
    
    let detailBarBusStopView:UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = currentTheme.navTitleTextColor
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.light)
        return label
    }()
    let detailBarBusStop2View:UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = currentTheme.navTitleTextColor
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.light)
        return label
    }()
    
    let arrowView:UIImageView = {
        let arrowView = UIImageView()
        arrowView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        arrowView.tintColor = currentTheme.navTitleTextColor
        arrowView.backgroundColor = .clear
        arrowView.contentMode = .scaleAspectFit
        return arrowView
    }()
    
    
    func setupDetailBarView(busStopsArray:[BusStop]){
        
        self.view.addSubview(detailBarView)
        detailBarView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.view.bounds.width, height: detailBarViewHeight)

        
        UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.detailBarView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-self.detailBarViewHeight, width: self.view.bounds.width, height: self.detailBarViewHeight)
            
        }, completion: nil)
       
        
        detailBarView.addSubview(detailBarBusStopView)
        detailBarView.addSubview(detailBarBusStop2View)
        detailBarView.addSubview(arrowView)
        
        detailBarBusStopView.setupConstraint(TopAnchorTo: detailBarView.topAnchor, TopPadding: 0, BottomAnchorTo: detailBarView.bottomAnchor, BottomPadding: 0, LeftAnchorTo: detailBarView.leftAnchor, LeftPadding: 10, RightAnchorTo: nil, RightPadding: nil, ViewWidth: nil, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: detailBarView.widthAnchor, WidthMultiplier: 0.4, HeightReferenceTo: nil, HeightMultiplier: nil)
        
        detailBarBusStop2View.setupConstraint(TopAnchorTo: detailBarView.topAnchor, TopPadding: 0, BottomAnchorTo: detailBarView.bottomAnchor, BottomPadding: 0, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: detailBarView.rightAnchor, RightPadding: -10, ViewWidth: nil, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: detailBarView.widthAnchor, WidthMultiplier: 0.4, HeightReferenceTo: nil, HeightMultiplier: nil)
        
        arrowView.setupConstraint(TopAnchorTo: detailBarView.topAnchor, TopPadding: 0, BottomAnchorTo: detailBarView.bottomAnchor, BottomPadding: 0, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: nil, RightPadding: nil, ViewWidth: nil, ViewHeight: nil, CentreXAnchor: detailBarView.centerXAnchor, CentreYAnchor: nil, WidthReferenceTo: detailBarView.widthAnchor, WidthMultiplier: 0.1, HeightReferenceTo: nil, HeightMultiplier: nil)
        
        
        let firstBusStop = busStopsArray.first
        let lastBusStop = busStopsArray.last
        
        detailBarBusStopView.text = firstBusStop?.Description
        detailBarBusStop2View.text = lastBusStop?.Description
        
        
    }
    

    var mapView : GMSMapView = {
        var map = GMSMapView()
        let camera = GMSCameraPosition.camera(withLatitude: 1.285, longitude: 103.848, zoom: 10)
        map = GMSMapView.map(withFrame: .zero, camera: camera)
        return map
    }()
    
    func createMapView(){
        
        mapView.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        self.view.addSubview(mapView)
        mapView.isMyLocationEnabled = true
        
        UIView.animate(withDuration: 0.3) {
            self.mapView.frame = self.view.frame
        }
        
        mapView.delegate = self
        mapView.clear()
        createMarkersAndSetupDetailViewData(mapView)
    }
    
    
    
    fileprivate func createMarkersAndSetupDetailViewData(_ mapView: GMSMapView) {
        
       var busStops = [BusStop]()
        
        for item in me{
            
            if item.ServiceNo == busNumber && item.Direction == busDirection{
                
                for busStop in globalBusStopsVariable{
                    if busStop.BusStopCode == item.BusStopCode{
                        
                        createOneMarker(mapView, latitude: Double(busStop.Latitude), longitude: Double(busStop.Longitude), title: "\(busStop.Description)", snippet: "\(busStop.BusStopCode) \(busStop.RoadName)\n(long press for street view)")//\(busStop.RoadName)\n\(busStop.BusStopCode)
                        
                        busStops.append(busStop)
                    }
                }
            }
        }
        
        setupDetailBarView(busStopsArray: busStops)
    }
    
    
    
    fileprivate func createOneMarker(_ mapView: GMSMapView,latitude:Double,longitude:Double,title:String,snippet:String) {
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.map = mapView
        marker.title = title
        marker.snippet = snippet
    //    marker.icon = UIImage(named: "superSmallMapMarker")
    }
    
    
    //Delegation
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        print("info tapped")
        let VC = ViewController()
        VC.busStopCode = marker.snippet?[0...4]
        VC.navigationItem.title = marker.title
        VC.roadName = marker.snippet?[6...((marker.snippet?.count)!-1)]
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    var streetView = GoogleStreetView()
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        
        streetView.removeFromSuperview()
        let frame = CGRect(x: 0, y: UIScreen.main.bounds.height - (detailBarViewHeight + streetViewHeight), width: self.view.bounds.width, height: streetViewHeight)
        streetView = GoogleStreetView(frame: frame, latitude: Float(marker.position.latitude), longitude: Float(marker.position.longitude))
        streetView.isUserInteractionEnabled = true
        streetView.layer.shadowRadius = 15
        streetView.layer.shadowColor = UIColor.black.cgColor
        self.view.addSubview(streetView)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            mylocation = location
            locationManager.stopUpdatingLocation()
        }
        
    }
    

    
    
    
    
}
