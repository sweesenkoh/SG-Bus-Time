//
//  TodayViewController.swift
//  busTodayWidget
//
//  Created by Koh Sweesen on 10/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation


struct insideFavor{
    let busStopCode: String?
    let buses: [String?]
}

struct mainBusTiming{
    let busStopCode: String?
    let busTimings: [Service]
}


var globalBusStopVariable = [BusStop]()

class TodayViewController:UIViewController,NCWidgetProviding,UITableViewDelegate,UITableViewDataSource{
   
    
    var busTimings = [BusStopTiming](){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseView()
        setupArrayInTableView()
        
        if arrayInTableView.isEmpty{
            setupThisViewIfArrayEmpty()
        }else{
        
            
            globalBusStopVariable = getBusStopsInfo()
            setupTableView()
            setupAllBusTimingData()
            self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
            self.view.backgroundColor = .darkGray
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        
        if arrayInTableView.isEmpty == false{
            self.refreshTiming()
        }
        
    }
    
    
    
    
   // UserDefaults.init(suiteName: "group.com.Sweesen.myWidget")?.setValue(busesToSave, forKey: "widget1")
    
    func setupArrayInTableView(){
        let thisArray = UserDefaults.init(suiteName: "group.com.Sweesen.myWidget")?.value(forKey: "widget1") as? [String]
        
        arrayInTableView.removeAll()
        
        
        if let thisArray = thisArray{
            var index = 0
            for _ in 0..<(thisArray.count)/2{
                let item = tableViewData(busNumber: thisArray[index], busStopCode: thisArray[index + 1], busTiming: nil)
                arrayInTableView.append(item)
                index = index + 2
            }
            
            arrayInTableView.sort{Int($0.busStopCode)! < Int($1.busStopCode)!}
        }

    
    }
    
    var arrayInTableView = [
    
        tableViewData(busNumber: "70M", busStopCode: "81111", busTiming: nil),
//        tableViewData(busNumber: "63", busStopCode: "01112",busTiming: nil),
//        tableViewData(busNumber: "51", busStopCode: "80031", busTiming: nil),
//        tableViewData(busNumber: "80", busStopCode: "01112",busTiming: nil),
//        tableViewData(busNumber: "21", busStopCode: "81029", busTiming: nil),
//        tableViewData(busNumber: "853W", busStopCode: "01112",busTiming: nil)

    
    ]
    
    func setupThisViewIfArrayEmpty(){
        let view = UITextView()
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 100, height: self.view.bounds.height)
        view.text = "Go ahead and add some buses to Favourites now!"
        view.textAlignment = .center
        view.backgroundColor = .gray
        view.textColor = .white
        view.isUserInteractionEnabled = false
        view.font = UIFont.systemFont(ofSize: 27, weight: UIFont.Weight.light)
        self.view.addSubview(view)
        
    }
    
    func setupBaseView(){
        let base = UIView()
        base.frame = self.view.frame
        base.backgroundColor = .gray
        self.view.addSubview(base)
    }
    
    let tableView = UITableView()
    
    func setupTableView(){
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        tableView.backgroundColor = .darkGray
        tableView.frame = CGRect(x: 0, y: 0, width: Int(self.view.bounds.width), height: arrayInTableView.count * 55)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayInTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if self.busTimings.isEmpty == true{
            cell.dataModel = arrayInTableView[indexPath.row]
        }else{
        
        for item in self.busTimings{
            if item.BusStopCode == arrayInTableView[indexPath.row].busStopCode{
                for item2 in item.Services{
                    if item2.ServiceNo == arrayInTableView[indexPath.row].busNumber{
                        arrayInTableView[indexPath.row].busTiming = item2
                        cell.dataModel = arrayInTableView[indexPath.row]
                    }
                }
            }
        }
        }
        
        cell.refreshDelegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //height for compact mode is 110. Thus cell height is made to be 55
        return 55
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        extensionContext?.open(URL(string: "SGBUSTIME://")! , completionHandler: nil)
    }
    
    
    
