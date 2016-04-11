//
//  ViewController.swift
//  FourSquareApi
//
//  Created by Abiodun Olanrewaju on 09/04/16.
//  Copyright © 2016 Abbey Ola. All rights reserved.
//

import Foundation
import QuadratTouch
import MapKit

protocol HomeModelProtocol: class {
    func venuesDownloaded(items: NSArray)
}

class HomeModel{
    
    weak var delegate: HomeModelProtocol!
    var session:Session?

    init()
    {
        let devCredential = Client(clientID: "1JOIDJU30QB4NWJGA02DUJ520CNLRVTT3VGVRWF3EU01IKRO", clientSecret: "GJH2TIRR22FRU4EZLATBP1LGFACTF2DF2MFF5QTPVB14ZYRT", redirectURL: "")
        
        let configuration = Configuration(client:devCredential)
            Session.setupSharedSessionWithConfiguration(configuration)
            self.session = Session.sharedSession()

    }
    
    func getPopularLocation(location:CLLocation)
    {
        
        let places: NSMutableArray = NSMutableArray()
        if let session = self.session
        {
            var parameters = location.parameters();
            parameters += [Parameter.categoryId: "4d4b7104d754a06370d81259"]
            let searchTask = session.venues.search(parameters)
            {
                (result) -> Void in
                    
                if let response = result.response
                {
                    if let venues = response["venues"] as? [[String: AnyObject]]
                    {
                            for venue:[String: AnyObject] in venues
                            {
                                
                                if let id = venue["id"] as? String,
                                   let name = venue["name"] as? String,
                                   let location = venue["location"] as? [String: AnyObject],
                                    let statistic = venue["stats"] as? [String: AnyObject],
                                    let checkinCount = statistic["checkinsCount"] as? Int,
                                    let cat = venue["categories"] as?  NSArray,
                                    let catInfo = cat[0] as? [String: AnyObject],
                                    let catName = catInfo["name"] as? String,
                                    let catIcon = catInfo["icon"] as? NSDictionary,
                                    let ImagePrefix = catIcon["prefix"] as? String,
                                    let ImageSuffix = catIcon["suffix"] as? String,
                                    let longitude = location["lng"] as? Float,
                                    let latitude = location["lat"] as? Float,
                                    let formattedAddress = location["formattedAddress"] as? [String]
                                    
                                {
                                    
                                    let imageUrl = ImagePrefix + "bg_64" + ImageSuffix
                                    let pincoordinate = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
                                    let address = formattedAddress.joinWithSeparator(" ")
                                    let placeData = PlaceModel()
                                    placeData.id = id
                                    placeData.title = name
                                    placeData.catName = catName
                                    placeData.url = imageUrl
                                    placeData.pincoordinate = pincoordinate
                                    placeData.subtitle = address
                                    placeData.checkinCount = checkinCount
                                    places.addObject(placeData)
                                
                                }
                            }
                        }
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.delegate.venuesDownloaded(places)
                    
                })
            }
            searchTask.start()
        }
    }
    
}

extension CLLocation
{
    func parameters() -> Parameters
    {
        let ll      = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
        let llAcc   = "\(self.horizontalAccuracy)"
        let alt     = "\(self.altitude)"
        let altAcc  = "\(self.verticalAccuracy)"
        let parameters = [
            Parameter.ll:ll,
            Parameter.llAcc:llAcc,
            Parameter.alt:alt,
            Parameter.altAcc:altAcc
        ]
        return parameters
    }
}