//
//  FavouriteViewController.swift
//  BusStops
//
//  Created by Koh Sweesen on 27/5/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMobileAds


struct insideFavor{
    let busStopCode: String?
    let buses: [String?]
}

struct mainBusTiming{
    let busStopCode: String?
    let busTimings: [Service]
}

enum Keys:String {
    case shouldSortBusStopByLocationInFavouriteKey
    case themeSwitchKey
}

var globalBusStopsVariable = [BusStop]()
var sortedBusStopsNearby = [BusStop]()

var isThereNewFavouriteData = false
var shouldSortBusStopsByLocationInFavourtie = true{
    didSet{
        shouldReloadBusStopData = true
    }
}
var shouldReloadBusStopData = false

var userDidEnterBackGround = false

var userLatitude:Double = 0
var userLongitude:Double = 0

class FavouriteViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate,GADBannerViewDelegate {
    
    var favourtieArray = [favourite]()
    var buses = [String]()
    var mainBusTimings = [mainBusTiming]()
    var timer: Timer!
    var dataArray = [favourite]()
    let refreshControl = UIRefreshControl()
    var removedArray = [String]()
    let locationManager = CLLocationManager()
    var bannerView:GADBannerView!
    var wallpaperRandomNumbers = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wallpaperRandomNumbers = createRandomNumberForWallpapers()
        
        if isLaunchedBefore == false{
            
            let flowlayout = UICollectionViewFlowLayout()
            flowlayout.scrollDirection = .horizontal
            let tutorialVC = TutorialCollectionViewController(collectionViewLayout: flowlayout)
            present(tutorialVC, animated: true, completion: nil)
            isLaunchedBefore = true
        }
        

        
        locationManager.startUpdatingLocation()
        favourtieArray = handleLoadDataFromNSCoding()
        CLStartUpdatingIfAvailable()
        gettingCorrectBusStopData()
        
