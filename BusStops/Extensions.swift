//
//  Extensions.swift
//  BusStops
//
//  Created by Koh Sweesen on 25/5/18.
//  Copyright © 2018 Koh Sweesen. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


extension String {
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start..<end])
    }
    
    subscript (r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start...end])
    }
}

//__________________________________________________________

//extension method of nextBus to calculate the time taken to arrive

struct CurrentTime {
    let second: Int
    let minute: Int
    let hour: Int
}

struct BusTime{
    let second: Int
    let minute: Int
    let hour: Int
}


extension BusTimingInfo{
    
    
    func getAmountOfTimeToArrive(bus: BusTimingInfo) -> String{
        
        let currentTime = CurrentTime(second: getSecondValue(), minute: getMinuteValue(), hour: getHourValue())
        let busTime = BusTime(second: getBusArrivalSecond(bus: bus), minute: getBusArrivalMinute(bus: bus), hour: getBusArrivalHour(bus: bus))
        
        var minuteDeduction = 0
        var hourDeduction = 0
        
        let time = DateComponents(calendar: nil, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: busTime.hour, minute: busTime.minute, second: busTime.second, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        
        let nowTime = DateComponents(calendar: nil, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: currentTime.hour, minute: currentTime.minute, second: currentTime.second, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        

        var secondDifference = busTime.second - currentTime.second
        if secondDifference < 0 {minuteDeduction = 1; secondDifference = (60-currentTime.second) + busTime.second}
        
        var minuteDifference = busTime.minute - currentTime.minute - minuteDeduction
        if minuteDifference < 0 {hourDeduction = 1; minuteDifference = (60-currentTime.minute) + busTime.minute}
        
        var hourDifference = busTime.hour - currentTime.hour - hourDeduction
        if hourDifference < 0 {hourDifference = hourDifference + 24}
        
        //temporaryfix because server update time sometimes lag:
        if minuteDifference > 50{minuteDifference = -1}
        if hourDifference > 22{hourDifference = 0}
        
        let TotalDifference = "\(hourDifference) hour " + "\(minuteDifference) minute "+"\(secondDifference) seconds"
        
        print("The minuteDifference is \(minuteDifference) and second is \(secondDifference)")
        
        
        if minuteDifference < 0{
            
            return "Left"
            
        }else if minuteDifference < 1 {
            return "Arr"
        }else{
            return "\(minuteDifference)"}
    }
    
    
    func getHourValue() -> Int{
        let date = Date()
        let calender = Calendar.current
        let hour = calender.component(.hour, from: date)
        return hour
    }
    
    func getMinuteValue() -> Int{
        let date = Date()
        let calender = Calendar.current
        let minute = calender.component(.minute, from: date)
        return minute
    }
    
    
    func getSecondValue() -> Int{
        let date = Date()
        let calender = Calendar.current
        let second = calender.component(.second, from: date)
        return second
    }
    
    func getBusArrivalHour(bus: BusTimingInfo) -> Int{
        
        if bus.EstimatedArrival == ""{return 0}else{
        let timeString = bus.EstimatedArrival[11...12]
        if timeString.isEmpty == true{
            return 0
        }
        else{
            return Int(timeString)!
            
     }
        }
    }
    
    func getBusArrivalMinute(bus: BusTimingInfo) -> Int{
        
        if bus.EstimatedArrival == ""{return 0}else{
        let timeString = bus.EstimatedArrival[14...15]
        if timeString.isEmpty == true{
            return 0
        }
        else{
            return Int(timeString)!
            
        }
        }
    }
    
    func getBusArrivalSecond(bus: BusTimingInfo) -> Int{
        
        if bus.EstimatedArrival == ""{return 0}else{
        let timeString = bus.EstimatedArrival[17...18]
        if timeString.isEmpty == true{
            return 0
        }
        else{
            return Int(timeString)!
        }
    }
    
    }
}

//_________________________________________________ Supposedly should be exten func to check whether bus in service but face somem proeblem on implementation

extension BusTimingInfo{
    
    func IsBusInService(busStopNo: String, busNumber: String) -> Bool{
        
        var busRoutes = [BusRoute]()
        var filteredBusRoutes = [BusRoute]()
        var firstBus: String?
        var lastBus: String?
        var currentHour = getHourValue()
        var currentMinute = getMinuteValue()
        var firstBusMinute: Int?
        var lastBusMinute: Int?
        var firsBusHour: Int?
        var lastBusHour: Int?
        var bool: Bool?
        
        for bus in busRoutes{
            if bus.BusStopCode == busStopNo{
                filteredBusRoutes.append(bus)
            }
        }
        
        if getCurrentDayOfWeek() == "WD_"{
            
            for bus in filteredBusRoutes{
                if bus.ServiceNo == busNumber {firstBus = bus.WD_FirstBus;lastBus = bus.WD_LastBus}
            }
            
        }
            
        else if getCurrentDayOfWeek() == "SAT"{
            for bus in filteredBusRoutes{
                if bus.ServiceNo == busNumber {firstBus = bus.SAT_FirstBus;lastBus = bus.SAT_LastBus}
            }
        }
            
        else if getCurrentDayOfWeek() == "SUN"{
            for bus in filteredBusRoutes{
                if bus.ServiceNo == busNumber {firstBus = bus.SUN_FirstBus;lastBus = bus.SUN_LastBus}
            }
        }
        
        if firstBus == nil || lastBus == nil{bool = false}else{
            
            firstBusMinute = Int(firstBus![2...3])
            firsBusHour = Int(firstBus![0...1])
            lastBusMinute = Int(lastBus![2...3])
            lastBusHour = Int(lastBus![0...1])
            
            if currentHour < lastBusHour! && currentHour > firsBusHour! {
                bool = true
            }else if currentHour == firsBusHour{
                if currentMinute > firstBusMinute! {
                    bool = true
                }
            }else if currentHour == lastBusHour{
                if currentMinute < lastBusMinute!{
                    bool = true
                }
            }else{
                bool = false
            }
        }
        return bool!
        
        
        
    }
    
    func getCurrentDayOfWeek() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let day = calender.component(.weekday, from: date)
        
        var dayName: String?
        
        if day == 7 {dayName = "SAT"}
        else if day == 1 {dayName = "SUN"}
        else {dayName = "WD_"}
        
        return dayName!
        
    }
    
}



//________________________________________________UIVIEW constraints extension

extension UIView{
    
