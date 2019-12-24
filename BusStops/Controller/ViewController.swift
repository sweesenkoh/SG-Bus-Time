//
//  ViewController.swift
//  BusStops
//
//  Created by Koh Sweesen on 23/5/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
// tis is cool

import UIKit
import GoogleMobileAds

var me = [BusRoute]()

extension ViewController:refreshLoadDataAfterBusTimingViewTapped{
    func refreshLoadDataAfterBusTimingViewTapped(tag: Int) {
        self.handleRefreshFromDelegate(tag: tag)
    }
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate {

  
    var busStopCode:String?
  //  var busRoutes = [BusRoute]()
    var filteredBusRoute = [BusRoute]()
    var sortedFilteredBusRoute = [BusRoute]()
    var busTimings = [Service]()
    let indicator = UIActivityIndicatorView()
    var timer: Timer!
    var bannerView: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = currentTheme.tableViewCellColor
        setupTableView()
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationController?.hero.isEnabled = true
        
        navigationController?.navigationBar.barTintColor = currentTheme.navBarColor
       // navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: <#T##UIBarMetrics#>)
        
        self.tabBarController?.tabBar.isHidden = true
        self.indicator.startAnimating()
        findingBusesForThisBusStop()
        setupBusTimingData{self.tableView.reloadData();self.indicator.stopAnimating()}
        tableView.register(tableViewCustomCell.self, forCellReuseIdentifier: "cell")
        setupnavigationBarItem()
        setupIndicatorView()
        self.view.backgroundColor = currentTheme.tableViewCellColor
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(handleReloadButton), userInfo: nil, repeats: true)
    
        
//        refreshControl = UIRefreshControl()
//        refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
//        refreshControl?.tintColor = currentTheme.navTitleTextColor
////
   
        if let savedData = loadData(){ //saved data is just a random variable
            newArray += savedData
        }
        
