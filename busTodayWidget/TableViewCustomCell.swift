//
//  TableViewCustomCell.swift
//  busTodayWidget
//
//  Created by Koh Sweesen on 10/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit

class tableViewCustomCell: UITableViewCell {
    
    var cellBusStopCode: String?
    var isItWAB: Int?{
        didSet{
            let imageWAB = UIImage(named: "WAB")?.withRenderingMode(.alwaysTemplate)
            WABImageView.image = imageWAB
            if currentTheme == darkTheme{
                WABImageView.tintColor = .white
            }else if currentTheme == lightTheme{
                WABImageView.tintColor = .black
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")
        
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //self.backgroundColor = currentTheme.tableViewCellColor
        self.backgroundColor = .clear
        setupBusNumberLabel()
        setupBlackView()
        setupBusTimingText()
        setupBusLoadView()
        setupSecondBusTimingText()
        setupWABImageView()
        
        
        
        //        var bustiming = [Service]()
        //
        //
        //        for service in bustiming{
        //            if self.busNumberLabel.text == service.ServiceNo{
        //                if service.NextBus.IsBusInService(busStopNo: cellBusStopCode!, busNumber: self.busNumberLabel.text!) == true{
        //                    self.busTimingText.text = "Bus Unavailable"
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
        label.font = UIFont.boldSystemFont(ofSize: 22)
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
        busTimingBlackView.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 5, BottomAnchorTo: self.bottomAnchor, BottomPadding: -5, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.rightAnchor, RightPadding: -20, ViewWidth: 160, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    let busTimingText : UILabel = {
        let text = UILabel()
        text.textColor = UIColor.black
        text.font = UIFont.boldSystemFont(ofSize: 22)
        text.textAlignment = .center
        return text
    }()
    
    func setupBusTimingText(){
        self.addSubview(busTimingText)
        busTimingText.setupConstraint(TopAnchorTo: self.busTimingBlackView.topAnchor, TopPadding: 3, BottomAnchorTo: self.busTimingBlackView.bottomAnchor, BottomPadding: -3, LeftAnchorTo: self.busTimingBlackView.leftAnchor, LeftPadding: 3, RightAnchorTo: self.busTimingBlackView.rightAnchor, RightPadding: -3, ViewWidth: nil, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        
        busTimingText.text = nil
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
            busLoadView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.bottomAnchor, BottomPadding: -5, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.busTimingBlackView.leftAnchor, RightPadding: -3, ViewWidth: 70, ViewHeight: 18, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        }else{
            
            busLoadView.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.bottomAnchor, BottomPadding: -5, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.busTimingBlackView.leftAnchor, RightPadding: -3, ViewWidth: 80, ViewHeight: 18, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
        }
    }
    
    let secondBusTimingText:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = .white
        view.textAlignment = .right
        return view
    }()
    
    func setupSecondBusTimingText(){
        self.addSubview(secondBusTimingText)
        secondBusTimingText.text = ""
        secondBusTimingText.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.busTimingBlackView.bottomAnchor, BottomPadding: -5, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.busTimingBlackView.rightAnchor, RightPadding: -7, ViewWidth: 25, ViewHeight: 20, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
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
        WABImageView.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 10, BottomAnchorTo: self.busLoadView.topAnchor, BottomPadding: -10, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.busTimingBlackView.leftAnchor, RightPadding: -5, ViewWidth: 20, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
}
