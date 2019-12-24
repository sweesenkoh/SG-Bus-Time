//
//  StreetViewController.swift
//  BusStops
//
//  Created by Koh Sweesen on 14/6/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit
import GoogleMaps

class StreetViewController: UIViewController,GMSMapViewDelegate {

    var latitudeHere: Float?
    var longitudeHere:Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        
        let panoView = GMSPanoramaView(frame: .zero)
        self.view = panoView
        
        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: CLLocationDegrees(latitudeHere!), longitude: CLLocationDegrees(longitudeHere!)), source: .outside)
        let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitudeHere!), longitude: CLLocationDegrees(longitudeHere!))
        let marker = GMSMarker(position: position)
        
        marker.panoramaView = panoView
        let view = GMSMapView()
        marker.map = view
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Screenshot", style: .done, target: self, action: #selector(handleScreenShot))
    }
    
//    @objc func handleScreenShot(){
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
//        view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        let newVC = screenShotViewController()
//        newVC.imqge = image
//        present(newVC, animated: true, completion: nil)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = false
    }

}

class screenShotViewController:UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   setupImageView()
    }
    var imqge: UIImage?{
        didSet{
            setupImageView()
        }
    }
    
    func setupImageView(){
        let image = UIImageView()
        image.image = imqge
        self.view.addSubview(image)
        image.frame = view.frame
    }
}