        self.tableView.separatorColor = currentTheme.tableViewSeparatorColor
        self.tableView.separatorInset = .init(top: 100, left: 5, bottom: 0, right: 5)
//        self.tableView.allowsSelection = false
        
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
      //  bannerView.adUnitID = "ca-app-pub-1212819575262556/3551171316"
        bannerView.rootViewController = self
        bannerView.delegate = self
      //  let request = GADRequest()
    //    request.testDevices = [kGADSimulatorID]
      //    bannerView.load(request)
        bannerView.removeFromSuperview()
    
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        bannerView.backgroundColor = .black
        bannerView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.view.bottomAnchor, BottomPadding: 0, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: nil, RightPadding: 0, ViewWidth: nil, ViewHeight: nil, CentreXAnchor: self.view.centerXAnchor, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    let tableView = UITableView()
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height - 50) //-50
        self.view.addSubview(tableView)
    }
    
    @objc func handleRefreshControl(){
      //  refreshControl?.beginRefreshing()
        setupBusTimingData{
            
            let sectionToReload = 0
            let indexSet: IndexSet = [sectionToReload]
            self.tableView.reloadSections(indexSet, with: .none)
            self.indicator.stopAnimating();
          //  self.refreshControl?.endRefreshing()
            
        }
    }
    
    func handleRefreshFromDelegate(tag:Int){
        
        setupBusTimingData {
            self.tableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        self.tabBarController?.tabBar.isHidden = false
    }

    
    var newArray = [favourite]()
    
    //persist Data
    func saveData() {
       
        DispatchQueue.global(qos: .background).async {
            _ = NSKeyedArchiver.archiveRootObject(self.newArray, toFile: favourite.ArchiveURL.path)
           
        }
      //  NSKeyedArchiver.setClassName("favourite22", for: favourite.self)
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.newArray)
//        userDefaults.set(encodedData, forKey: "data")
//        userDefaults.synchronize()
        UserDefaults.init(suiteName: "group.com.Sweesen.myWidget")?.setValue(encodedData, forKey: "key2")
        
    }
    
    func setupIndicatorView(){
       
        self.Headview.addSubview(indicator)
        if currentTheme == darkTheme{
            indicator.activityIndicatorViewStyle = .white
        }else{
            indicator.activityIndicatorViewStyle = .gray
        }
        indicator.setupConstraint(TopAnchorTo: self.Headview.topAnchor, TopPadding: 0, BottomAnchorTo: self.Headview.bottomAnchor, BottomPadding: 0, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 150, ViewHeight: nil, CentreXAnchor: self.Headview.centerXAnchor, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    func setupnavigationBarItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reload all", style: .plain, target: self, action: #selector(handleReloadButton))
    }
    
    
    @objc func handleReloadButton(){
        self.indicator.startAnimating()
        setupBusTimingData{
            self.indicator.stopAnimating()
            self.tableView.reloadData()
            
        }
    }
    
    //make alert controller indicating added to bookmark
    
    let alertController = UIAlertController(title: "Successfully Added To Your Favourites", message: "", preferredStyle: .actionSheet)
    let failureAlertController = UIAlertController(title: "This is already in your Favourites", message: nil, preferredStyle: .actionSheet)
    
    
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//            let myfavourtie = favourite(busStopCode: busStopCode!, bus: sortedFilteredBusRoute[indexPath.row].ServiceNo!, image: nil)
//
//            var checker = false
//            for item in newArray{
//                if myfavourtie?.bus == item.bus && myfavourtie?.busStopCode == item.busStopCode{
//                    present(failureAlertController, animated: true, completion: {self.startTimerFailure()})
//                    checker = true
//                }
//        }
//            if checker == false{
//                newArray.append(myfavourtie!)
//                saveData()
//                present(alertController, animated: true, completion: {self.startTimer()})
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let addAction = UITableViewRowAction(style: .normal, title: "☆\nFavourite") { (rowAction, indexPath) in
            let myfavourtie = favourite(busStopCode: self.busStopCode!, bus: self.sortedFilteredBusRoute[indexPath.row].ServiceNo!, image: nil)
            
            var checker = false
            for item in self.newArray{
                if myfavourtie?.bus == item.bus && myfavourtie?.busStopCode == item.busStopCode{
                    self.present(self.failureAlertController, animated: true, completion: {self.startTimerFailure()})
                    checker = true
                }
            }
            if checker == false{
                self.newArray.append(myfavourtie!)
                self.present(self.alertController, animated: true, completion: {self.startTimer()})
                isThereNewFavouriteData = true
                savingBusesToUserDefaults(favouriteArray: self.newArray)
            }
        }
        addAction.backgroundColor = .orange
        
        
        
        let busRouteButton = UITableViewRowAction(style: .normal, title: " \nBus Route") { (rowAction, indexPath) in
            
            let vc = GoogleMapBusRouteViewController()
            vc.busNumber = self.self.sortedFilteredBusRoute[indexPath.row].ServiceNo!
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        busRouteButton.backgroundColor = .gray
        
        
        
        
        return [addAction,busRouteButton]
    }
    
//    @objc func deleteActionSheet(){
//        self.dismiss(animated: true, completion: nil)
//    }

    //--------------------------
    var dismissTimer : Timer?
    func startTimer(){
        dismissTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(stopTimer), userInfo: nil, repeats: false)
    }
    
    @objc func stopTimer(){
         self.dismiss(animated: true, completion: {self.saveData()})
    }
    var dismissTimerFailure : Timer?
    func startTimerFailure(){
        dismissTimerFailure = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(stopTimerFailure), userInfo: nil, repeats: false)
    }
    
    @objc func stopTimerFailure(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //______________________
    

    private func loadData() -> [favourite]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: favourite.ArchiveURL.path) as? [favourite]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedFilteredBusRoute.count
    }
    
    var cellNumber = 0{
        didSet{
            if cellNumber == sortedFilteredBusRoute.count{
                cellNumber = 0
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCustomCell
        cell.WABImageView.image = nil
        cell.secondWABImageView.image = nil
        cell.thirdWABImageView.image = nil
        
        cell.cellNumberID = indexPath.row
        cell.reloadDelegate = self
    
        cell.busNumberLabel.text = sortedFilteredBusRoute[indexPath.row].ServiceNo
        cell.cellBusStopCode = busStopCode
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
                
                if cell.secondBusTimingText.text == "Arr" && (cell.busTimingText.text != "Arr"||cell.secondBusTimingText.text != "Left"){
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.tableView.cellForRow(at: indexPath) as! tableViewCustomCell
        cell.isSelected = false
        
        let routeGoogleVC = GoogleMapBusRouteViewController()
        routeGoogleVC.busNumber = sortedFilteredBusRoute[indexPath.row].ServiceNo!
        self.navigationController?.pushViewController(routeGoogleVC, animated: true)
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     let Headview = UIView()
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

//        Headview.backgroundColor = UIColor.init(red: 215/255, green: 215/255, blue: 215/255, alpha: 1)
        Headview.backgroundColor = currentTheme.busTimingVCHeadView
//        Headview.layer.borderWidth = 1
//        Headview.layer.borderColor = currentTheme.navTitleTextColor.cgColor
        createHeaderBar()
        return Headview

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    var roadName : String?
    let roadNameView = UILabel()
    let busCodeView = UILabel()

    
    func createHeaderBar(){
        roadNameView.removeFromSuperview()
        busCodeView.removeFromSuperview()
        
        roadNameView.font = UIFont.systemFont(ofSize: 20)
        roadNameView.text = roadName
        roadNameView.textColor = currentTheme.navTitleTextColor
        //roadNameView.backgroundColor = .yellow
        
        busCodeView.text = busStopCode!
        busCodeView.font = UIFont.systemFont(ofSize: 20)
        //busCodeView.backgroundColor = .yellow
        busCodeView.textAlignment = .center
        busCodeView.textColor = currentTheme.navTitleTextColor
        
        Headview.addSubview(roadNameView)
        Headview.addSubview(busCodeView)
        
        roadNameView.setupConstraint(TopAnchorTo: Headview.topAnchor, TopPadding: 5, BottomAnchorTo: Headview.bottomAnchor, BottomPadding: -5, LeftAnchorTo: Headview.leftAnchor, LeftPadding: 20, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 200, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        busCodeView.setupConstraint(TopAnchorTo: Headview.topAnchor, TopPadding: 5, BottomAnchorTo: Headview.bottomAnchor, BottomPadding: -5, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: Headview.rightAnchor, RightPadding: -15, ViewWidth: 100, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    
    

    
    func findingBusesForThisBusStop() {
        
        filteredBusRoute.removeAll()
        
        for bus in me{
            if bus.BusStopCode == busStopCode{
                filteredBusRoute.append(bus)
                
            }
        }
        sortedFilteredBusRoute = sortingArray(busRouteArray: filteredBusRoute)
        
    }
   
    
    func setupBusTimingData(completed: @escaping () -> ()){
        
        let jsonURL = "http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode="+busStopCode!
        let myurl = URL(string: jsonURL)
        var request = URLRequest(url: myurl!)
        request.httpMethod = "GET"
        request.setValue("Ka8eRytUQ0+nCYDEs2n0fw==", forHTTPHeaderField: "AccountKey")
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            

            do{
                var insideVariable: BusStopTiming?
                
                guard error == nil else{
                    print("guard error error")
                    
                    
                    DispatchQueue.main.async {
                        self.busTimings = []
                        self.tableView.reloadData()
                    }
                    
                    return
                }
                
                
                if data != nil{
                    if let data2 = try JSONDecoder().decode(BusStopTiming?.self, from: data!){
                        insideVariable = data2
                        self.busTimings = (insideVariable?.Services)!
                    }
                }
//                if let data2 = try JSONDecoder().decode(BusStopTiming?.self, from: data!){
//                    insideVariable = data2
//                    self.busTimings = (insideVariable?.Services)!
            
                //}
//                insideVariable = try JSONDecoder().decode(BusStopTiming.self, from: data!)
//                self.busTimings = insideVariable.Services
                
                DispatchQueue.main.async {
                    completed()
                }
            }
            catch{
                print("error getting bus timing info")
            }
            
            }.resume()
        
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



struct separator {
    let busNumber:String
    let busNumberCharacter:String
}