    func setupAllBusTimingData(){
        
        busTimings.removeAll()
        for item in arrayInTableView{
            setupIndividualBusTimingData(cellBusStopCode: item.busStopCode, completed:{
                self.tableView.reloadData()
                self.removeAnimatingView()
            })
        }
    }
    
    let animatingView = UIView()
    
    func setupAnimatingView(){
        
        animatingView.removeFromSuperview()
        animatingView.frame = CGRect(x: -self.view.bounds.width, y: 0, width: 300, height: self.view.bounds.height)
        animatingView.backgroundColor = UIColor.white
        animatingView.alpha = 0.3
        self.view.addSubview(animatingView)
        
        UIView.animate(withDuration: 0.3) {
            self.animatingView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }
        
    }
    
    func removeAnimatingView(){
        UIView.animate(withDuration: 0.3) {
            self.animatingView.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
            if activeDisplayMode == .expanded{
                self.preferredContentSize = CGSize(width: view.frame.width, height: CGFloat(arrayInTableView.count*55))
                }else{
                    self.preferredContentSize = maxSize
                }
        
    
    }
    
    func getBusStopsInfo() -> [BusStop] {
        var busStops = [BusStop]()
        let path = Bundle.main.path(forResource: "BusStops1 2", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do{
            let data = try Data(contentsOf: url)
            let insideBusStops = try JSONDecoder().decode(main.self, from: data)
            busStops = insideBusStops.BusStops
        }
        catch{print("error getting busstops info")}
        return busStops
    }
    
    
    func setupIndividualBusTimingData(cellBusStopCode: String, completed: @escaping () -> ()){
        
        let jsonURL = "http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode="+cellBusStopCode
        let myurl = URL(string: jsonURL)
        var request = URLRequest(url: myurl!)
        request.httpMethod = "GET"
        request.setValue("Ka8eRytUQ0+nCYDEs2n0fw==", forHTTPHeaderField: "AccountKey")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            do{
                var insideVariable: BusStopTiming
                
                guard error == nil else{
                    print("guard error no network")
                    self.animatingView.alpha = 0.9
                    let label = UILabel()
                    label.text = "No Internet Connection"
                    label.frame = self.animatingView.frame
                    label.textAlignment = .center
                    label.numberOfLines = 2
                    label.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.light)
                    self.animatingView.addSubview(label)
                
                
                DispatchQueue.main.async {
                    self.busTimings = []
                    self.tableView.reloadData()
                }
                
                return
            }
                if data != nil{
                    insideVariable = try JSONDecoder().decode(BusStopTiming.self, from: data!)
                    //
                    self.busTimings.append(insideVariable)
                }
                
                
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

protocol handleRefreshAfterTapDelegate {
    func refreshTiming()
}

extension TodayViewController:handleRefreshAfterTapDelegate{
    
    func refreshTiming() {
        busTimings.removeAll()
        setupAllBusTimingData()
        self.tableView.reloadData()
        setupAnimatingView()
    }
    
    
}


struct tableViewData {
    let busNumber:String
    let busStopCode:String
    var busTiming:Service?
}





class TableViewCell:UITableViewCell{
    
    
    var dataModel:tableViewData?{
        didSet{
            self.busNumberLabel.text = dataModel?.busNumber
            self.busStopCode = dataModel?.busStopCode
            self.busTime = dataModel?.busTiming
            
            timeView.removeFromSuperview()
            
            if dataModel?.busTiming != nil{
                setupTimeView()
            }
            
        }
    }
    
    var busStopCode:String?{
        didSet{
            setupBusStopLabel()
            
            for item in globalBusStopVariable{
                if item.BusStopCode == busStopCode{
                    busStopLabel.text = item.Description
                }
            }
            
         //   self.backgroundColor = UIColor.init(red: CGFloat((Int(busStopCode!)!/1000)/255), green: CGFloat((Int(busStopCode!)!/1000)/255), blue: CGFloat((Int(busStopCode!)!/1000)/255), alpha: 1)
//            let addition1 = Int(busStopCode![0])
//            let addition2 = Int(busStopCode![1])
//            let addition3 = Int(busStopCode![2])
//            let addition4 = Int(busStopCode![3])
//            let addition5 = Int(busStopCode![4])
//            let Total = addition1!+addition2!+addition3!+addition4!+addition5!
//
//            if Total > 20{
//                self.busStopLabel.backgroundColor = UIColor.darkGray
//            }else if Total > 17{
//                self.busStopLabel.backgroundColor = UIColor.magenta
//            }else if Total > 15{
//                self.busStopLabel.backgroundColor = .gray
//            }else if Total > 13{
//                self.busStopLabel.backgroundColor = .orange
//            }else if Total > 10{
//                self.busStopLabel.backgroundColor = .brown
//            }else if Total > 5{
//                self.busStopLabel.backgroundColor = .cyan
//            }else{
//                self.busStopLabel.backgroundColor = UIColor.red
//            }
            
            busStopLabel.backgroundColor = .orange
//
        }
    }
    var busTime:Service?
    var refreshDelegate: handleRefreshAfterTapDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")
        setupBusNumberLabel()

    }
    
    var timeView = BusTimingView()
    
    func setupTimeView(){
        
        var frame = CGRect(x: 2*(self.bounds.width/3)-30, y: 0, width: self.bounds.width/2.6, height: self.bounds.height)
        
        if self.bounds.width > 500{
            frame = CGRect(x: 2*(self.bounds.width/3)-180, y: 0, width: self.bounds.width/3.5, height: self.bounds.height)
        }
        
        
        timeView = BusTimingView(frame: frame, busTime: self.busTime)
        timeView.backgroundColor = UIColor.init(red: 59/255, green: 59/255, blue: 59/255, alpha: 1)
        self.addSubview(timeView)
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapTimingView))
        timeView.addGestureRecognizer(gesture)
    }
    
    @objc func handleTapTimingView(){
        timeView.busTimingText.text = "-"
        timeView.secondBusTimingText.text = "-"
        timeView.thirdBusTimingText.text = "-"
        timeView.removeFromSuperview()
        refreshDelegate?.refreshTiming()
    }
    
    let busNumberLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.light)
        label.textColor = .white
        return label
    }()
    
    func setupBusNumberLabel(){
        self.addSubview(busNumberLabel)
        busNumberLabel.frame = CGRect(x: 16, y: 8.5, width: 90, height: self.bounds.height)
    }
    
    let busStopLabel:UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
        label.textColor = .white
        label.isUserInteractionEnabled = false
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.layer.cornerRadius = 3
        return label
    }()
    
    func setupBusStopLabel(){
        self.addSubview(busStopLabel)
        busStopLabel.frame = CGRect(x: 105, y: self.bounds.height/4.7, width: 75, height: self.bounds.height/1.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




class BusTimingView:UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var busTime:Service?
    
    convenience init(frame:CGRect,busTime:Service?){
        self.init(frame: frame)
        self.busTime = busTime
        
        
        setupbusTimingText()
        setupSecondbusTimingText()
        setupThirdbusTimingText()
        checkForInconsistencyInBusTiming()
    }
    
    
    var busTimingText : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.light)
        return label
    }()
    
    func setupbusTimingText(){
        self.addSubview(busTimingText)
        busTimingText.textColor = returnSuitableColorForBusTimingText(bus: (busTime?.NextBus))
        busTimingText.frame = CGRect(x: 0, y: 0, width: self.bounds.width/3, height: self.bounds.height)
        busTimingText.text = busTime?.NextBus.getAmountOfTimeToArrive(bus: (busTime?.NextBus)!)
    }
    
    var secondBusTimingText:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.light)
        return label
    }()
    
    func setupSecondbusTimingText(){
        self.addSubview(secondBusTimingText)
        secondBusTimingText.frame = CGRect(x: self.bounds.width/3, y: 0, width: self.bounds.width/3, height: self.bounds.height)
        secondBusTimingText.textColor = returnSuitableColorForBusTimingText(bus: (busTime?.NextBus2))
        secondBusTimingText.text = busTime?.NextBus2.getAmountOfTimeToArrive(bus: (busTime?.NextBus2)!)
    }
    
    var thirdBusTimingText :UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.light)
        return label
    }()
    
    func setupThirdbusTimingText(){
        self.addSubview(thirdBusTimingText)
        thirdBusTimingText.frame = CGRect(x: self.bounds.width*(2/3), y: 0, width: self.bounds.width/3, height: self.bounds.height)
        thirdBusTimingText.textColor = returnSuitableColorForBusTimingText(bus: (busTime?.NextBus3))
        thirdBusTimingText.text = busTime?.NextBus3.getAmountOfTimeToArrive(bus: (busTime?.NextBus3)!)
    }
    
    func returnSuitableColorForBusTimingText(bus:BusTimingInfo?) -> UIColor{
        
        if bus?.Load == "SEA"{return .green}
        else if bus?.Load == "SDA"{return .yellow}
        else if bus?.Load == "LSD"{return .red}
        else{
            return .white
        }
    }
    
    func checkForInconsistencyInBusTiming(){
        
        
        if let secondTiming = Int(secondBusTimingText.text!),let firstTiming = Int(busTimingText.text!){
            if firstTiming > secondTiming{
                secondBusTimingText.text = ""
            }
        }
        
        if let thirdTiming = Int(thirdBusTimingText.text!),let secondTiming = Int(secondBusTimingText.text!){
            if secondTiming > thirdTiming{
                thirdBusTimingText.text = ""
            }
        }
        
        if secondBusTimingText.text == "Arr" && busTimingText.text != "Arr"{
            secondBusTimingText.text = ""
        }
        
        if secondBusTimingText.textColor == .white{
            secondBusTimingText.text = "-"
        }
        
        if thirdBusTimingText.textColor == .white{
            thirdBusTimingText.text = "-"
        }

    }

    
    
}



