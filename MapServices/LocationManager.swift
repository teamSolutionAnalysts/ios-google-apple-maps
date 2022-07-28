 import UIKit
import CoreLocation
import GoogleMaps
class LocationManager: NSObject , CLLocationManagerDelegate {
    
    static let shared : LocationManager = LocationManager()
    
    private var location            : CLLocation = CLLocation()
    private var locationManager     : CLLocationManager!
    var updateStatusUpcommingVC: ((CLAuthorizationStatus)->())?
    var locationName = ""
    //---------------------------------------------------------------------
    
    //MARK: - Current Lat Long
    
    //TODO: To get location permission just call this method
    func getLocation() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager.delegate = self;
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startUpdatingLocation()
        }
    }
    
    //TODO: To get permission is allowed or declined
    func checkStatus() -> CLAuthorizationStatus{
        return CLLocationManager.authorizationStatus()
    }
    
    //TODO: To get user's current location
    func currentLocation() -> CLLocation {
        return location
    }
    func currentCoordinate() -> CLLocationCoordinate2D {
        return location.coordinate
    }
    func currentLatitude() -> CLLocationDegrees {
        return location.coordinate.latitude
    }
    func currentLongitude() -> CLLocationDegrees {
        return location.coordinate.longitude
    }
    
    //MARK: Delegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[0]
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:{(placemarks, error) in
            
            if ((error) != nil)  { print("Error: \(String(describing: error))") }
            else {
                
                let p = CLPlacemark(placemark: (placemarks?[0] as CLPlacemark?)!)
                
                var subThoroughfare:String = ""
                var thoroughfare:String = ""
                var subLocality:String = ""
                var subAdministrativeArea:String = ""
                var postalCode:String = ""
                var country:String = ""
                
                // Use a series of ifs, or nil coalescing operators ??s, as per your coding preference.
                
                if ((p.subThoroughfare) != nil) {
                    subThoroughfare = (p.subThoroughfare)!
                }
                if ((p.thoroughfare) != nil) {
                    thoroughfare = p.thoroughfare!
                }
                if ((p.subLocality) != nil) {
                    subLocality = p.subLocality!
                }
                if ((p.subAdministrativeArea) != nil) {
                    subAdministrativeArea = p.subAdministrativeArea!
                }
                if ((p.postalCode) != nil) {
                    postalCode = p.postalCode!
                }
                
                if ((p.country) != nil) {
                    country = p.country!
                }
                print("\(subThoroughfare) \(thoroughfare)\n\(subLocality) \(subAdministrativeArea) \(postalCode)\n\(country)")
                self.locationName = "\(subThoroughfare) \(thoroughfare)\n\(subLocality) \(subAdministrativeArea) \(postalCode)\n\(country)"
            }   // end else no error
        }       // end CLGeocoder reverseGeocodeLocation
        )       // end CLGeocoder
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                print("notDetermined")
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted:
                print("restricted")
                break
            case .denied:
                print("denied")
                break
            case .authorizedAlways:
                print("authorizedAlways")
                break
            case .authorizedWhenInUse:
                print("authorizedWhenInUse")
                break
            @unknown default:
                break
            }
            self.updateStatusUpcommingVC?(manager.authorizationStatus)
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("notDetermined")
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            print("restricted")
            break
        case .denied:
            print("denied")
            break
        case .authorizedAlways:
            print("authorizedAlways")
            break
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            break
        @unknown default:
            break
        }
        self.updateStatusUpcommingVC?(status)
    }
    
    //TODO: Uncomment below code to get address from location
    
    func getAddressFromLocation(latitude : String , longitude : String , handler : @escaping ((GMSAddress?) -> ())) {
        
        let geocoder = GMSGeocoder()
        
        var location : CLLocation?
        if latitude.isEmpty || longitude.isEmpty{
            
        }else{
            location = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
        }
        
        if let loc = location {
            geocoder.reverseGeocodeCoordinate(loc.coordinate, completionHandler: { (response, error) in
                
                if error == nil{
                    if let res = response?.results(){
                        for address in res {
                            if address.locality != nil {
                                handler(address)
                                return
                            }
                        }
                        handler(nil)
                        debugPrint("not found")
                    }else{
                        handler(nil)
                        debugPrint("not found")
                    }
                }
            })
        }
    }
}