     //   self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.title = ""
        let attribute = [NSAttributedStringKey.foregroundColor:currentTheme.navTitleTextColor]
        self.navigationController?.navigationBar.titleTextAttributes = attribute
        self.navigationController?.navigationBar.largeTitleTextAttributes = attribute
//        let buttonAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        self.navigationController?.navigationItem.rightBarButtonItem?.setTitleTextAttributes(buttonAttribute, for: .normal)
        self.collectionView?.backgroundColor = currentTheme.favouriteVCBackground
        self.collectionView?.isDirectionalLockEnabled = true
        self.collectionView?.showsVerticalScrollIndicator = false

        
        refreshControl.addTarget(self, action: #selector(refreshLoadData), for: .valueChanged)
        refreshControl.tintColor = currentTheme.navTitleTextColor
        self.collectionView?.refreshControl = refreshControl
        collectionView?.register(FavouriteCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
       
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        
        refreshLoadData()
        
        let rightReloadButton = UIBarButtonItem(title: "Reload all", style: .plain, target: self, action: #selector(handleRefreshButton))
        rightReloadButton.tintColor = currentTheme.navTitleTextColor
       // self.navigationItem.rightBarButtonItem = rightReloadButton
        
        
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
     //   bannerView.adUnitID = "ca-app-pub-1212819575262556/7294156963"
        bannerView.rootViewController = self
        bannerView.delegate = self
    //    let request = GADRequest()
   //     request.testDevices = [kGADSimulatorID]
     //   bannerView.load(request)
        bannerView.removeFromSuperview()
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        bannerView.backgroundColor = .black
        bannerView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.view.safeAreaLayoutGuide.bottomAnchor, BottomPadding: 0, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: nil, RightPadding: 0, ViewWidth: nil, ViewHeight: nil, CentreXAnchor: self.view.centerXAnchor, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
        gettingCorrectBusStopData()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.barTintColor = currentTheme.navBarColor
        self.tabBarController?.tabBar.barStyle = .black
        
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .defaultPrompt)
        navigationController?.navigationBar.isHidden = true
        
        self.collectionView?.backgroundColor = currentTheme.favouriteVCBackground
        

//
        if isThereNewFavouriteData == true{
            self.handleRefreshButton()
            isThereNewFavouriteData = false
        }
        
        if shouldReloadBusStopData ==  true{
            gettingCorrectBusStopData()
            self.refreshLoadData()
            shouldReloadBusStopData = false
        }
        
        if userDidEnterBackGround == true{
            self.refreshLoadData()
            userDidEnterBackGround = false
            print("user is back")
        }
        

        
        
//        setupMapView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }
    
    let backgroundView = UITextView()
    func setupViewForEmptyFavourtie(){
        
        self.view.addSubview(backgroundView)
        backgroundView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: self.view.leftAnchor, LeftPadding: 0, RightAnchorTo: self.view.rightAnchor, RightPadding: 0, ViewWidth: nil, ViewHeight: 100, CentreXAnchor: nil, CentreYAnchor: self.view.centerYAnchor, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        
        backgroundView.text = "Go ahead and add some buses as favourites now!"
        backgroundView.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.light)
        backgroundView.textColor = .white
        backgroundView.backgroundColor = .gray
        backgroundView.textAlignment = .center
        
        
    }
    

    let loadingView:UIView = {
        let loading = UIView()
        loading.backgroundColor = .black
        loading.alpha = 0.7
        return loading
    }()

    let window = (UIApplication.shared.keyWindow)!
    
    func setupLoadingView(){
        window.addSubview(loadingView)
        self.loadingView.frame = CGRect(x: 0, y: self.window.frame.height, width: self.window.frame.width, height: self.window.frame.height)
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.loadingView.frame = self.window.frame
        }, completion: nil)
    }

    var activityIndicatorLoadView: UIActivityIndicatorView?
    
    func removeLoadView(){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            self.loadingView.frame = CGRect(x: 0, y: self.window.frame.height, width: self.window.frame.width, height: self.window.frame.height)
            
            }, completion: nil)
    }
    
    fileprivate func handleLoadDataFromNSCoding() -> [favourite] {
        let array = loadData()
        var returningThisArray = [favourite]()
        if array == nil || array == []{
            returningThisArray = []
        }else{
            returningThisArray = array!
        }
        return returningThisArray
    }
    
    
    
    @objc func handleRefreshButton(){
        
            setupLoadingView()
            refreshLoadData()
        
        
//        removedArray.append("yes")
//        self.collectionView?.insertItems(at: [IndexPath(row: 4, section: 0)])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        buses.removeAll()
        for item in favourtieArray{
            if item.busStopCode == removedArray[indexPath.row]{
                
                if let bus = item.bus{
                    buses.append(bus)
                }
            }
        }
        
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(150 + (buses.count * 70)))
    }
    

    

    
    @objc func refreshLoadData(){
        favourtieArray = handleLoadDataFromNSCoding()
        var count = 0
        if favourtieArray.count == 0{
            self.removeLoadView()
            self.removedArray.removeAll()
            self.collectionView?.reloadData()
            
        }else{
        for item in favourtieArray{
            count = count + 1
            if count == favourtieArray.count{
                
                setupBusTimingData(cellBusStopCode: item.busStopCode!, completed: {_ in self.gettingCorrectBusStopData(); self.collectionView?.reloadData();self.removeLoadView()})
                
            }else{
                setupBusTimingData(cellBusStopCode: item.busStopCode!, completed: {_ in })}
        }
        

        
        }
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(stopRefreshing), userInfo: nil, repeats: false)
    }
    
    @objc func stopRefreshing(){
        self.refreshControl.endRefreshing()
        self.removeLoadView()
    }
    
    func setupBusTimingData(cellBusStopCode: String, completed: @escaping (Error?) -> ()){

        let jsonURL = "http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode="+cellBusStopCode
        let myurl = URL(string: jsonURL)
        var request = URLRequest(url: myurl!)
        var newBusTiming = [mainBusTiming]()
        request.httpMethod = "GET"
        request.setValue("Ka8eRytUQ0+nCYDEs2n0fw==", forHTTPHeaderField: "AccountKey")

    
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in

            
            do{
                var insideVariable: BusStopTiming
 
                guard error == nil else{
                    print("guard error error")
                    
                    
                    DispatchQueue.main.async {
                        self.mainBusTimings = []
                         self.collectionView?.reloadData()
                    }
                   
                    return
                }
                
                if data != nil{
                    if let data2 = try JSONDecoder().decode(BusStopTiming?.self, from: data!){
                        insideVariable = data2
                        
                        for item in self.mainBusTimings{
                            if item.busStopCode != cellBusStopCode{
                                newBusTiming.append(item)
                            }
                        }
                        
                        self.mainBusTimings = newBusTiming
                        
                        self.mainBusTimings.append(mainBusTiming(busStopCode: cellBusStopCode, busTimings: insideVariable.Services))
                    }
                }

                DispatchQueue.main.async {
                    
                    completed(nil)
                }
            }
            catch{
                print("error getting bus timing info")
            }

            }.resume()
        
    }
    

    
    private func loadData() -> [favourite]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: favourite.ArchiveURL.path) as? [favourite]
    }
    

    
    


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        var busStopCodeArray = [String]()
//        for item in favourtieArray{
//            if item.image == nil{busStopCodeArray.append(item.busStopCode!)}
//        }
//        let removedArray = busStopCodeArray.removeDuplicates()
//
        if removedArray.count == 0{
            setupViewForEmptyFavourtie()
        }else{
            backgroundView.removeFromSuperview()
        }
        
        return removedArray.count
    }
    
    func gettingCorrectBusStopData(){
        var busStopCodeArray = [String]()
        for item in favourtieArray{
            if item.image == nil{busStopCodeArray.append(item.busStopCode!)}
        }
        
        if shouldSortBusStopsByLocationInFavourtie == true{
            let anything = sortBusStopsStringArray(busStopStrings: busStopCodeArray.removeDuplicates())
            removedArray = anything
        }else{
            removedArray = busStopCodeArray.removeDuplicates()
        }
        

//        UIView.animate(withDuration: 0.15, delay: 2, options: .curveEaseOut, animations: {
//            launchView.frame = CGRect(x: 0, y: -Double(UIScreen.main.bounds.height), width: Double(launchView.frame.width), height: Double(launchView.frame.height))
//        }, completion: nil)
    }
    

    
    let wallpapers = [
    
        UIImage(named: "wallpaper"),
        UIImage(named: "wallpaper2"),
        UIImage(named: "wallpaper3"),
        UIImage(named: "wallpaper4"),
        UIImage(named: "wallpaper5"),
        UIImage(named: "wallpaper6"),
        UIImage(named: "wallpaper7"),
        UIImage(named: "wallpaper8"),
        UIImage(named: "wallpaper9"),
        UIImage(named: "wallpaper10"),
        UIImage(named: "wallpaper11"),
        UIImage(named: "wallpaper12")
        
        
    ]
    
    
    func createRandomNumberForWallpapers() -> [Int]{
        
        var integers = [Int]()
        
        for _ in 0...100{
            
            let number = Int(arc4random_uniform(UInt32(wallpapers.count)))
            integers.append(number)
            
        }
        return integers
    }
    
