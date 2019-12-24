//
//  Structures.swift
//  busTodayWidget
//
//  Created by Koh Sweesen on 10/7/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import Foundation


struct main:Decodable{
    var BusStops: [BusStop]
}

struct BusStop:Decodable {
    var BusStopCode:String
    var RoadName:String
    var Description:String
    var Latitude:Float
    var Longitude:Float
    var Distance: String?
}

//_______________________


struct mainBusRoute:Decodable{
    let BusRoutes: [BusRoute]
}

struct BusRoute:Decodable{
    let ServiceNo: String?
    let Operator: String?
    let Direction: Int?
    let StopSequence: Int?
    let BusStopCode: String?
    let Distance: Float?
    let WD_FirstBus: String?
    let WD_LastBus: String?
    let SAT_FirstBus: String?
    let SAT_LastBus: String?
    let SUN_FirstBus: String?
    let SUN_LastBus: String?
    
}



//_______________________________________

struct BusStopTiming:Decodable{
    let odatametadata: String
    let BusStopCode: String
    let Services: [Service]
    
    enum CodingKeys:String, CodingKey{
        case odatametadata = "odata.metadata"
        case BusStopCode
        case Services
    }
}

struct Service:Decodable {
    
    var ServiceNo:String
    let Operator:String
    let NextBus:BusTimingInfo
    let NextBus2:BusTimingInfo
    let NextBus3:BusTimingInfo
    
}

struct BusTimingInfo:Decodable{
    
    let OriginCode: String
    let DestinationCode: String
    let EstimatedArrival: String
    let Latitude: String
    let Longitude: String
    let VisitNumber: String
    let Load: String
    let Feature: String
    let busType: String
    
    enum CodingKeys:String, CodingKey{
        case OriginCode
        case DestinationCode
        case EstimatedArrival
        case Latitude
        case Longitude
        case VisitNumber
        case Load
        case Feature
        case busType = "Type"
    }
    
}
