//
//  GoogleStreetView.swift
//  BusStops
//
//  Created by Koh Sweesen on 8/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class GoogleStreetView:UIView{
    
    let panoView = GMSPanoramaView(frame: .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var myLatitude: Float?
    var myLongitude:Float?
    
    
    convenience init(frame: CGRect,latitude:Float,longitude:Float){
        
        self.init(frame: frame)
        self.myLatitude = latitude
        self.myLongitude = longitude
        setupMapView()
        
    }
    
    
    
    func setupMapView(){
        
        self.addSubview(panoView)
        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: CLLocationDegrees(myLatitude!), longitude: CLLocationDegrees(myLongitude!)), source: .outside)
        
        let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(myLatitude!), longitude: CLLocationDegrees(myLongitude!))
        let marker = GMSMarker(position: position)
        marker.panoramaView = panoView
        let view = GMSMapView()
        marker.map = view
        
        setupMapViewAnimation()
        
        
    }
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
//        let attribute = NSAttributedString(string: "Cancel", attributes: [NSAttributedStringKey.foregroundColor:UIColor.darkGray])
//        button.setAttributedTitle(attribute, for: .highlighted)
        button.showsTouchWhenHighlighted = true
        button.backgroundColor = .darkGray
        button.alpha = 0.85
        button.layer.cornerRadius = 20
        return button
    }()
    
    func setupCancelButton(){
        cancelButton.addTarget(self, action: #selector(self.handleCancelButton), for: .touchUpInside)
        self.addSubview(self.cancelButton)
        cancelButton.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 10, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.rightAnchor, RightPadding: -10, ViewWidth: 40, ViewHeight: 40, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    @objc func handleCancelButton(){
        
        cancelButton.alpha = 0
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            self.panoView.frame = CGRect(x: self.frame.width/2, y: self.frame.height/2, width: 0, height: 0)
        }, completion: {(action) in
            
            self.panoView.removeFromSuperview()
            self.cancelButton.removeFromSuperview()
            self.removeFromSuperview()
            
        })
        
    }
    
    func setupMapViewAnimation(){
        
        panoView.frame = CGRect(x: UIScreen.main.bounds.width/2, y: 90, width: 0, height: 0)
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            
            self.panoView.frame = CGRect(x: 0, y: 0, width: (self.frame.width), height: (self.frame.height))
            
        }, completion: {(action) in
            
            self.setupCancelButton()
            
        })
    }
    

    
    
}