//    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//
//
//    }
    
//    func collectionView
//
//    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        self.collectionView?.backgroundColor = wallpapers[wallpaperRandomNumbers[indexPath.row]]?.averageColor
//    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? FavouriteCollectionViewCell
        cell?.isHighlighted = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        var busStopCodeArray = [String]()
//        for item in favourtieArray{
//            if item.image == nil{busStopCodeArray.append(item.busStopCode!)}
//        }
//        let removedArray = sortBusStopsStringArray(busStopStrings: busStopCodeArray.removeDuplicates())
//      //  let removedArray = busStopCodeArray.removeDuplicates()
      //  gettingCorrectBusStopData()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavouriteCollectionViewCell
        
//        if indexPath.row % 2 == 0{
//            cell.imageView.image = UIImage(named: "wallpaper2")
//            cell.tableView.backgroundView = UIImageView(image: UIImage(named: "wallpaper2"))
//        }else{
//            cell.imageView.image = UIImage(named: "wallpaper")
//            cell.tableView.backgroundView = UIImageView(image: UIImage(named: "wallpaper"))
//        }
//
      //  let image = wallpapers[Int(arc4random_uniform(UInt32(wallpapers.count)))]
        
        cell.imageView.image = wallpapers[wallpaperRandomNumbers[indexPath.row]]
        cell.tableView.backgroundView = UIImageView(image: wallpapers[wallpaperRandomNumbers[indexPath.row]])
        cell.deletedelegate = self
        cell.alertDelegate = self
        cell.intermediateDelegate = self
        cell.cellNumber = indexPath.row
        cell.cellBusStopCode = removedArray[indexPath.row]
        cell.busStopCodeTextView.text = removedArray[indexPath.row]
        cell.busTimings = []
        cell.mapView.removeFromSuperview()
        cell.tableView.allowsSelection = false
        
        
        for item in mainBusTimings{
            if item.busStopCode == removedArray[indexPath.row]{
                cell.busTimings = item.busTimings
            }
        }
        
        for busStop in globalBusStopsVariable{
            if busStop.BusStopCode == removedArray[indexPath.row]{
                cell.busStopDescriptionView.text = busStop.Description
                cell.busStopRoadNameView.text = busStop.RoadName
                cell.cellLatitude = Double(busStop.Latitude)
                cell.cellLongitude = Double(busStop.Longitude)
            }
        }
        
        cell.backgroundColor = .lightGray
        
        buses.removeAll()
        for item in favourtieArray{
            if item.busStopCode == cell.busStopCodeTextView.text{
                
                if let bus = item.bus{
                    buses.append(bus)}
                if item.image != nil{cell.imageView.image = item.image}
            }
        }
        
        cell.tableArray = buses
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var busStopCodeArray = [String]()
        for item in favourtieArray{
            if item.image == nil{busStopCodeArray.append(item.busStopCode!)}
        }
        let removedArray = sortBusStopsStringArray(busStopStrings: busStopCodeArray.removeDuplicates())

        var thisBusStop: BusStop?
        for busStop in globalBusStopsVariable{
            if removedArray[indexPath.row] == busStop.BusStopCode{
                thisBusStop = busStop
            }
        }
        
        let cell = self.collectionView?.cellForItem(at: indexPath) as? FavouriteCollectionViewCell
        cell?.isHighlighted = false
        cell?.isSelected = false
        
        let TimingViewController = ViewController()
        TimingViewController.busStopCode = cell?.busStopCodeTextView.text
        TimingViewController.navigationItem.title = cell?.busStopDescriptionView.text
        TimingViewController.roadName = cell?.busStopRoadNameView.text
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(TimingViewController, animated: true)