    func setupConstraint(TopAnchorTo: NSLayoutYAxisAnchor?, TopPadding: CGFloat?, BottomAnchorTo: NSLayoutYAxisAnchor?, BottomPadding: CGFloat?, LeftAnchorTo: NSLayoutXAxisAnchor?, LeftPadding: CGFloat?, RightAnchorTo: NSLayoutXAxisAnchor?, RightPadding: CGFloat?, ViewWidth: CGFloat?, ViewHeight: CGFloat?, CentreXAnchor: NSLayoutXAxisAnchor?, CentreYAnchor: NSLayoutYAxisAnchor?, WidthReferenceTo: NSLayoutDimension?, WidthMultiplier: CGFloat?, HeightReferenceTo: NSLayoutDimension?, HeightMultiplier: CGFloat?){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let TopAnchorTo = TopAnchorTo{
            topAnchor.constraint(equalTo: TopAnchorTo, constant: TopPadding!).isActive = true
        }
        
        if let BottomAnchorTo = BottomAnchorTo{
            bottomAnchor.constraint(equalTo: BottomAnchorTo, constant: BottomPadding!).isActive = true
        }
        
        if let LeftAnchorTo = LeftAnchorTo{
            leftAnchor.constraint(equalTo: LeftAnchorTo, constant: LeftPadding!).isActive = true
        }
        
        if let RightAnchorTo = RightAnchorTo{
            rightAnchor.constraint(equalTo: RightAnchorTo, constant: RightPadding!).isActive = true
        }
        
        if let ViewWidth = ViewWidth{
            widthAnchor.constraint(equalToConstant: ViewWidth).isActive = true
        }
        
        if let ViewHeight = ViewHeight{
            heightAnchor.constraint(equalToConstant: ViewHeight).isActive = true
        }
        
        if let CentreXAnchor = CentreXAnchor{
            centerXAnchor.constraint(equalTo: CentreXAnchor).isActive = true
        }
        
        if let CentreYAnchor = CentreYAnchor{
            centerYAnchor.constraint(equalTo: CentreYAnchor).isActive = true
        }
        
        if let WidthReferenceTo = WidthReferenceTo{
            widthAnchor.constraint(equalTo: WidthReferenceTo, multiplier: WidthMultiplier!).isActive = true
        }
        
        if let HeightReferenceTo = HeightReferenceTo{
            heightAnchor.constraint(equalTo: HeightReferenceTo, multiplier: HeightMultiplier!).isActive = true
        }
        
        
        
    }
    
    
    
    
}

extension BusStop{
    
    func calculateDistance(latitude: Double, longitude: Double, busStopLatitude: Double, busStopLongitude: Double) -> String{
        
        let busCoordinate  = CLLocation(latitude: busStopLatitude, longitude: busStopLongitude)
        let userCoordinate = CLLocation(latitude: latitude, longitude: longitude)
        let distance = busCoordinate.distance(from: userCoordinate)
        let distanceinKM = distance/1000
    
//        if distanceinKM < 1{
//            return (String(distance)+"m")
//        }else{
        //print("calculating distance")
        let distance2 = (distanceinKM*1000).rounded(.toNearestOrEven) / 1000
        return String(distance2)
    }
}

//______________________________________________

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [kCIContextWorkingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension UIView {
    
    func pulsing(){
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.9
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 100
        pulse.initialVelocity = 0
        pulse.damping = 10
        
        layer.add(pulse, forKey: nil)
        
    }
    
}






