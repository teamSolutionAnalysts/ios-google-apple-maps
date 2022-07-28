Google, Apple Maps - Show Pins on Map and route from source to destination

* Integration of Google Maps is as follows: -
- We will integrate the pods GooglePlaces, GoogleMaps.
- Then we will update the google platform console, the link and the steps is as follows: -
   1. https://console.cloud.google.com/
   2. Create a project or select a project on top.
   3. After selecting/creating a project, we will enable the serivces and api in library.
        - serivces like places api, direction api, route api.
   4. Now we will generate the credentials, in that we will generate the API key, copy the key add it into the GConsts.

- Now we will add location manager file and Maps manager file into the utility.
- Now we will add the location permission in info.plist (Privacy - Location When In Use Usage Description).
- At login time or any of the screen where we want to store the lat long, we can use LocationManager.shared.getLocation(), where we want to store the lat long,with the LocationManager.shared.getLocation() we can get the location popup and can get the lat and long and store it appropriately.
- Now we will create 2 types of google maps, route and radius map as follows: -
    1. The google route map is as follows: -
        - We will import GoogleMaps, SwiftyJSON.
        - Now we will create 2 different lat long variable like startlat, startlong, endLat and endLong.
        - Also we will add the following variables: -
            var polyineRoute : GMSPolyline?
            var preLocation : CLLocation = CLLocation()
            var routeCoordinates : [CLLocationCoordinate2D] = []
            var minutes = ""
            var time = ""
        - In storyboard we will take a view to which we will asign GMSMapView class.
        - Now we will create a method with name MapDrop in which we will specify start and end point marker.
        - In the same function we will call another method drawPath, in which we will use MapManager.shared.getDirectionsUsingGoogleMap api.
        - Now we will add the delegate method of GMSMapView(addPath), to specify the polyline color, width.
    2. The google radius map is as follows: -
        - We will import GoogleMaps.
        - Now we will create a variable (var circle = GMSCircle()).
        - In storyboard we will take a view to which we will asign GMSMapView class.
        - To setup Map following code is as follows: -
            func setupMap(){
            let camera = GMSCameraPosition.camera(withLatitude: (LocationManager.shared.currentLatitude()), longitude: (LocationManager.shared.currentLongitude()), zoom: 18)
            self.vwMap.camera = camera
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake((LocationManager.shared.currentLatitude()), (LocationManager.shared.currentLongitude()))
            marker.map = self.vwMap
            self.vwMap.mapType = .satellite
            marker.icon = UIImage(named: "pin")
            let circleCenter = CLLocationCoordinate2DMake((LocationManager.shared.currentLatitude()), (LocationManager.shared.currentLongitude()))
            circle.position = circleCenter
            circle.map = vwMap
            circle.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1529947917)
            circle.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            circle.strokeWidth = 1
            circle.radius = 80 //Indecates value of range in meter which user can cover
            }
    3. The Apple map is as follows: -
       - We will import MapKit into the particular view controller.
       - Now we will take view in view controller in storyboard and will give class MKMapView.
       - We will now setupMap is as follows: -
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
        - Now we will add extension for MKMapViewDelegate and will use the method viewFor.

