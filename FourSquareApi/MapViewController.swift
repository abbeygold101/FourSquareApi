//
//  MapViewController.swift
//  FourSquareApi
//
//  Created by Abiodun Olanrewaju on 09/04/16.
//  Copyright © 2016 Abbey Ola. All rights reserved.
//

import UIKit
import MapKit
//import RealmSwift
class MapViewController: UIViewController,  MKMapViewDelegate, HomeModelProtocol {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var addresslabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    var feedItems: NSArray = NSArray()
    var coordinates = CLLocationCoordinate2D()
    var placeEntered = String()
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let Lat: CLLocationDegrees = coordinates.latitude
        let Lon: CLLocationDegrees = coordinates.longitude
        let point: CLLocation =  CLLocation(latitude: Lat, longitude:Lon)
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.getPopularLocation(point)
    }
    
    override func viewWillAppear(animated: Bool) {
        if let mapView = self.mapView
        {
            mapView.delegate = self
            let Lat: CLLocationDegrees = coordinates.latitude
            let Lon: CLLocationDegrees = coordinates.longitude
            let point: CLLocation =  CLLocation(latitude: Lat, longitude:Lon)
            let region = MKCoordinateRegionMakeWithDistance(point.coordinate, 10000, 10000);
            mapView.setRegion(region, animated: true)
        }
    }
    
    func venuesDownloaded(items: NSArray) {
        feedItems = items
        let feedCount = items.count
        titlelabel.text = "We have found \(feedCount) places around \(placeEntered), we think might be of interest to you. Tap a pin and then info button to learn more about the place."
        for place in items {
            let item: PlaceModel = place as! PlaceModel
            if let pinTitle = item.title,
            let pinsubT = item.subtitle,
            let pincoord = item.pincoordinate{
            let annotation = Annotation(title: pinTitle, subtitle: pinsubT, coordinate: pincoord)
            mapView?.addAnnotation(annotation)
            }
        }
 
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {

        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "reuseIdentifier")
        pinAnnotationView.pinTintColor = UIColor.redColor()
        pinAnnotationView.draggable = true
        pinAnnotationView.canShowCallout = true
        pinAnnotationView.animatesDrop = true
        let pinButton = UIButton(type: UIButtonType.InfoDark) as UIButton
        pinButton.frame.size.width = 44
        pinButton.frame.size.height = 44
        pinButton.backgroundColor = UIColor.redColor()
        pinAnnotationView.leftCalloutAccessoryView = pinButton
        return pinAnnotationView
    }
    
    func mapView(MapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
         let mmm = (annotationView.annotation!.title!)!
        for feed in feedItems{
            let item: PlaceModel = feed as! PlaceModel
            if let sss = item.title{
                if sss == mmm{
                    titlelabel.text = item.title!
                    categoryLabel.text = item.catName!
                    addresslabel.text = item.subtitle!
                    countLabel.text = "number of check-ins: \(item.checkinCount!)"
                    self.getImage(item.url!)
                }
                
            }
        }
    }
    
    func getImage(url: String){
    
        let imgUrlString = url
        let requestImg = NSURL(string: imgUrlString)
        let request = NSURLRequest(URL: requestImg!)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.imageView.image = UIImage(data: data!)
            })
        })
        dataTask.resume()
        
    }
        
}

