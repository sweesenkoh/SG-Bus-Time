//
//  BusStopsCollectionViewCell.swift
//  BusStops
//
//  Created by Koh Sweesen on 27/5/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit
import GoogleMaps

class BusStopsCollectionViewCell: UICollectionViewCell {
    

    var settingUpMapView:Bool = false{
        didSet{
            if settingUpMapView == true && latitudeHere != nil{
                setupMapView()
            }
        }
    }
    

    var busStopCode: String?{
        didSet{
           // setupBusCodeView()
          //findingBusesForThisBusStop()
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellMainViews()

    }
    
    
    
    
    fileprivate func setupCellMainViews() {
        self.backgroundColor = UIColor.darkGray
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        // self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = 2
        
        
        setupToggleMapView()
        setupDescriptionView()
        setupRoadNameView()
//        setupBusCodeView()
//        findingBusesForThisBusStop()
        

    }
    
    
    
    let descriptionView:UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.isEditable = false
        view.font = UIFont.boldSystemFont(ofSize: 26)
        view.textColor = .white
        return view
    }()
    
    func setupDescriptionView(){
        self.addSubview(descriptionView)
        descriptionView.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 10, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 10, RightAnchorTo: toggleMapView.leftAnchor, RightPadding: -8, ViewWidth: nil, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: self.heightAnchor, HeightMultiplier: 0.25)
    }
    
    let roadNameView:UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.isEditable = false
        label.isUserInteractionEnabled = false
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    func setupRoadNameView(){
        self.addSubview(roadNameView)
        roadNameView.setupConstraint(TopAnchorTo: descriptionView.bottomAnchor, TopPadding: 0, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 10, RightAnchorTo: self.rightAnchor, RightPadding: -10, ViewWidth: nil, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: self.heightAnchor, HeightMultiplier: 0.3)
    }
    
    class MyLabelClass: UILabel {
        
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
            super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        }
        
    }
    
    let busCodeView:MyLabelClass = {
        let label = MyLabelClass()
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.init(red: 91/255, green: 91/255, blue: 91/255, alpha: 1)
        label.isUserInteractionEnabled = false
     //   label.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10)
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
        return label
    }()
    
    func setupBusCodeView(){
        self.addSubview(busCodeView)
        busCodeView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.bottomAnchor, BottomPadding: 0, LeftAnchorTo: self.leftAnchor, LeftPadding: 0, RightAnchorTo: self.rightAnchor, RightPadding: 0, ViewWidth: nil, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: self.heightAnchor, HeightMultiplier: 0.32)
    }
    
    var latitudeHere: Float?
    var longitudeHere:Float?
    let cancelButton = UIButton()
    //let panoView = GMSPanoramaView(frame: .zero)
 
    var mapView = GoogleStreetView()
    
    func setupMapView(){
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / CGFloat(2.07))
        mapView = GoogleStreetView(frame: frame, latitude: latitudeHere!, longitude: longitudeHere!)
        self.addSubview(mapView)
    }

    
    let toggleMapView:UIButton = {
        let button = UIButton()
        //button.setTitle("Street View", for: .normal)
        let image = UIImage(named: "streetViewIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.showsTouchWhenHighlighted = true
//        let attribute = NSAttributedString(string: "Street View", attributes: [NSAttributedStringKey.foregroundColor:UIColor.darkGray])
//        button.setAttributedTitle(attribute, for: .highlighted)
        return button
    }()
    
    func setupToggleMapView(){
        self.addSubview(toggleMapView)
        toggleMapView.addTarget(self, action: #selector(handleToggleMapViewButton), for: .touchUpInside)
        toggleMapView.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 10, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.rightAnchor, RightPadding: -0, ViewWidth: 50, ViewHeight: 50, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    @objc func handleToggleMapViewButton(){
          settingUpMapView = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var filteredBusRoute = [BusRoute]()
    var sortedFilteredBusRoute = [BusRoute]()
    
    
    
    func findingBusesForThisBusStop() {
        filteredBusRoute.removeAll()
        for bus in me{
            if bus.BusStopCode == self.busStopCode!{
                filteredBusRoute.append(bus)
            }
        }
        sortedFilteredBusRoute = sortingArray(busRouteArray: filteredBusRoute)
        
        self.busCodeView.text = ""
        var count = 0
        for item in sortedFilteredBusRoute{
            
            if count == sortedFilteredBusRoute.count - 1{
                self.busCodeView.text?.append("\(item.ServiceNo!)")
                count = 0
            }else{
                self.busCodeView.text?.append("\(item.ServiceNo!) , ")
                count += 1
            }
        }
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
