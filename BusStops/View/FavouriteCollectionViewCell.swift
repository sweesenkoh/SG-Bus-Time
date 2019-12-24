//
//  FavouriteCollectionViewCell.swift
//  BusStops
//
//  Created by Koh Sweesen on 30/5/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit
import GoogleMaps

protocol deleteCellUpdateDelegate {
    func updateCollectionViewCell(arrayToSave:[favourite])
}

protocol presentAlertController {
    func createAlertController(busStopCode: String,cellNumber:Int)
}


class FavouriteCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource{
    

    var cellLatitude: Double?
    var cellLongitude:Double?
    var cellNumber:Int?
    var rowHeight:Int = 70
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = 2
 

        
        if let saveData = loadData(){
            loadedArray = saveData
        }
        
        setupImageView()
        setupBlackView()
        setupBusStopDescriptionView()
        setupBusStopRoadNAmeView()
        setupBusStopCodeTextView()
        setupTableView()
        tableView.register(tableViewCustomCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
        setupSelectImageButton()
        setupStreetViewButton()
        
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowRadius = 10
        tableView.layer.shadowOpacity = 0.5
        tableView.layer.shadowOffset = CGSize(width: 1, height: 1)
        // self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        tableView.layer.shouldRasterize = true
        tableView.layer.rasterizationScale = 2
        return tableView
    }()
    
    var tableArray = [String](){
        didSet{
            setupTableView()
            self.tableView.reloadData()
//            self.setNeedsLayout()
//            self.layoutIfNeeded()
        }
    
    }
    var cellBusStopCode : String?
    var busTimings = [Service](){
        didSet{
            self.tableView.reloadData()
        }
    }
    var deletedelegate: deleteCellUpdateDelegate?
    var alertDelegate: presentAlertController?
    
    
    
    private func loadData() -> [favourite]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: favourite.ArchiveURL.path) as? [favourite]
    }
        
    
    func setupTableView(){
        self.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 150, BottomAnchorTo: self.bottomAnchor, BottomPadding: 0, LeftAnchorTo: self.leftAnchor, LeftPadding: 0, RightAnchorTo: self.rightAnchor, RightPadding: 0, ViewWidth: nil, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        
    }

    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCustomCell
