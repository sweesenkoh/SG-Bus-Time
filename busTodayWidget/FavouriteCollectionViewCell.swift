//
//  FavouriteCollectionViewCell.swift
//  BusStops
//
//  Created by Koh Sweesen on 30/5/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit

protocol deleteCellUpdateDelegate {
    func updateCollectionViewCell(arrayToSave:[favourite])
}

protocol presentAlertController {
    func createAlertController(busStopCode: String)
}


class FavouriteCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource{
    
    
    var cellLatitude: Double?
    var cellLongitude:Double?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = 2
        
        
        
//        if let saveData = loadData(){
//            loadedArray = saveData
//        }
        
//        setupImageView()
//        setupBlackView()
        setupBusStopDescriptionView()
//        setupBusStopRoadNAmeView()
//        setupBusStopCodeTextView()
        setupTableView()
        tableView.register(tableViewCustomCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
        
        
        self.tableView.separatorStyle = .none
        self.backgroundColor = .clear
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
    
    
    
//    private func loadData() -> [favourite]?  {
//        return NSKeyedUnarchiver.unarchiveObject(withFile: favourite.ArchiveURL.path) as? [favourite]
//    }
    
    
    func setupTableView(){
        self.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 50, BottomAnchorTo: self.bottomAnchor, BottomPadding: 0, LeftAnchorTo: self.leftAnchor, LeftPadding: 0, RightAnchorTo: self.rightAnchor, RightPadding: 0, ViewWidth: nil, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCustomCell
        cell.busNumberLabel.text = tableArray[indexPath.row]
        cell.busTimingText.text = "Unavailable";cell.busTimingText.textColor = .red
        cell.secondBusTimingText.text = "";cell.busLoadView.backgroundColor = .clear;cell.WABImageView.image = nil;cell.busLoadView.text = ""
        
        for service in self.busTimings{
            if cell.busNumberLabel.text == service.ServiceNo{
                cell.busTimingText.text = "\(service.NextBus.getAmountOfTimeToArrive(bus: service.NextBus))"
                cell.busTimingText.textColor = UIColor.white
                
                cell.secondBusTimingText.text = service.NextBus2.getAmountOfTimeToArrive(bus: service.NextBus2)
                if cell.secondBusTimingText.text == "Arriving" {cell.secondBusTimingText.text = "Arr"}
                
                if service.NextBus.Load == "SEA" {cell.busTimingText.textColor = .green}
                else if service.NextBus.Load == "SDA" {cell.busTimingText.textColor = .yellow}
                else if service.NextBus.Load == "LSD" {cell.busTimingText.textColor = .red}
                
                if service.NextBus2.Load == "SEA" {cell.secondBusTimingText.textColor = .green}
                else if service.NextBus2.Load == "SDA" {cell.secondBusTimingText.textColor = .yellow}
                else if service.NextBus2.Load == "LSD" {cell.secondBusTimingText.textColor = .red}
                
                if service.NextBus.busType == "SD" {cell.busLoadView.text = "Single Deck";cell.busLoadView.backgroundColor = .orange}
                else if service.NextBus.busType == "DD" {cell.busLoadView.text = "Double Deck";cell.busLoadView.backgroundColor = .darkGray}
                else if service.NextBus.busType == "BD" {cell.busLoadView.text = "Bendy";cell.busLoadView.backgroundColor = .blue}
                
                if service.NextBus.Feature == "WAB" {cell.isItWAB = 1}
            }
            
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    
//    func saveDataHere(array: [favourite]) {
//        _ = NSKeyedArchiver.archiveRootObject(array, toFile: favourite.ArchiveURL.path)
//        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: array)
//        UserDefaults.init(suiteName: "group.com.Sweesen.myWidget")?.setValue(encodedData, forKey: "key2")
//    }
    
    var loadedArray = [favourite]()
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//            var finalArray = [favourite]()
//            print("sen+\(tableArray)")
//
//            if let savedData = loadData(){
//                loadedArray = savedData
//            }
//            if loadedArray.count == 1{finalArray = []}else{
//                for item in loadedArray{
//                    if cellBusStopCode == item.busStopCode && tableArray[indexPath.row] == item.bus{}
//                    else if tableArray.count == 1 && cellBusStopCode == item.busStopCode{}else{
//                        finalArray.append(item)
//                    }
//                }
//            }
//
//            //saveDataHere(array: finalArray)
//            deletedelegate?.updateCollectionViewCell(arrayToSave: finalArray)
//
//        }
//    }
    
    
    
    
    
//    let busStopCodeTextView: UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        return label
//    }()
//
//    func setupBusStopCodeTextView(){
//        self.addSubview(busStopCodeTextView)
//        busStopCodeTextView.setupConstraint(TopAnchorTo: self.busStopRoadNameView.bottomAnchor, TopPadding: 5, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 5, RightAnchorTo: self
//            .rightAnchor, RightPadding: -5, ViewWidth: nil, ViewHeight: 30, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
//    }
//
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
        
        busStopDescriptionView.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 5, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 5, RightAnchorTo: self.rightAnchor, RightPadding: -50, ViewWidth: nil, ViewHeight: 40, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
//    let busStopRoadNameView:UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        return label
//    }()
//
//    func setupBusStopRoadNAmeView(){
//        self.addSubview(busStopRoadNameView)
//        busStopRoadNameView.setupConstraint(TopAnchorTo: self.busStopDescriptionView.bottomAnchor, TopPadding: 5, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 5, RightAnchorTo: self.rightAnchor, RightPadding: 5, ViewWidth: nil, ViewHeight: 20, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
//    }
//
    
    
//    let imageView:UIImageView = {
//        let image = UIImageView()
//        return image
//    }()
//
//    func setupImageView(){
//        self.addSubview(imageView)
//        //    let image = UIImage(named: "80000")
//        imageView.image = nil
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//
//        imageView.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 0, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 0, RightAnchorTo: self.rightAnchor, RightPadding: 0, ViewWidth: nil, ViewHeight: 150, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
//    }
    
//    func setupBlackView(){
//        let blackView = UIView()
//        blackView.backgroundColor = .black
//        blackView.alpha = 0.4
//        self.addSubview(blackView)
//        blackView.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 0, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.leftAnchor, LeftPadding: 0, RightAnchorTo: self.rightAnchor, RightPadding: 0, ViewWidth: nil, ViewHeight: 150, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
//    }


    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.bounds.size.height = 50 + CGFloat(tableArray.count)*60
        layoutAttributes.bounds.size.width = UIScreen.main.bounds.width 
        self.frame = layoutAttributes.frame
        self.setNeedsLayout()
        self.layoutIfNeeded()
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
    
}