//
//        let navController = UINavigationController(rootViewController: ChooseTodayViewDataVC())
//        self.present(navController, animated: true, completion: nil)
//
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        

        return UIEdgeInsetsMake(15, 0, 60, 0)
        
        
    }
    
    func saveDataHere(array: [favourite]) {
        _ = NSKeyedArchiver.archiveRootObject(array, toFile: favourite.ArchiveURL.path)
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: array)
        UserDefaults.init(suiteName: "group.com.Sweesen.myWidget")?.setValue(encodedData, forKey: "key2")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLatitude = location.coordinate.latitude
            userLongitude = location.coordinate.longitude
            gettingCorrectBusStopData()
        }
        
        print(locations.count)
        
        if locations.count > 0{
            self.locationManager.stopUpdatingLocation()
        }
        
        print("location requested")
        
    }
    
    func CLStartUpdatingIfAvailable(){
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func assigningBusStopDistanceProperty(busStopsArray: [BusStop]) -> [BusStop]{
        var temporary = [BusStop]()
        for busStop in busStopsArray{
            var insideBusStop = busStop
            insideBusStop.Distance = busStop.calculateDistance(latitude: userLatitude, longitude: userLongitude, busStopLatitude: Double(busStop.Latitude), busStopLongitude: Double(busStop.Longitude))
            temporary.append(insideBusStop)
        }
        return temporary
    }
    
    func sortBusStopsStringArray(busStopStrings: [String])->[String]{
        let busStopVariable = globalBusStopsVariable
        var returningThisStringArray = [BusStop]()
        var returningThisString = [String]()
        
        for item in busStopVariable{
            for item2 in busStopStrings{
                if item2 == item.BusStopCode{
                    returningThisStringArray.append(item)
                }
            }
        }
        
        var busStopsSorted = assigningBusStopDistanceProperty(busStopsArray: returningThisStringArray)
        busStopsSorted.sort{$0.Distance! < $1.Distance!}
        
        for item in busStopsSorted{
            for item2 in busStopStrings{
                if item2 == item.BusStopCode{
                    returningThisString.append(item2)
                }
            }
        }
        
//        for item in busStopsSorted{
//            for item2 in busStopStrings{
//                if item2 == item.BusStopCode{
//                    returningThisStringArray.append(item2)
//                }
//            }
//        }
        
        return returningThisString
    }
    

//    
//    func helpMapingBusStopsDistance(myFavourite:[favourite])->[favourite]{
//        
//        var returningThisFavourtie = [BusStop]()
//        var returiningThisFavourtieofTypefavorutie = [favourite]()
//        for item in myFavourite{
//            for item2 in globalBusStopsVariable{
//                if item.busStopCode == item2.BusStopCode{returningThisFavourtie.append(item2)}
//            }
//        }
//        returningThisFavourtie
//        returningThisFavourtie.sort{$0.Distance! < $1.Distance!}
//        
//        return []
//    }
    
    
    var busStopNumber: String?
        var cellNumberHere:Int?

    
            
}

