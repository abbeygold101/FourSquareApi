//
//  DataStructure.swift
//  forAppSmart
//
//  Created by Abiodun Olanrewaju on 09/04/16.
//  Copyright © 2016 Abbey Ola. All rights reserved.
//

import Foundation
import MapKit
class PlaceModel: NSObject {

    var title:String?
    var subtitle:String?
    var catName: String?
    var url: String?
    var checkinCount: Int?
    var id: String?
    var pincoordinate: CLLocationCoordinate2D?
    override init()
    {
        
    }
    init(title: String?, subtitle: String?,catName: String?, url: String?, id: String?, checkinCount:Int,  pincoordinate: CLLocationCoordinate2D?) {
        self.title = title
        self.subtitle = subtitle
        self.pincoordinate = pincoordinate
        self.catName = catName
        self.url = url
        self.id = id
        self.checkinCount = checkinCount
    }

    override var description: String {
        return "Title: \(title), ID: \(id), Subtitle: \(subtitle), CatName: \(catName), URl: \(url), pinCoordinate: \(pincoordinate), checkinCount:\(checkinCount)"
        
    }
    
    
}