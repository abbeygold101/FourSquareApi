//
//  ViewController.swift
//  FourSquareApi
//
//  Created by Abiodun Olanrewaju on 09/04/16.
//  Copyright © 2016 Abbey Ola. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController,  MKMapViewDelegate {
    var coordinates = CLLocationCoordinate2D()
    var placeEntered = String()
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func submitButton(sender: AnyObject) {
        
        if (textField.text == ""){
            
            self.alertView("Please insert a value you can not send an empty text field for query")
        }
        else{
           
            let address = textField.text
            let geocoder = CLGeocoder()
            if let address = address{
                geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                    if((error) != nil){
                        self.alertView("Sorry we cant find that location, in what Planet is it? :) or perhaps its just your internet connection.")
                    }
                    if let placemark = placemarks?.first {
                        self.coordinates = (placemark.location!.coordinate)
                        self.placeEntered = self.textField.text!
                        self.performSegueWithIdentifier("goToMap", sender: self)
                    }
                })
            }
            
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToMap" {
            let vcl = segue.destinationViewController as! MapViewController
            vcl.coordinates = coordinates
            vcl.placeEntered = placeEntered
        }
    }
    func alertView(message: String){
        
        let alertController = UIAlertController(title: "Alert", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
 
    
}