//        cell.reloadDelegate = self
//        cell.cellNumberID = indexPath.row
//        cell.busNumberLabel.text = tableArray[indexPath.row]
//        cell.busTimingText.text = "Unavailable";cell.busTimingText.textColor = .red
//        cell.secondBusTimingText.text = "";cell.busLoadView.backgroundColor = .clear;cell.WABImageView.image = nil;cell.busLoadView.text = ""
//
//        for service in self.busTimings{
//            if cell.busNumberLabel.text == service.ServiceNo{
//                cell.busTimingText.text = "\(service.NextBus.getAmountOfTimeToArrive(bus: service.NextBus))"
//                cell.busTimingText.textColor = UIColor.white
//
//                cell.secondBusTimingText.text = service.NextBus2.getAmountOfTimeToArrive(bus: service.NextBus2)
//                if cell.secondBusTimingText.text == "Arriving" {cell.secondBusTimingText.text = "Arr"}
//
//                if service.NextBus.Load == "SEA" {cell.busTimingText.textColor = .green}
//                else if service.NextBus.Load == "SDA" {cell.busTimingText.textColor = .yellow}
//                else if service.NextBus.Load == "LSD" {cell.busTimingText.textColor = .red}
//
//                if service.NextBus2.Load == "SEA" {cell.secondBusTimingText.textColor = .green}
//                else if service.NextBus2.Load == "SDA" {cell.secondBusTimingText.textColor = .yellow}
//                else if service.NextBus2.Load == "LSD" {cell.secondBusTimingText.textColor = .red}
//
//                if service.NextBus.busType == "SD" {cell.busLoadView.text = "Single Deck";cell.busLoadView.backgroundColor = .orange}
//                else if service.NextBus.busType == "DD" {cell.busLoadView.text = "Double Deck";cell.busLoadView.backgroundColor = .darkGray}
//                else if service.NextBus.busType == "BD" {cell.busLoadView.text = "Bendy";cell.busLoadView.backgroundColor = .blue}
//
//                if service.NextBus.Feature == "WAB" {cell.isItWAB = 1}
//            }
//
//        }
//
//        return cell
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCustomCell
        cell.busTimingBlackView.backgroundColor = .clear
        cell.busNumberLabel.textColor = .white
        cell.isSelected = false
        cell.WABImageView.image = nil
        cell.secondWABImageView.image = nil
        cell.thirdWABImageView.image = nil
        
        cell.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        
        cell.cellNumberID = indexPath.row
        cell.reloadDelegate = self
        
        cell.busNumberLabel.text = tableArray[indexPath.row]
    //    cell.cellBusStopCode = busStopCode
        cell.busTimingText.text = "-";
        cell.busTimingText.textColor = .white
        cell.secondBusTimingText.textColor = .white
        cell.thirdBusTimingText.textColor = .white
        cell.busLoadView.text = "";cell.secondBusLoadView.text = ""
        cell.secondBusTimingText.text = "-";cell.busLoadView.backgroundColor = .clear;cell.secondBusLoadView.backgroundColor = .clear
        cell.thirdBusTimingText.text = "-";cell.thirdBusLoadView.backgroundColor = .clear
        cell.thirdBusLoadView.text = ""
        
        if cell.secondBusTimingText.text == "Arriving" {cell.secondBusTimingText.text = "Arr"}
        
        
        for service in self.busTimings{
            
            if cell.busNumberLabel.text == service.ServiceNo{
                
                if service.NextBus.getAmountOfTimeToArrive(bus: service.NextBus) == "Gone"{
                    
                    cell.busTimingText.text = "\(service.NextBus2.getAmountOfTimeToArrive(bus: service.NextBus2))"
                    cell.busTimingText.textColor = UIColor.white
                    cell.secondBusTimingText.text = service.NextBus3.getAmountOfTimeToArrive(bus: service.NextBus3)
                    
                    
                    if service.NextBus2.Load == "SEA" {cell.busTimingText.textColor = .green}
                    else if service.NextBus2.Load == "SDA" {cell.busTimingText.textColor = .yellow}
                    else if service.NextBus2.Load == "LSD" {cell.busTimingText.textColor = .red}
                    
                    
                    if service.NextBus3.Load == "SEA" {cell.secondBusTimingText.textColor = .green}
                    else if service.NextBus3.Load == "SDA" {cell.secondBusTimingText.textColor = .yellow}
                    else if service.NextBus3.Load == "LSD" {cell.secondBusTimingText.textColor = .red}
                    
                    if service.NextBus2.busType == "SD" {cell.busLoadView.text = "Single";cell.busLoadView.backgroundColor = .orange}
                    else if service.NextBus2.busType == "DD" {cell.busLoadView.text = "Double";cell.busLoadView.backgroundColor = .darkGray}
                    else if service.NextBus2.busType == "BD" {cell.busLoadView.text = "Bendy";cell.busLoadView.backgroundColor = .blue}
                    
                    if service.NextBus3.busType == "SD" {cell.secondBusLoadView.text = "Single";cell.secondBusLoadView.backgroundColor = .orange}
                    else if service.NextBus3.busType == "DD" {cell.secondBusLoadView.text = "Double";cell.secondBusLoadView.backgroundColor = .darkGray}
                    else if service.NextBus3.busType == "BD" {cell.secondBusLoadView.text = "Bendy";cell.secondBusLoadView.backgroundColor = .blue}
                    
                    if service.NextBus2.Feature == "WAB" {cell.isItWAB = 1}
                    if service.NextBus3.Feature == "WAB" {cell.isSecondBusWAB = 1}
                    
                }else{
                    
                    cell.busTimingText.text = "\(service.NextBus.getAmountOfTimeToArrive(bus: service.NextBus))"
                    cell.busTimingText.textColor = UIColor.white
                    
                    cell.secondBusTimingText.text = service.NextBus2.getAmountOfTimeToArrive(bus: service.NextBus2)
                    
                    cell.thirdBusTimingText.text = service.NextBus3.getAmountOfTimeToArrive(bus: service.NextBus3)
                    
                    
                    if service.NextBus.Load == "SEA" {cell.busTimingText.textColor = .green}
                    else if service.NextBus.Load == "SDA" {cell.busTimingText.textColor = .yellow}
                    else if service.NextBus.Load == "LSD" {cell.busTimingText.textColor = .red}
                    
                    if service.NextBus2.Load == "SEA" {cell.secondBusTimingText.textColor = .green}
                    else if service.NextBus2.Load == "SDA" {cell.secondBusTimingText.textColor = .yellow}
                    else if service.NextBus2.Load == "LSD" {cell.secondBusTimingText.textColor = .red}
                    
                    if service.NextBus3.Load == "SEA" {cell.thirdBusTimingText.textColor = .green}
                    else if service.NextBus3.Load == "SDA" {cell.thirdBusTimingText.textColor = .yellow}
                    else if service.NextBus3.Load == "LSD" {cell.thirdBusTimingText.textColor = .red}
                    
                    if service.NextBus.busType == "SD" {cell.busLoadView.text = "Single";cell.busLoadView.backgroundColor = .orange}
                    else if service.NextBus.busType == "DD" {cell.busLoadView.text = "Double";cell.busLoadView.backgroundColor = .darkGray}
                    else if service.NextBus.busType == "BD" {cell.busLoadView.text = "Bendy";cell.busLoadView.backgroundColor = .blue}
                    
                    
                    if service.NextBus2.busType == "SD" {cell.secondBusLoadView.text = "Single";cell.secondBusLoadView.backgroundColor = .orange}
                    else if service.NextBus2.busType == "DD" {cell.secondBusLoadView.text = "Double";cell.secondBusLoadView.backgroundColor = .darkGray}
                    else if service.NextBus2.busType == "BD" {cell.secondBusLoadView.text = "Bendy";cell.secondBusLoadView.backgroundColor = .blue}
                    
                    if service.NextBus3.busType == "SD" {cell.thirdBusLoadView.text = "Single";cell.thirdBusLoadView.backgroundColor = .orange}
                    else if service.NextBus3.busType == "DD" {cell.thirdBusLoadView.text = "Double";cell.thirdBusLoadView.backgroundColor = .darkGray}
                    else if service.NextBus3.busType == "BD" {cell.thirdBusLoadView.text = "Bendy";cell.thirdBusLoadView.backgroundColor = .blue}
                    
                    
                    if service.NextBus.Feature == "WAB" {cell.isItWAB = 1}
                    if service.NextBus2.Feature == "WAB" {cell.isSecondBusWAB = 1}
                    if service.NextBus3.Feature == "WAB" {cell.isThirdBusWAB = 1}
                    
                }
                
                
            }
            
            
            if cell.secondBusTimingText.text == "Arriving" {cell.secondBusTimingText.text = "Arr"}
            if let secondTiming = Int(cell.secondBusTimingText.text!),let firstTiming = Int(cell.busTimingText.text!){
                if firstTiming > secondTiming{
                    cell.secondBusTimingText.text = ""
                }
            }
            
            if let thirdTiming = Int(cell.thirdBusTimingText.text!),let secondTiming = Int(cell.secondBusTimingText.text!){
                if secondTiming > thirdTiming{
                    cell.thirdBusTimingText.text = ""
                }
            }
            
            if cell.secondBusTimingText.text == "Arr" &&
                (cell.busTimingText.text != "Arr" || cell.busTimingText.text != "Left"){
                cell.secondBusTimingText.text = ""
            }
            
            if cell.secondBusTimingText.textColor == .white{
                cell.secondBusTimingText.text = "-"
            }
            
            if cell.thirdBusTimingText.textColor == .white{
                cell.thirdBusTimingText.text = "-"
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func saveDataHere(array: [favourite]) {
        _ = NSKeyedArchiver.archiveRootObject(array, toFile: favourite.ArchiveURL.path)
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: array)
        UserDefaults.init(suiteName: "group.com.Sweesen.myWidget")?.setValue(encodedData, forKey: "key2")
    }
    
    var loadedArray = [favourite]()
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            var finalArray = [favourite]()
            print("sen+\(tableArray)")
            
            if let savedData = loadData(){
                loadedArray = savedData
            }
            if loadedArray.count == 1{finalArray = []}else{
            for item in loadedArray{
                if cellBusStopCode == item.busStopCode && tableArray[indexPath.row] == item.bus{}
                else if tableArray.count == 1 && cellBusStopCode == item.busStopCode{}else{
                    finalArray.append(item)
                    }
                }
            }

            //saveDataHere(array: finalArray)
            deletedelegate?.updateCollectionViewCell(arrayToSave: finalArray)
            
        }
        
        

        
        
        
    }
    
    
    let busStopCodeTextView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    func setupBusStopCodeTextView(){
        self.addSubview(busStopCodeTextView)
        busStopCodeTextView.setupConstraint(TopAnchorTo: self.busStopRoadNameView.bottomAnchor, TopPadding: 5, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 5, RightAnchorTo: self
            .rightAnchor, RightPadding: -5, ViewWidth: nil, ViewHeight: 30, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    let busStopDescriptionView:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textColor = .white
        label.shadowColor = .darkGray
        label.shadowOffset = CGSize(width: 1, height: 1)
        return label
    }()
    
    func setupBusStopDescriptionView(){
        self.addSubview(busStopDescriptionView)
        
        if UIScreen.main.bounds.width == 320{
            busStopDescriptionView.font = UIFont.boldSystemFont(ofSize: 25)
        }
        
        busStopDescriptionView.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 5, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 5, RightAnchorTo: self.rightAnchor, RightPadding: -50, ViewWidth: nil, ViewHeight: 50, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    let busStopRoadNameView:UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    func setupBusStopRoadNAmeView(){
        self.addSubview(busStopRoadNameView)
        busStopRoadNameView.setupConstraint(TopAnchorTo: self.busStopDescriptionView.bottomAnchor, TopPadding: 5, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 5, RightAnchorTo: self.rightAnchor, RightPadding: 5, ViewWidth: nil, ViewHeight: 20, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    
    
    let imageView:UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    func setupImageView(){
        self.addSubview(imageView)
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    
        imageView.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 0, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 0, RightAnchorTo: self.rightAnchor, RightPadding: 0, ViewWidth: nil, ViewHeight: 150, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    func setupBlackView(){
        let blackView = UIView()
        blackView.backgroundColor = .black
        blackView.alpha = 0.4
        self.addSubview(blackView)
        blackView.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 0, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 0, RightAnchorTo: self.rightAnchor, RightPadding: 0, ViewWidth: nil, ViewHeight: 150, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    let selectImageButton : UIButton = {
        let button = UIButton()
   //     button.setImage(UIImage(named: "cellButton"), for: .normal)
    //   button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("⏣", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.setTitle("⎔", for: .highlighted)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    func setupSelectImageButton(){
        self.addSubview(selectImageButton)
        selectImageButton.addTarget(self, action: #selector(handleSelectImageButton), for: .touchUpInside)
        selectImageButton.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 10, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.rightAnchor, RightPadding: -10, ViewWidth: 40, ViewHeight: 40
            , CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    @objc func handleSelectImageButton(){
         alertDelegate?.createAlertController(busStopCode: cellBusStopCode!,cellNumber: cellNumber!)
    }
    
    let streetViewButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "streetViewIcon")?.withRenderingMode(.alwaysTemplate)
        
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    func setupStreetViewButton(){
        self.addSubview(streetViewButton)
        streetViewButton.addTarget(self, action: #selector(handleStreetViewButton), for: .touchUpInside)
        streetViewButton.setupConstraint(TopAnchorTo: self.selectImageButton.bottomAnchor, TopPadding: 30, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.rightAnchor, RightPadding: -10, ViewWidth: 40, ViewHeight: 40, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    var mapView = GoogleStreetView()
    
    @objc func handleStreetViewButton(){

        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
        mapView = GoogleStreetView(frame: frame,latitude: Float(cellLatitude!), longitude: Float(cellLongitude!))

        self.addSubview(mapView)
        self.bringSubview(toFront: self.busStopDescriptionView)
        self.bringSubview(toFront: self.busStopRoadNameView)
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.bounds.size.height = 150 + CGFloat(tableArray.count)*CGFloat(rowHeight)
        layoutAttributes.bounds.size.width = UIScreen.main.bounds.width
        self.frame = layoutAttributes.frame
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
        return layoutAttributes
    }
    
    func setupBusTimingData(completed: @escaping () -> ()){
        
        let jsonURL = "http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode="+cellBusStopCode!
        let myurl = URL(string: jsonURL)
        var request = URLRequest(url: myurl!)
        request.httpMethod = "GET"
        request.setValue("Ka8eRytUQ0+nCYDEs2n0fw==", forHTTPHeaderField: "AccountKey")
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do{
                var insideVariable: BusStopTiming
                insideVariable = try JSONDecoder().decode(BusStopTiming.self, from: data!)
                self.busTimings = insideVariable.Services
                
                DispatchQueue.main.async {
                    completed()
                }
            }
            catch{
                print("error getting bus timing info")
            }
            
            }.resume()
        
       
    }
    
    var intermediateDelegate: IntermediateDelegate?

}

protocol IntermediateDelegate {
    func askRootToRefreshLoadData(favCellNumber:Int,busStopCode:String)
}

extension FavouriteCollectionViewCell: refreshLoadDataAfterBusTimingViewTapped{
    
    func refreshLoadDataAfterBusTimingViewTapped(tag: Int) {
        intermediateDelegate?.askRootToRefreshLoadData(favCellNumber: cellNumber!, busStopCode: self.cellBusStopCode!)
    }
    
}


