//
//  AppleMapVC.swift
//  ios-swift-full-package
//
//  Created by Sunny Madan on 18/05/22.
//  Copyright © 2022 Gaurang Vyas. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class AppleMapVC: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var vwMap: MKMapView!
    
    //MARK: - Class Variable
    var selectedPin:MKPlacemark? = nil
    var resultSearchController:UISearchController? = nil
    let lat = LocationManager.shared.currentLatitude()
    let long = LocationManager.shared.currentLongitude()
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK: - Custom Method
    func setUpView() {
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation1.subtitle = LocationManager.shared.locationName
        self.vwMap.addAnnotation(annotation1)
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchVC") as! LocationSearchVC
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        locationSearchTable.mapView = vwMap
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    @objc func btnGetDirections(sender: UIButton) {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }

    //MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
extension AppleMapVC : MKMapViewDelegate, HandleMapSearch{
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = vwMap.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(btnGetDirections(sender:)), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        vwMap.removeAnnotations(vwMap.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
           let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        vwMap.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: lat, longitudeDelta: long)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        vwMap.setRegion(region, animated: true)
    }
}
