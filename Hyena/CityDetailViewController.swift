//
//  ViewController.swift
//  Hyena
//
//  Created by kbala on 2017/7/18.
//  Copyright © 2017年 kbala. All rights reserved.
//

import UIKit
import MapKit
class CityDetailViewController: UIViewController {
    
    var in_name = ""
    var in_des = ""
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var wholeStack: UIStackView!
    @IBOutlet weak var descTextView: UITextView!
    
//    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = in_name
        descTextView.text = in_des
        
        let tapGestureRecongizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureRecongizer)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(in_name, completionHandler: {placemark , error in
            if(error != nil){
                print(error)
                return
            }
            
            
            let annotation = MKPointAnnotation()
            if let location = placemark?[0].location{
                annotation.coordinate = location.coordinate
                self.mapView.addAnnotation(annotation)
                
                let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                self.mapView.setRegion(region, animated: false)
            }
            
            
            
        })
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.current.orientation.isLandscape {
            //            print("Landscape")
            wholeStack.axis = UILayoutConstraintAxis.horizontal
        } else {
            //            print("Portrait")
            wholeStack.axis = UILayoutConstraintAxis.vertical
        }
    }
    
    
    func showMap() {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap"{
            
            (segue.destination as! MapViewController).in_name = self.in_name
            
        }
    }
    
}

