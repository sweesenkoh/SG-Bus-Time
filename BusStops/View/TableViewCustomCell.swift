//
//  TableViewCustomCell.swift
//  BusStops
//
//  Created by Koh Sweesen on 25/5/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit

class tableViewCustomCell: UITableViewCell {
    
    var cellNumberID : Int?
    var cellBusStopCode: String?
    var isItWAB: Int?{
        didSet{
            let imageWAB = UIImage(named: "WAB")?.withRenderingMode(.alwaysTemplate)
            WABImageView.image = imageWAB
            if currentTheme == darkTheme{
                WABImageView.tintColor = .white
            }else if currentTheme == lightTheme{
                WABImageView.tintColor = .white
            }
        }
    }
    
    var isSecondBusWAB:Int?{
        didSet{
            let imageWAB = UIImage(named: "WAB")?.withRenderingMode(.alwaysTemplate)
            secondWABImageView.image = imageWAB
            if currentTheme == darkTheme{
                secondWABImageView.tintColor = .white
            }else if currentTheme == lightTheme{
                secondWABImageView.tintColor = .white
            }
        }
    }
    
    var isThirdBusWAB:Int?{
        didSet{
            let imageWAB = UIImage(named: "WAB")?.withRenderingMode(.alwaysTemplate)
            thirdWABImageView.image = imageWAB
            if currentTheme == darkTheme{
                thirdWABImageView.tintColor = .white
            }else if currentTheme == lightTheme{
                thirdWABImageView.tintColor = .white
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")
       // self.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.backgroundColor = currentTheme.tableViewCellColor
        
        setupBusNumberLabel()
        setupBlackView()
        setupBusLoadView()
        setupWABImageView()
        setupBusTimingText()
        setupSecondBusLoadView()
        setupSecondBusTimingText()
        setupSecondWABImageView()
        setupThirdBusLoadView()
        setupThirdBusTimingText()
        setupthirdWABImageView()
        


        
        //        var bustiming = [Service]()
        //
        //
        //        for service in bustiming{
        //            if self.busNumberLabel.text == service.ServiceNo{
        //                if service.NextBus.IsBusInService(busStopNo: cellBusStopCode!, busNumber: self.busNumberLabel.text!) == true{
        //                    self.busTimingText.text = "Bus"
        //                }else{
        //                    self.busTimingText.text = "Bus Not In Service"
        //                }
        //            }
        //        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let busNumberLabel : UILabel = {
        let label = UILabel()
        label.textColor = currentTheme.navTitleTextColor
        label.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.thin)
        return label
    }()
    
    func setupBusNumberLabel(){
        self.addSubview(busNumberLabel)
        busNumberLabel.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 5, BottomAnchorTo: self.bottomAnchor, BottomPadding: -5, LeftAnchorTo: self.leftAnchor, LeftPadding: 15, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 100, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    let busTimingBlackView:UIView = {
        let view = UIView()
        view.backgroundColor = currentTheme.busTimingTextViewColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    func setupBlackView(){
        self.addSubview(busTimingBlackView)
        busTimingBlackView.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 5, BottomAnchorTo: self.bottomAnchor, BottomPadding: -5, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.rightAnchor, RightPadding: -5, ViewWidth: 210, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    let busTimingText : UILabel = {
        let text = UILabel()
        text.textColor = UIColor.black
        text.font = UIFont.systemFont(ofSize: 22)
        text.textAlignment = .center
        text.isUserInteractionEnabled = true
        return text
    }()
    
    
    
    func setupBusTimingText(){
        self.addSubview(busTimingText)
        loadingIndicator.removeFromSuperview()
        busTimingText.setupConstraint(TopAnchorTo: self.busTimingBlackView.topAnchor, TopPadding: 3, BottomAnchorTo: self.busLoadView.topAnchor, BottomPadding: -3, LeftAnchorTo: self.busTimingBlackView.leftAnchor, LeftPadding: 0, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 70, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleBusTimingTapped))
        busTimingText.text = nil
        
        busTimingText.addGestureRecognizer(gesture)
    }
    
    let loadingIndicator = UIActivityIndicatorView()
    var reloadDelegate: refreshLoadDataAfterBusTimingViewTapped?
    
    @objc func handleBusTimingTapped(){
        self.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        loadingIndicator.frame = busTimingBlackView.frame
        self.busTimingText.text = ""
        self.secondBusTimingText.text = ""
        self.thirdBusTimingText.text = ""
     //   self.busTimingBlackView.pulsing()
        self.busLoadView.pulsing();self.secondBusLoadView.pulsing();self.thirdBusLoadView.pulsing()
        reloadDelegate?.refreshLoadDataAfterBusTimingViewTapped(tag: cellNumberID!)
    }
    
    let busLoadView:UILabel = {
        let loadview = UILabel()
        loadview.layer.cornerRadius = 4
        loadview.textColor = .white
        loadview.font = UIFont.boldSystemFont(ofSize: 10)
        loadview.textAlignment = .center
        loadview.backgroundColor = .clear
        loadview.clipsToBounds = true
        return loadview
        
    }()
    
    func setupBusLoadView(){
        self.addSubview(busLoadView)
        busLoadView.text = ""
       
        if UIScreen.main.bounds.width == 320{
            busLoadView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.busTimingBlackView.bottomAnchor, BottomPadding: 0, LeftAnchorTo: self.busTimingBlackView.leftAnchor, LeftPadding: 5, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 60, ViewHeight: 15, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        }else{
        
//        busLoadView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.bottomAnchor, BottomPadding: -5, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.busTimingBlackView.leftAnchor, RightPadding: -3, ViewWidth: 50, ViewHeight: 18, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
            
            busLoadView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.busTimingBlackView.bottomAnchor, BottomPadding: 0, LeftAnchorTo: self.busTimingBlackView.leftAnchor, LeftPadding: 5, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 60, ViewHeight: 15, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        }
    }
    
    let secondBusLoadView:UILabel = {
        let loadview = UILabel()
        loadview.layer.cornerRadius = 4
        loadview.textColor = .white
        loadview.font = UIFont.boldSystemFont(ofSize: 10)
        loadview.textAlignment = .center
        loadview.clipsToBounds = true
        return loadview
        
    }()
    
    func setupSecondBusLoadView(){
        self.addSubview(secondBusLoadView)
        secondBusLoadView.text = ""
        
        if UIScreen.main.bounds.width == 320{
            secondBusLoadView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.busTimingBlackView.bottomAnchor, BottomPadding: 0, LeftAnchorTo: self.busLoadView.rightAnchor, LeftPadding: 10, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 60, ViewHeight: 15, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        }else{
            
            //        busLoadView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.bottomAnchor, BottomPadding: -5, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.busTimingBlackView.leftAnchor, RightPadding: -3, ViewWidth: 50, ViewHeight: 18, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
            
            secondBusLoadView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.busTimingBlackView.bottomAnchor, BottomPadding: 0, LeftAnchorTo: self.busLoadView.rightAnchor, LeftPadding: 10, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 60, ViewHeight: 15, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    let thirdBusLoadView:UILabel = {
        let loadview = UILabel()
        loadview.layer.cornerRadius = 4
        loadview.textColor = .white
        loadview.font = UIFont.boldSystemFont(ofSize: 10)
        loadview.textAlignment = .center
        loadview.clipsToBounds = true
        return loadview
        
    }()
    
    func setupThirdBusLoadView(){
        self.addSubview(thirdBusLoadView)
        thirdBusLoadView.text = ""
        
        if UIScreen.main.bounds.width == 320{
            thirdBusLoadView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.busTimingBlackView.bottomAnchor, BottomPadding: 0, LeftAnchorTo: self.secondBusLoadView.rightAnchor, LeftPadding: 10, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 60, ViewHeight: 15, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        }else{
            
            //        busLoadView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.bottomAnchor, BottomPadding: -5, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.busTimingBlackView.leftAnchor, RightPadding: -3, ViewWidth: 50, ViewHeight: 18, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
            
            thirdBusLoadView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.busTimingBlackView.bottomAnchor, BottomPadding: 0, LeftAnchorTo: self.secondBusLoadView.rightAnchor, LeftPadding: 10, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 60, ViewHeight: 15, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    let secondBusTimingText:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 22)
        view.textColor = .white
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
        return view
    }()
    
    func setupSecondBusTimingText(){
        self.addSubview(secondBusTimingText)
        secondBusTimingText.text = ""
        secondBusTimingText.setupConstraint(TopAnchorTo: self.busTimingBlackView.topAnchor, TopPadding: 3, BottomAnchorTo: self.secondBusLoadView.topAnchor, BottomPadding: -3, LeftAnchorTo: self.busTimingText.rightAnchor, LeftPadding: 0, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 70, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleBusTimingTapped))
        secondBusTimingText.text = nil
        secondBusTimingText.addGestureRecognizer(gesture)
    }
    
    
    
    
    let thirdBusTimingText:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 22)
        view.textColor = .white
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
        return view
    }()
    
    func setupThirdBusTimingText(){
        self.addSubview(thirdBusTimingText)
        thirdBusTimingText.text = ""
        thirdBusTimingText.setupConstraint(TopAnchorTo: self.busTimingBlackView.topAnchor, TopPadding: 3, BottomAnchorTo: self.thirdBusLoadView.topAnchor, BottomPadding: -3, LeftAnchorTo: self.secondBusTimingText.rightAnchor, LeftPadding: 0, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 70, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleBusTimingTapped))
        thirdBusTimingText.text = nil
        thirdBusTimingText.addGestureRecognizer(gesture)
    }
    
    
    
    
    let WABImageView : UIImageView = {
        let imageView = UIImageView()
       // imageView.image = UIImage(named: "WAB")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func setupWABImageView(){
        self.addSubview(WABImageView)
        WABImageView.image = nil
        WABImageView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.busLoadView.topAnchor, BottomPadding: -3, LeftAnchorTo: self.busTimingBlackView.leftAnchor, LeftPadding: 5, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 10, ViewHeight: 15, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    let secondWABImageView : UIImageView = {
        let imageView = UIImageView()
        // imageView.image = UIImage(named: "WAB")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func setupSecondWABImageView(){
        self.addSubview(secondWABImageView)
        secondWABImageView.image = nil
        secondWABImageView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.secondBusLoadView.topAnchor, BottomPadding: -3, LeftAnchorTo: self.busTimingBlackView.leftAnchor, LeftPadding: 5+70, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 10, ViewHeight: 15, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    let thirdWABImageView : UIImageView = {
        let imageView = UIImageView()
        // imageView.image = UIImage(named: "WAB")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func setupthirdWABImageView(){
        self.addSubview(thirdWABImageView)
        thirdWABImageView.image = nil
        thirdWABImageView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.secondBusLoadView.topAnchor, BottomPadding: -3, LeftAnchorTo: self.busTimingBlackView.leftAnchor, LeftPadding: 5+70+70, RightAnchorTo: nil, RightPadding: nil, ViewWidth: 10, ViewHeight: 15, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
//    func setupActivity(){
//
//        let activity = UIActivityIndicatorView()
//        activity.activityIndicatorViewStyle = .white
//        activity.startAnimating()
//        self.busLoadView.addSubview(activity)
//        activity.setupConstraint(TopAnchorTo: <#T##NSLayoutYAxisAnchor?#>, TopPadding: <#T##CGFloat?#>, BottomAnchorTo: <#T##NSLayoutYAxisAnchor?#>, BottomPadding: <#T##CGFloat?#>, LeftAnchorTo: <#T##NSLayoutXAxisAnchor?#>, LeftPadding: <#T##CGFloat?#>, RightAnchorTo: <#T##NSLayoutXAxisAnchor?#>, RightPadding: <#T##CGFloat?#>, ViewWidth: <#T##CGFloat?#>, ViewHeight: <#T##CGFloat?#>, CentreXAnchor: <#T##NSLayoutXAxisAnchor?#>, CentreYAnchor: <#T##NSLayoutYAxisAnchor?#>, WidthReferenceTo: <#T##NSLayoutDimension?#>, WidthMultiplier: <#T##CGFloat?#>, HeightReferenceTo: <#T##NSLayoutDimension?#>, HeightMultiplier: <#T##CGFloat?#>)
//
//    }
    
   
    
    
}

protocol refreshLoadDataAfterBusTimingViewTapped {
    func refreshLoadDataAfterBusTimingViewTapped(tag:Int)
}






















