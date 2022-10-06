//
//  GoogleRouteVC.swift
//  ios-swift-full-package
//
//  Created by Sunny Madan on 19/05/22.
//  Copyright © 2022 Gaurang Vyas. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
class GoogleRouteVC: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var vwMap: GMSMapView!
    @IBOutlet weak var lblTitle: UILabel!
    //MARK: - Class Variable
    var minutes = ""
    var time = ""
    var polyineRoute : GMSPolyline?
    var preLocation : CLLocation = CLLocation()
    var routeCoordinates : [CLLocationCoordinate2D] = []
    
    let latitude = LocationManager.shared.currentLatitude()
    let longitude = LocationManager.shared.currentLongitude()
    
    let endLat = 23.0484
    let endLng = 72.5289
    
    //MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint(self.classForCoder , " deinit")
    }
    
    //MARK: - Custom Method
    func setUpView() {
        self.MapDrop(startLAT: latitude, startLONG: longitude, endLAT: endLat, endLONG: endLng)
        if switchLangauge{
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Google_Route_Map", comment: "")
        }else{
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "hi")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Google_Route_Map", comment: "")
        }
    }
    
    func MapDrop(startLAT: CLLocationDegrees, startLONG: CLLocationDegrees, endLAT:CLLocationDegrees, endLONG: CLLocationDegrees){
        
        self.vwMap.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: startLAT, longitude: startLONG), zoom: 10.0, bearing: 0, viewingAngle: 0)
        //  self.mapView.isMyLocationEnabled = true
        
        self.vwMap.preferredFrameRate = .maximum
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                vwMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        let markerEnd = GMSMarker()
        markerEnd.position = CLLocationCoordinate2D(latitude: endLAT, longitude: endLONG)
        markerEnd.icon = UIImage(named: "origin_marker")
        markerEnd.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        markerEnd.isTappable = true
        markerEnd.map = self.vwMap
        
        let markerStart = GMSMarker()
        markerStart.position = CLLocationCoordinate2D(latitude:  startLAT, longitude: startLONG)
        markerStart.icon = UIImage(named: "destination_marker")
        markerStart.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        markerStart.isTappable = true
        markerStart.map = self.vwMap
        markerStart.infoWindowAnchor = CGPoint(x: 1.6, y: -0.2)
        markerStart.userData = "source"
        
        let camera = GMSCameraPosition(target: markerStart.position, zoom: 15)
        self.vwMap.animate(to: camera)
        
        routeCoordinates.append(CLLocationCoordinate2D(latitude: endLAT, longitude: endLONG))
        routeCoordinates.append(CLLocationCoordinate2D(latitude: startLAT, longitude: startLONG))
        
        let path = GMSMutablePath(coordinates: routeCoordinates)
        let bounds = GMSCoordinateBounds(path: path)
        let cameraUpdate = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 50 , left: 50, bottom: 50, right: 50))
        self.vwMap.animate(with: cameraUpdate)
        self.vwMap.moveCamera(cameraUpdate)
        
        self.drawPath(SourceCordinate: CLLocationCoordinate2D(latitude: startLAT, longitude: startLONG), destinationcordinate: CLLocationCoordinate2D(latitude:  endLAT, longitude: endLONG))
    }
    
    func drawPath(SourceCordinate : CLLocationCoordinate2D, destinationcordinate :CLLocationCoordinate2D) {
        MapManager.shared.getDirectionsUsingGoogleMap(origin: SourceCordinate, destination: destinationcordinate) { (polyline, dataDictionary, dataString) in
            let jsonData  = JSON(dataDictionary ?? [])
            
            if let legs = jsonData["legs"].arrayValue.first
            {
                let distance = legs["distance"]["text"]
                let duration = legs["duration"]["text"]
                let arrival = legs["arrival_time"]["text"]
                self.time = duration.stringValue
                self.minutes = distance.stringValue
                print(arrival)
            }
            
            if let _ = polyline{
                self.polyineRoute = nil
                self.polyineRoute = polyline
                self.polyineRoute!.strokeWidth = 4.0
                self.polyineRoute!.strokeColor = UIColor.blue
                self.polyineRoute?.map = self.vwMap
            }
        }
    }
    
    //MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension GMSMutablePath {
    convenience init(coordinates: [CLLocationCoordinate2D]) {
        self.init()
        for coordinate in coordinates {
            add(coordinate)
        }
    }
}

extension GMSMapView {
    func addPath(_ path: GMSPath, strokeColor: UIColor? = nil, strokeWidth: CGFloat? = nil, geodesic: Bool? = nil, spans: [GMSStyleSpan]? = nil) {

        let line = GMSPolyline(path: path)
        line.strokeColor = strokeColor ?? line.strokeColor
        line.strokeWidth = strokeWidth ?? line.strokeWidth
        line.geodesic = geodesic ?? line.geodesic
        line.spans = spans ?? line.spans
        line.map = self
    }
}
