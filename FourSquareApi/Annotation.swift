//
//  Annotation.swift
//  FourSquareApi
//
//  Created by Abiodun Olanrewaju on 09/04/16.
//  Copyright © 2016 Abbey Ola. All rights reserved.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation
{
    let title:String?;
    let subtitle:String?;
    let coordinate: CLLocationCoordinate2D;
    
    init(title: String?, subtitle:String?, coordinate: CLLocationCoordinate2D)
    {
        self.title = title;
        self.subtitle = subtitle;
        self.coordinate = coordinate;
        
        super.init();
    }    
}