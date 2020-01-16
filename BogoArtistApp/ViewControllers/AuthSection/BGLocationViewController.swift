//
//  BGLocationViewController.swift
//  BogoArtistApp
//
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol LocationControllerDelegate {

    func selectedLocation(objLocation : LocationInfo)
}

class BGLocationViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate,GMSAutocompleteViewControllerDelegate {
    
    @IBOutlet weak var bottomView   : UIView!
    @IBOutlet weak var searchBar    : UISearchBar!
    @IBOutlet weak var mapView      : GMSMapView!
    @IBOutlet weak var sideImageBtn : UIButton!
    var locationManager             : CLLocationManager!
    var position                    : CLLocationCoordinate2D! = nil
    var marker                      = GMSMarker()
    var isFromProfile               = false
    var isLocation                  = false
    var delegate                    : LocationControllerDelegate?
    @IBOutlet weak var customMarker : UIView!
    var selectedPosition            = LocationInfo()
    var obj                         = BGUserInfoModal()
    var imageArray                  = [UIImage]()
    
    // MARK:- View LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        if APPDELEGATE.isReachable{
            if (USERDEFAULT.value(forKey: "userLat") != nil) || (USERDEFAULT.value(forKey: "userLat") != nil){
                isLocation = true
            }else{
                isLocation = false
            }
            NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel), name: NSNotification.Name(rawValue: "PostToPush"), object: nil)
            searchBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnSearchBar)))
            
            mapView.bringSubviewToFront(customMarker)
            mapView.delegate = self
            mapView.mapType = .terrain
            
            if (USERDEFAULT.value(forKey: "userLat") != nil) || (USERDEFAULT.value(forKey: "userLong") != nil){
                position = CLLocationCoordinate2D(latitude: (USERDEFAULT.value(forKey: "userLat") as! CLLocationDegrees), longitude: (USERDEFAULT.value(forKey: "userLong") as! CLLocationDegrees))
                DispatchQueue.main.async {
                    
                    self.getAddressFromLatLon(pdblLatitude: self.position.latitude, withLongitude: self.position.longitude, completionHandler: { (str) in
                        self.searchBar.text = str
                    })
                }
                
                let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 15.0)
                self.mapView.camera = camera
            }
        }else{
            AlertController.alert(title: "", message: "Internet connection was lost.")
        }
    }
    
    // MARK:- MAP Helper Method
    @objc  func showSpinningWheel()   {
        let loginViewController = UIStoryboard.init(name: "Auth", bundle:nil).instantiateViewController(withIdentifier: "BGLoginVC") as! BGLoginVC
        self.navigationController?.pushViewController(loginViewController, animated: false)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func tapOnSearchBar(){
        let searchVC = GMSAutocompleteViewController()
        searchVC.delegate = self
        self.present(searchVC, animated: true, completion: nil)
    }

    @objc func setCurrentLocationOnMap() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                AlertController.alert(message: "Location services are not enabled")
                break
            case .authorizedAlways, .authorizedWhenInUse:
                break
            }
        } else {
            AlertController.alert(message: "Location services are not enabled")
        }
    }
    
    // MARK:- IBAction Methods
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func subCategoryButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
 
    @IBAction func resetMapToLocationButtonAction(_ sender: Any) {
        if !isLocation {
            AlertController.alert(title: "", message: "Turn On Location Services to Allow \"Bogo\" to Determine Your Location. \nGo To Settings -> Privacy -> Location Services.", buttons: ["OK"], tapBlock: { (action, index) in

            })
        }else{
            position = CLLocationCoordinate2D(latitude: USERDEFAULT.value(forKey: "userLat") as! CLLocationDegrees, longitude: (USERDEFAULT.value(forKey: "userLong"))! as! CLLocationDegrees);            let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 15.0)
            //self.customMarker.removeAllSubviews()
           self.mapView.camera = camera
            self.marker.position = position
            self.marker.icon = nil
           // self.marker.map = self.mapView
            mapView.bringSubviewToFront(customMarker)
            self.mapView.reloadInputViews()
        }
    }
    
    //MARK:- GMSPlaceVC Delegate Methods
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async {
                // self.mapView.clear()
                self.selectedPosition.lat = "\(place.coordinate.latitude)"
                self.selectedPosition.long = "\(place.coordinate.longitude)"
                self.searchBar.text = place.formattedAddress
                self.position.latitude =  place.coordinate.latitude
                self.position.longitude = place.coordinate.longitude
                let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
                self.mapView.camera = camera
                self.mapView.delegate = self
                self.mapView.reloadInputViews()
           }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK:- GMSMapViewDelegate Method
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
            let catgegoryVC = UIStoryboard.init(name: "Auth", bundle:nil).instantiateViewController(withIdentifier: "BGVerificationVC") as! BGVerificationVC
            self.present(catgegoryVC, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition){
        self.position = position.target
        self.selectedPosition.lat = "\(self.position.latitude)"
        self.selectedPosition.long = "\(self.position.longitude)"
        DispatchQueue.main.async {
            self.getAddressFromLatLon(pdblLatitude: self.position.latitude, withLongitude: self.position.longitude, completionHandler: { (str) in
                self.searchBar.text = str
            })
        }
    }
    
    @IBAction func markerBtnAction(_ sender: UIButton) {
        if isFromProfile{
            NotificationCenter.default.post(name: Notification.Name("ChangeLocation"), object: nil ,userInfo: ["lat":self.position.latitude ,"long":self.position.longitude,"BackToProfile": true])
            self.navigationController?.popViewController(animated: false)
            USERDEFAULT.set(self.position.latitude, forKey: "LatForDistance")
            USERDEFAULT.set(self.position.longitude, forKey: "LongForDistance")
            USERDEFAULT.synchronize()
        } else{
            self.callApiForRegister()
        }
    }
    
    @IBAction func locationButton(_ sender: UIButton) {
        let ObjVC = UIStoryboard.init(name: "Auth", bundle:nil).instantiateViewController(withIdentifier: "BGLocationViewController") as! BGLocationViewController
        self.navigationController?.pushViewController(ObjVC, animated: true)
    }
    
    func callApiForRegister() {
        let params = [
            "stylists": [
                //"years_of_experience": "string",
                "description": obj.artistDescription,
                "lat": "string",
                "long": "string",
                "user_attributes": [
                    "first_name": obj.firstName,
                    "last_name": obj.lastName,
                    "phone": obj.phone.replaceString("-", withString: ""),
                    "email": obj.email,
                    "password": obj.password,
                    "gcm_id": USERDEFAULT.value(forKey: pDeviceToken),
                    "device_type": "IOS",
                    "device_id": kDummyDeviceToken
                ]
            ]
        ]
        
        /*
        let params  = [
            "type" : "0" as AnyObject,
            "first_name" : obj.firstName as AnyObject,
            "last_name" : obj.lastName as AnyObject,
            "email" : obj.email as AnyObject,
            "password" : obj.password as AnyObject,
            "description" : obj.artistDescription as AnyObject,
            "device_id" : kDummyDeviceToken as AnyObject,
            "photo" : "" as AnyObject,
            "phone" : obj.phone.replaceString("-", withString: "") as AnyObject,
            "welcome_kit" : "1" as AnyObject,
            "lat" : (self.selectedPosition.lat == "") ? USERDEFAULT.value(forKey: "userNewLat") as AnyObject : self.selectedPosition.lat as AnyObject,
            "long" : (self.selectedPosition.long == "") ? USERDEFAULT.value(forKey: "userNewLong") as AnyObject : self.selectedPosition.long as AnyObject,
            "gcm_id" : USERDEFAULT.value(forKey: pDeviceToken) as AnyObject,
            "device_type" : "IOS" as AnyObject,
            "gallery[]" : "" as AnyObject,
            ]


        var mediaArray = [Dictionary<String, AnyObject>]()
        for image in imageArray {
            let timestamp = NSDate().timeIntervalSince1970
            let filename = "image\(timestamp).jpg"
            let mediaInfoDict = [
                keyMultiPartData : image.toData(),
                keyMultiPartFileType : filename,
                keyMultiPartKeyAtServerSide : "gallery[]",
                "mimeType" : "image/jpg"
                ] as [String : AnyObject]

            mediaArray.append(mediaInfoDict)
        }
        let timestamp = NSDate().timeIntervalSince1970
        let filename = "image\(timestamp).jpg"
        */

        Api.requestJSON(.signup(params: params), success: {
            response in
            DispatchQueue.main.async {
                let controller = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "BGVerificationVC") as! BGVerificationVC
                self.present(controller, animated: true, completion: nil)
            }
        })
    }
    
    // MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double, completionHandler: @escaping (_ address:String) -> Void){
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = pdblLatitude
        center.longitude = pdblLongitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var addressString : String = ""
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil){
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                if let pm = placemarks {
                    if pm.count > 0 {
                        
                        let pm = placemarks![0]
                        if pm.subLocality != nil{
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil{
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil{
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        completionHandler(addressString)
                    }
                }
        })
    }
    
    class AlertHelper {
        func showAlert(fromController controller: UIViewController) {
            let alert = UIAlertController(title: "Alert", message: "Please allow your location to access.", preferredStyle: .alert)
            controller.present(alert, animated: true, completion: nil)
            delay(delay: 3) {
                alert.dismiss(animated: true, completion: {

                })
            }
        }
    }
}