extension FavouriteViewController: deleteCellUpdateDelegate{
    func updateCollectionViewCell(arrayToSave: [favourite]) {
 
        
//        window.addSubview(loadingView)
//        self.loadingView.frame = CGRect(x: 0, y: self.window.frame.height, width: self.window.frame.width, height: self.window.frame.height)
//        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.loadingView.frame = self.window.frame
//        }, completion: {(action) in
//
//            self.saveDataHere(array: arrayToSave);
//            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
//                self.loadingView.frame = CGRect(x: 0, y: self.window.frame.height, width: self.window.frame.width, height: self.window.frame.height)
//            }
//        , completion: nil)
//
//            self.favourtieArray.removeAll()
//            let array = self.loadData()
//            if array == nil || array == []{
//                self.favourtieArray = []
//            }else{
//                self.favourtieArray = array!
//            }
//
//            self.refreshLoadData()
//        }
//
//
//
//
//
//
//    )}
        
//        DispatchQueue.global(qos: .background).async {
//        self.saveDataHere(array: arrayToSave)
//      }
        self.saveDataHere(array: arrayToSave)
        savingBusesToUserDefaults(favouriteArray: arrayToSave)
        
        self.favourtieArray.removeAll()
        let array = self.loadData()
        if array == nil || array == []{
            self.favourtieArray = []
            }else{
            self.favourtieArray = array!
        }
        self.handleRefreshButton()
        
    }
    

}

extension FavouriteViewController: IntermediateDelegate{
    
