//
//  TutorialCollectionViewCell.swift
//  BusStops
//
//  Created by Koh Sweesen on 11/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit

protocol dismissTutorialVC {
    func dismissMyself()
}

class TutorialCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        setupImageView()
        setupDescriptionView()
    }
    
    var dismissDelegate: dismissTutorialVC?
    var image:UIImage?{
        didSet{
            self.imageView.image = image
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = UIImageView()
    
    func setupImageView(){
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        imageView.setupConstraint(TopAnchorTo: self.topAnchor, TopPadding: 40, BottomAnchorTo: nil, BottomPadding: nil, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: nil, RightPadding: nil, ViewWidth: nil, ViewHeight: nil, CentreXAnchor: self.centerXAnchor, CentreYAnchor: nil, WidthReferenceTo: self.widthAnchor, WidthMultiplier: 0.6, HeightReferenceTo: nil, HeightMultiplier: nil)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 2172/1003).isActive = true
    }
    
    let dismissButton:UIButton = {
        let button = UIButton()
        button.showsTouchWhenHighlighted = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .black
        button.alpha = 0.7
        button.layer.cornerRadius = 35/2
        return button
    }()
    
    func setupDismissButton(){
        self.addSubview(dismissButton)
        dismissButton.setTitle("X", for: .normal)
        dismissButton.pulsing()
        dismissButton.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        dismissButton.setupConstraint(TopAnchorTo: nil, TopPadding: nil, BottomAnchorTo: self.descriptionView.topAnchor, BottomPadding: -10, LeftAnchorTo: nil, LeftPadding: nil, RightAnchorTo: self.rightAnchor, RightPadding: -10, ViewWidth: 35, ViewHeight: 35, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    @objc func handleDismissButton(){
        
        dismissDelegate?.dismissMyself()
    
    }
    
    var descriptionImage:UIImage?{
        didSet{
            self.descriptionView.image = descriptionImage
        }
    }
    
    let descriptionView: UIImageView = {
        let text = UIImageView()
        text.backgroundColor = .lightGray
        text.contentMode = .scaleAspectFit
        return text
    }()
    
    func setupDescriptionView(){
        self.addSubview(descriptionView)
        descriptionView.setupConstraint(TopAnchorTo: self.imageView.bottomAnchor, TopPadding: 20, BottomAnchorTo: self.bottomAnchor, BottomPadding: 0, LeftAnchorTo: self.leftAnchor, LeftPadding: 0, RightAnchorTo: self.rightAnchor, RightPadding: 0, ViewWidth: nil, ViewHeight: nil, CentreXAnchor: nil, CentreYAnchor: nil, WidthReferenceTo: nil, WidthMultiplier: nil, HeightReferenceTo: nil, HeightMultiplier: nil)
    }
    
    
}
