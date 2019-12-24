//
//  mapViewChildVC.swift
//  BusStops
//
//  Created by Koh Sweesen on 18/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import GoogleMaps

class MapViewChildVC:UIViewController,MKMapViewDelegate{
    
    var latitude: Double = 0{
        didSet{
            setupMap()
           // setupGoogleMap()
            setupDismissButton()
        }
    }
    var longitude: Double = 0
    var userLatitude:Double = 0
    var userLongitude:Double = 0
    
    var BusStopString:String?
    var descriptionString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
       // prepareBackgroundView()
        
        

    }
    


//    
//    func prepareBackgroundView(image:UIImageView) -> UIImageView{
//        let blurEffect = UIBlurEffect.init(style: .dark)
//        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
//        let bluredView = UIVisualEffectView.init(effect: blurEffect)
//        bluredView.contentView.addSubview(visualEffect)
//        visualEffect.frame = UIScreen.main.bounds
//        bluredView.frame = UIScreen.main.bounds
//        image.insertSubview(bluredView, at: 0)
//        return image
//    }
//    
    func setupDismissButton(){
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.backgroundColor = .black
        button.alpha = 0.6
        button.layer.cornerRadius = 15
        button.showsTouchWhenHighlighted = true
        button.insetsLayoutMarginsFromSafeArea = true
        button.frame = CGRect(x: UIScreen.main.bounds.width - 50, y: 30, width: 30, height: 30)
        button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func handleDismissButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupMap(){
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = self
        map.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 300)
        let location = CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
        map.setCenter(location, animated: true)
        map.setRegion(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)), animated: true)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        annotation.title = "\(BusStopString!)\n\(descriptionString!)"
        var annotations = [MKPointAnnotation]()
        
        for item in globalBusStopsVariable{
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: Double(item.Latitude), longitude: Double(item.Longitude))
            annotation.coordinate = coordinate
            annotation.title = item.Description
            annotation.subtitle = item.BusStopCode
            annotations.append(annotation)
        }
        map.addAnnotations(annotations)
        self.view.addSubview(map)
    }
    
    func setupGoogleMap(){
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 100.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        
        for item in globalBusStopsVariable{
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Double(item.Latitude), longitude: Double(item.Longitude))
            marker.title = item.Description
            marker.snippet = item.BusStopCode
            marker.iconView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMarker)))
            marker.map = mapView
        }
        
        
        
    }
    
    @objc func handleTapMarker(busStopCode:String){
        
    }
    
    let busTimingVC:ViewController = {
        let busTimingVC = ViewController()
        busTimingVC.busStopCode = "81111"
        busTimingVC.view.layer.masksToBounds = false
        busTimingVC.view.layer.shadowColor = UIColor.black.cgColor
        busTimingVC.view.layer.shadowRadius = 10
        busTimingVC.view.layer.shadowOpacity = 1
        busTimingVC.view.layer.shadowOffset = CGSize(width: 5, height: 5)
        busTimingVC.view.layer.shouldRasterize = true
        busTimingVC.view.layer.rasterizationScale = 2
        busTimingVC.view.clipsToBounds = true
        return busTimingVC
    }()
    
    func setupBusTimingChildVC(busStopCode:String){
        self.addChildViewController(busTimingVC)
        self.view.addSubview(busTimingVC.view)
        self.view.bringSubview(toFront: self.view)
        busTimingVC.roadName = BusStopString
        busTimingVC.busStopCode = busStopCode
        busTimingVC.findingBusesForThisBusStop()
        busTimingVC.createHeaderBar()
        busTimingVC.bannerView.removeFromSuperview()
        busTimingVC.setupBusTimingData{self.busTimingVC.tableView.reloadData()}
        busTimingVC.didMove(toParentViewController: self)
        busTimingVC.view.frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 300)
        busTimingVC.tableView.frame = CGRect(x: 0, y: 0, width: busTimingVC.view.frame.width, height: busTimingVC.view.frame.height)

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        let string = view.annotation?.subtitle
        
        busTimingVC.didMove(toParentViewController: nil)
        busTimingVC.removeFromParentViewController()
        busTimingVC.view.removeFromSuperview()
        
        for item in globalBusStopsVariable{

            if item.BusStopCode == string{

                setupBusTimingChildVC(busStopCode: item.BusStopCode)
                busTimingVC.busStopCode = item.BusStopCode
                busTimingVC.roadName = item.Description
                
            }

        }

        
    }
    
    
}






