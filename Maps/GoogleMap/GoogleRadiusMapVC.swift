//
//  GoogleRadiusMapVC.swift
//  ios-swift-full-package
//
//  Created by Sunny Madan on 18/05/22.
//  Copyright © 2022 Gaurang Vyas. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleRadiusMapVC: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var vwMap: GMSMapView!
    @IBOutlet weak var lblTitle: UILabel!
    //MARK: - Class Variable
    var circle = GMSCircle()
    
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
        self.setupMap()
    }
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
    
    //MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        if switchLangauge{
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Google_Radius_Map", comment: "")
        }else{
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "hi")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Google_Radius_Map", comment: "")
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
