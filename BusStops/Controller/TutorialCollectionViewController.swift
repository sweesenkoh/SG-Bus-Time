//
//  TutorialCollectionViewController.swift
//  BusStops
//
//  Created by Koh Sweesen on 9/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import UIKit
import GoogleMobileAds

private let reuseIdentifier = "Cell"

struct ImagePair{
    let image:UIImage?
    let descriptionImage: UIImage?
}

class TutorialCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,dismissTutorialVC,GADBannerViewDelegate {
    
    func dismissMyself() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var bannerView:GADBannerView!

    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(TutorialCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.backgroundColor = .lightGray
  //      setupAdditionalView()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//
//    func setupAdditionalView(){
//        let view = UIView()
//        view.backgroundColor = .purple
//        view.frame = CGRect(x: 20, y: 20, width: 30, height: 30)
//        self.view.addSubview(view)
//    }
//

    
    var imageArray = [
    
        ImagePair(image: UIImage(named: "Image0"), descriptionImage: UIImage(named: "Description0")),
        
        ImagePair(image: UIImage(named: "Image1"), descriptionImage: UIImage(named: "Description1")),
    
        ImagePair(image: UIImage(named: "Image2"), descriptionImage: UIImage(named: "Description2")),
        
        ImagePair(image: UIImage(named: "Image3"), descriptionImage: UIImage(named: "Description3")),
        
        ImagePair(image: UIImage(named: "Image4"), descriptionImage: UIImage(named: "Description4")),
        
        ImagePair(image: UIImage(named: "Image6"), descriptionImage: UIImage(named: "Description6")),
        
        ImagePair(image: UIImage(named: "Image5"), descriptionImage: UIImage(named: "Description5")),
        
        ImagePair(image: UIImage(named: "Image7"), descriptionImage: UIImage(named: "Description7"))
        
        
    ]
    
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TutorialCollectionViewCell
    
        cell.dismissButton.removeFromSuperview()
        
        cell.dismissDelegate = self
        cell.image = imageArray[indexPath.row].image
        cell.descriptionImage = imageArray[indexPath.row].descriptionImage

        if indexPath.row == 0{
            cell.imageView.pulsing()
        }
        
        if indexPath.row == imageArray.count - 1{
            cell.setupDismissButton()
        }
        
        
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }



}



