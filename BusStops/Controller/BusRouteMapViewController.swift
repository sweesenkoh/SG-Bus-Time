//
//  BusRouteMapViewController.swift
//  BusStops
//
//  Created by Koh Sweesen on 24/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class customPin:NSObject,MKAnnotation{
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title:String?,subtitle:String?,coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
}


class BusRouteMapViewController:UIViewController,MKMapViewDelegate{
    
    
    let mapView = MKMapView()
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
    }
    
    
    func setupMapView(){
        mapView.frame = self.view.frame
        let center = CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8189)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
        self.view.addSubview(mapView)
        setupAllAnnotations()
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay:  overlay)
        renderer.strokeColor = .orange
        renderer.lineWidth = 5
        return renderer
        
    }
    
    func setupAllAnnotations(){
        
        var busStopsArrayInString = [String]()
        var busStopsCoordinates = [CLLocationCoordinate2D]()
        
     //   me.sort{$0.StopSequence! < $1.StopSequence!}
        
        for item in me{
            if item.ServiceNo == "51" && item.Direction == 1{
                busStopsArrayInString.append(item.BusStopCode!)
            }
        }
        
        for busStop in globalBusStopsVariable{
            
            for item in busStopsArrayInString{
                
                if item == busStop.BusStopCode{
                    
                    busStopsCoordinates.append(CLLocationCoordinate2D(latitude: Double(busStop.Latitude), longitude: Double(busStop.Longitude)))
                    
                }
                
            }
            
        }
        
        
        if busStopsCoordinates.count % 2 == 0{
            
            var counter = 0
            
            for _ in 0..<busStopsCoordinates.count-1{
                
                setupTwoAnnotation(firstAnnotation: busStopsCoordinates[counter], secondAnnotation: busStopsCoordinates[counter + 1])
                
                counter = counter + 1
            }
            
            
        }else{
            
            busStopsCoordinates.removeLast()
            
            var counter = 0
            
            for _ in 0..<busStopsCoordinates.count-1{
                
                setupTwoAnnotation(firstAnnotation: busStopsCoordinates[counter], secondAnnotation: busStopsCoordinates[counter + 1])
                
                counter = counter + 1
            }
            
        }
        
    }
    
//    CLLocationCoordinate2D(latitude: Double(globalBusStopsVariable[0].Latitude), longitude: Double((globalBusStopsVariable[0].Longitude)))
//
    
    
    func setupTwoAnnotation(firstAnnotation:CLLocationCoordinate2D,secondAnnotation:CLLocationCoordinate2D){
        
        let originCoordinate = firstAnnotation
        let originAnnotation = customPin(title: "origin", subtitle: "yay", coordinate: originCoordinate)
        
        let destinationCoordinate = secondAnnotation
        let destinationAnnotation = customPin(title: "destination", subtitle: "yay", coordinate: destinationCoordinate)
        
        mapView.addAnnotation(originAnnotation)
        mapView.addAnnotation(destinationAnnotation)
        
//        let sourcePlacemark = MKPlacemark(coordinate: originCoordinate)
//        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
//
//        let request = MKDirectionsRequest()
//        request.source = MKMapItem(placemark: sourcePlacemark)
//        request.destination = MKMapItem(placemark: destinationPlacemark)
//        request.transportType = .automobile
//
//        let direction = MKDirections(request: request)
//        direction.calculate { (response, error) in
//
//            guard let directionResponse = response else{
//
//                if let error = error{
//                    print("Direction error: \(error.localizedDescription)")
//                }
//
//                return
//            }
//
//
//            let route = directionResponse.routes[0]
//            self.mapView.add(route.polyline, level: .aboveRoads)
//
//            let rect = route.polyline.boundingMapRect
//            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        
 //       }
        
        self.mapView.delegate = self
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