    func askRootToRefreshLoadData(favCellNumber:Int,busStopCode:String) {
        
        var insideNewBusTimings = [mainBusTiming]()
        
        for item in mainBusTimings{
            if item.busStopCode != busStopCode{
                insideNewBusTimings.append(item)
            }
        }
   

        mainBusTimings = insideNewBusTimings
        
        self.refreshLoadData()
        self.setupBusTimingData(cellBusStopCode: busStopCode) {_ in
            self.collectionView?.reloadItems(at: [IndexPath(row: favCellNumber, section: 0)])
        }
//        let cell = collectionView?.cellForItem(at: IndexPath(row: favCellNumber, section: 0)) as? FavouriteCollectionViewCell
//        
//        UIView.animate(withDuration: 0.5) {
//            self.collectionView?.backgroundColor = cell?.imageView.image?.averageColor
//        }
        
        
        
    }
    
    
}

    
    


extension FavouriteViewController: presentAlertController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   

    func createAlertController(busStopCode: String,cellNumber:Int) {
        
        let popUpWindow = UIAlertController(title: "Choose Image", message: "Choose from which location?", preferredStyle: .alert)
        popUpWindow.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action) in (self.handleChoosingFromCamera())}))
        self.present(popUpWindow, animated: true, completion: nil)
        popUpWindow.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(action) in self.handleChoosingFromGallery()}))
        popUpWindow.addAction(UIAlertAction(title: "Google Street View", style: .destructive, handler: {(action) in self.handleChoosingFromGoogle()}))
        popUpWindow.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in self.dismiss(animated: true, completion: nil)}))
        popUpWindow.addAction(UIAlertAction(title: "Remove Image", style: .default, handler: {(action) in self.handleRemoveImage(at: busStopCode)}))

        self.busStopNumber = busStopCode
        self.cellNumberHere = cellNumber
    }
    
    
    
    func handleChoosingFromCamera(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func handleChoosingFromGallery(){
        print("gallery")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func handleChoosingFromGoogle(){
        let busStops = globalBusStopsVariable
        var latitude: Float?
        var longitude:Float?
        for item in busStops{
            if item.BusStopCode == busStopNumber{latitude = item.Latitude;longitude = item.Longitude}
        }
        let streetVC = StreetViewController()
        streetVC.latitudeHere = latitude
        streetVC.longitudeHere = longitude
        self.navigationController?.pushViewController(streetVC, animated: true)
    }
    

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        var newArray = [favourite]()
        
        for item in favourtieArray{
            if item.busStopCode == busStopNumber && item.image != nil{}else{
                newArray.append(item)
            }
        }
        let favor = favourite(busStopCode: busStopNumber, bus: nil, image: image)
        newArray.append(favor!)
        saveDataHere(array: newArray)
        self.dismiss(animated: true, completion: {
             self.handleRefreshButton()
        
//            let cell = self.collectionView?.cellForItem(at: IndexPath(row: self.cellNumberHere!, section: 0)) as? FavouriteCollectionViewCell
//            cell?.imageView.image = image
//            self.collectionView?.reloadItems(at: [IndexPath(row: self.cellNumberHere!, section: 0)])
//            self.setupBusTimingData(cellBusStopCode: self.busStopNumber!) {
//                self.collectionView?.reloadItems(at: [IndexPath(row: self.cellNumberHere!, section: 0)])
//            }
        
        })
    
            
        }
    
    func handleRemoveImage(at busStop: String){
        
        var newArray = [favourite]()
        
        if let data = loadData(){
            
            for item in data{
                if item.busStopCode == busStop{
                    newArray.append(favourite(busStopCode: item.busStopCode, bus: item.bus, image: nil)!)
                }else{
                    newArray.append(item)
                }
            }
        }
        
        saveDataHere(array: newArray)
        savingBusesToUserDefaults(favouriteArray: newArray)
        self.refreshLoadData()
        
    }
    
}

func savingBusesToUserDefaults(favouriteArray: [favourite]){
    
    var savingThisToUSerDefaults = [String]()
    
    for item in favouriteArray{
        
        if item.bus != nil{
            savingThisToUSerDefaults.append(item.bus!)
            savingThisToUSerDefaults.append(item.busStopCode!)
        }
    }
    
    UserDefaults.init(suiteName: "group.com.Sweesen.myWidget")?.setValue(savingThisToUSerDefaults, forKey: "widget1")
}