//
//class TodayViewController: UIViewController, NCWidgetProviding,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
//
//
//
//
//    var collectionView: UICollectionView!
//
//    override func viewDidAppear(_ animated: Bool) {
//
//        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
//
//    }
//
//
//    var favourtieArray = [favourite]()
//    var buses = [String]()
//    var mainBusTimings = [mainBusTiming]()
//    var timer: Timer!
//    var dataArray = [favourite]()
//    let refreshControl = UIRefreshControl()
//    var removedArray = [String]()
//    let locationManager = CLLocationManager()
//    var userLatitude:Double = 0 {
//        didSet{
//            gettingCorrectBusStopData()
//        }
//    }
//    var userLongitude:Double = 0
//    var globalBusStopsVariable = [BusStop]()
//
//
//    func calculateHeight(noOfBusStops:Int,noOfBuses:Int,lineSpacing:Int)->Double{
//
//        let myFavVariable = handleLoadDataFromNSCoding()
//        var numberOfBusStops:Int = 0
//        var busStops = [String]()
//        var newBusStops = [String]()
//
//        for item in myFavVariable{
//            busStops.append(item.busStopCode!)
//        }
//        newBusStops = busStops.removeDuplicates()
//        numberOfBusStops = newBusStops.count
//
//        let answer = (myFavVariable.count*60) + (numberOfBusStops*50) + (numberOfBusStops-1)*lineSpacing
//        return Double(answer)
//    }
//
//    var height2: Double?
//    var lineSpacing:Int?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        lineSpacing = 15
//
//        height2 = calculateHeight(noOfBusStops: 3, noOfBuses: 5, lineSpacing: lineSpacing!)
//
//        globalBusStopsVariable = getBusStopsInfo()
//        self.refreshLoadData()
//
//        locationManager.startUpdatingLocation()
//        favourtieArray = handleLoadDataFromNSCoding()
//        print(favourtieArray)
//        CLStartUpdatingIfAvailable()
//        gettingCorrectBusStopData()
//
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationItem.title = "Favourites"
//        let attribute = [NSAttributedStringKey.foregroundColor:currentTheme.navTitleTextColor]
//        self.navigationController?.navigationBar.titleTextAttributes = attribute
//        self.navigationController?.navigationBar.largeTitleTextAttributes = attribute
//        //        let buttonAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        //        self.navigationController?.navigationItem.rightBarButtonItem?.setTitleTextAttributes(buttonAttribute, for: .normal)
//
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = CGSize(width: self.view.bounds.width, height: 60)
//        layout.scrollDirection = .horizontal
//
//        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: Double(view.frame.width), height: height2!), collectionViewLayout: layout)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.isDirectionalLockEnabled = true
//        collectionView.backgroundColor = .clear
//
//        collectionView.register(FavouriteCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//
//        view.addSubview(collectionView)
//
//
//
//
//
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
////        locationManager.startUpdatingLocation()
////        gettingCorrectBusStopData()
//        refreshLoadData()
//        collectionView.reloadData()
//    }
//
//    func refreshLoadData(){
//        favourtieArray = handleLoadDataFromNSCoding()
//        var count = 0
//        if favourtieArray.count == 0{
//
//            self.removedArray.removeAll()
//            self.collectionView?.reloadData()
//
//        }else{
//            for item in favourtieArray{
//                count = count + 1
//                if count == favourtieArray.count{
//
//                    setupBusTimingData(cellBusStopCode: item.busStopCode!, completed: {self.gettingCorrectBusStopData(); self.collectionView.reloadData()})
//
//                }else{
//                    setupBusTimingData(cellBusStopCode: item.busStopCode!, completed: {})}
//            }
//
//
//        }
//    }
//
//
//
//
//    fileprivate func handleLoadDataFromNSCoding() -> [favourite] {
////        let array = loadData()
////        var returningThisArray = [favourite]()
////        if array == nil || array == []{
////            returningThisArray = []
////        }else{
////            returningThisArray = array!
////        }
//
////        var returningThis = [favourite]()
////
////        NSKeyedUnarchiver.setClass(favourite.self, forClassName: "favourite")
////
////        if let myArray = UserDefaults.init(suiteName: "group.com.Sweesen.myWidget")?.value(forKey: "key2"){
////
////            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: myArray as! Data) as! [favourite]
////            returningThis = decodedTeams
////
////            print(decodedTeams)
////        }
////
////
////
////        return returningThis
//     //   return returningThisArray
////
//        let item = UserDefaults.init(suiteName: "group.com.Sweesen.myWidget")?.value(forKey: "widget1") as! NSArray
//        let busStopCode = item.lastObject as! String
//        var favArray = [favourite]()
//
//
//        for it in item{
//            if (it as? String)?.count != 5{
//            favArray.removeAll()
//            favArray.append(favourite(busStopCode: busStopCode, bus: it as? String, image: nil)!)
//            }
//        }
//        return favArray
//
//    }
//
//
//
//    func setupBusTimingData(cellBusStopCode: String, completed: @escaping () -> ()){
//
//        let jsonURL = "http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode="+cellBusStopCode
//        let myurl = URL(string: jsonURL)
//        var request = URLRequest(url: myurl!)
//        request.httpMethod = "GET"
//        request.setValue("Ka8eRytUQ0+nCYDEs2n0fw==", forHTTPHeaderField: "AccountKey")
//
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            do{
//                var insideVariable: BusStopTiming
//                insideVariable = try JSONDecoder().decode(BusStopTiming.self, from: data!)
//                self.mainBusTimings.append(mainBusTiming(busStopCode: cellBusStopCode, busTimings: insideVariable.Services))
//                DispatchQueue.main.async {
//                    completed()
//                }
//            }
//            catch{
//                print("error getting bus timing info")
//            }
//
//            }.resume()
//
//    }
//
//
//
////    private func loadData() -> [favourite]?  {
////        return NSKeyedUnarchiver.unarchiveObject(withFile: favourite.ArchiveURL.path) as? [favourite]
////    }
//
//
//
//
//
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        //        var busStopCodeArray = [String]()
//        //        for item in favourtieArray{
//        //            if item.image == nil{busStopCodeArray.append(item.busStopCode!)}
//        //        }
//        //        let removedArray = busStopCodeArray.removeDuplicates()
//        //
//        return removedArray.count
//    }
//
//    func gettingCorrectBusStopData(){
//        var busStopCodeArray = [String]()
//        for item in favourtieArray{
//            if item.image == nil{busStopCodeArray.append(item.busStopCode!)}
//        }
//        let anything = sortBusStopsStringArray(busStopStrings: busStopCodeArray.removeDuplicates())
//        removedArray = anything
//    }
//
//
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        //        var busStopCodeArray = [String]()
//        //        for item in favourtieArray{
//        //            if item.image == nil{busStopCodeArray.append(item.busStopCode!)}
//        //        }
//        //        let removedArray = sortBusStopsStringArray(busStopStrings: busStopCodeArray.removeDuplicates())
//        //      //  let removedArray = busStopCodeArray.removeDuplicates()
//        //  gettingCorrectBusStopData()
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavouriteCollectionViewCell
//      //  cell.imageView.image = nil
//        cell.cellBusStopCode = removedArray[indexPath.row]
//        print(removedArray)
//    //    cell.busStopCodeTextView.text = removedArray[indexPath.row]
//
//        for item in mainBusTimings{
//            if item.busStopCode == removedArray[indexPath.row]{
//                cell.busTimings = item.busTimings
//            }
//        }
//
//        for busStop in globalBusStopsVariable{
//            if busStop.BusStopCode == removedArray[indexPath.row]{
//                cell.busStopDescriptionView.text = busStop.Description
//       //         cell.busStopRoadNameView.text = busStop.RoadName
//                cell.cellLatitude = Double(busStop.Latitude)
//                cell.cellLongitude = Double(busStop.Longitude)
//            }
//        }
//
//        cell.backgroundColor = .lightGray
//
//        buses.removeAll()
//        for item in favourtieArray{
//            if item.busStopCode == removedArray[indexPath.row]{
//
//                if let bus = item.bus{
//                    buses.append(bus)}
//              //  if item.image != nil{cell.imageView.image = item.image}
//            }
//        }
//
//        cell.tableArray = buses
//        return cell
//    }
//
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(lineSpacing!)
//    }
//
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
//
//
////
////    func saveDataHere(array: [favourite]) {
////        _ = NSKeyedArchiver.archiveRootObject(array, toFile: favourite.ArchiveURL.path)
////    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            userLatitude = location.coordinate.latitude
//            userLongitude = location.coordinate.longitude
//            gettingCorrectBusStopData()
//        }
//
//        if locations.count == 5{
//            self.locationManager.stopUpdatingLocation()
//        }
//
//    }
//
//    func CLStartUpdatingIfAvailable(){
//        locationManager.requestAlwaysAuthorization()
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
//            locationManager.startUpdatingLocation()
//
//        }
//    }
//
//    func assigningBusStopDistanceProperty(busStopsArray: [BusStop]) -> [BusStop]{
//        var temporary = [BusStop]()
//        for busStop in busStopsArray{
//            var insideBusStop = busStop
//            insideBusStop.Distance = busStop.calculateDistance(latitude: userLatitude, longitude: userLongitude, busStopLatitude: Double(busStop.Latitude), busStopLongitude: -Double(busStop.Longitude))
//            temporary.append(insideBusStop)
//        }
//        return temporary
//    }
//
//    func sortBusStopsStringArray(busStopStrings: [String])->[String]{
//        let busStopVariable = globalBusStopsVariable
//        var busStopsSorted = assigningBusStopDistanceProperty(busStopsArray: busStopVariable)
//        busStopsSorted.sort{$0.Distance! < $1.Distance!}
//        var returningThisStringArray = [String]()
//
//        for item in busStopsSorted{
//            for item2 in busStopStrings{
//                if item2 == item.BusStopCode{
//                    returningThisStringArray.append(item2)
//                }
//            }
//        }
//
//        return returningThisStringArray
//    }
//
//    func getBusStopsInfo() -> [BusStop] {
//        var busStops = [BusStop]()
//        let path = Bundle.main.path(forResource: "BusStops1 2", ofType: "json")
//        let url = URL(fileURLWithPath: path!)
//        do{
//            let data = try Data(contentsOf: url)
//            let insideBusStops = try JSONDecoder().decode(main.self, from: data)
//            busStops = insideBusStops.BusStops
//        }
//        catch{print("error getting busstops info")}
//        return busStops
//    }
//
//
//    //
//    //    func helpMapingBusStopsDistance(myFavourite:[favourite])->[favourite]{
//    //
//    //        var returningThisFavourtie = [BusStop]()
//    //        var returiningThisFavourtieofTypefavorutie = [favourite]()
//    //        for item in myFavourite{
//    //            for item2 in globalBusStopsVariable{
//    //                if item.busStopCode == item2.BusStopCode{returningThisFavourtie.append(item2)}
//    //            }
//    //        }
//    //        returningThisFavourtie
//    //        returningThisFavourtie.sort{$0.Distance! < $1.Distance!}
//    //
//    //        return []
//    //    }
//
//
//    var busStopNumber: String?
//
//
//
//
//
//
////    override func didReceiveMemoryWarning() {
////        super.didReceiveMemoryWarning()
////        // Dispose of any resources that can be recreated.
////    }
////
////
////
////    // MARK: UICollectionViewDataSource
////
////    func numberOfSections(in collectionView: UICollectionView) -> Int {
////        // #warning Incomplete implementation, return the number of sections
////        return 1
////    }
////
////
////    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        // #warning Incomplete implementation, return the number of items
////        return 4
////    }
////
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
////
////        if indexPath.row % 2 == 0{
////            cell.backgroundColor = .green
////        }else{
////            cell.backgroundColor = .yellow
////        }
////
////        return cell
////    }
////
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return CGSize(width: self.view.bounds.width, height: 500)
////    }
////
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
////        return 0
////    }
////
////
////
//    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
//
//        if activeDisplayMode == .expanded{
//            self.preferredContentSize = CGSize(width: view.frame.width, height: CGFloat(height2!))
//        }else{
//            self.preferredContentSize = maxSize
//        }
//    }
////
//    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
//        // Perform any setup necessary in order to update the view.
//
//        // If an error is encountered, use NCUpdateResult.Failed
//        // If there's no update required, use NCUpdateResult.NoData
//        // If there's an update, use NCUpdateResult.NewData
//
//        completionHandler(NCUpdateResult.newData)
//    }
////
////}
////
////class widgetCollectionCell:UICollectionViewCell{
////
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////        setupNextButton()
////    }
////
////    func setupNextButton(){
////        let button = UIButton()
////        button.setTitle("Next", for: .normal)
////        button.backgroundColor = .yellow
////        button.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
////        self.addSubview(button)
////    }
////
////    required init?(coder aDecoder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
//
//}
//
//
//
