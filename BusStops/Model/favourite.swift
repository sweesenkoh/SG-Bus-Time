//
//  Favourite.swift
//  BusStops
//
//  Created by Koh Sweesen on 31/5/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import Foundation
import UIKit



var userDefaults = UserDefaults.standard

class favourite: NSObject,NSCoding{ //Edit Class Name
    
    
    
    var busStopCode:String?
    var bus: String?
    var image: UIImage?
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("hhjsfdfdehe")
    
    init?(busStopCode: String?,bus:String?,image:UIImage?){ //ensure put ? if optionals, if not will have error
        
        self.busStopCode = busStopCode
        self.bus = bus
        self.image = image
    }
    
    struct PropertyKey {
        static let busStopCode = "busStopCode"
        static let bus = "bus"
        static let image = "image"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(busStopCode,forKey: PropertyKey.busStopCode)
        aCoder.encode(bus,forKey: PropertyKey.bus)
        aCoder.encode(image,forKey: PropertyKey.image)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let busStopCode = aDecoder.decodeObject(forKey: PropertyKey.busStopCode) as! String?
        let bus = aDecoder.decodeObject(forKey: PropertyKey.bus) as! String?
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as! UIImage?
        
        self.init(busStopCode:busStopCode,bus:bus,image:image) //V:L
        
    }
    
    
}
