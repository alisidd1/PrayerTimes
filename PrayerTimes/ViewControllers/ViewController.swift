//
//  ViewController.swift
//  PrayerTimes
//
//  Created by Ali Siddiqui on 1/16/24.
//  getAthanTime(month: String, latValue: String, longValue: String, completion: @escaping (
//  Result<[Welcome], CustomError>) -> Void ) {
//  Rio de Janeiro, Brazil Location: CLLocationCoordinate2D(latitude: -22.9108638, longitude: -43.2045436)



import UIKit
import CoreLocation
import Contacts

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
     
    private let _view = HomeScreenView()
    private let manager = CLLocationManager()

    private var locationName: String = ""
    private var longitude: Double = 0.0
    private var latitude: Double = 0.0
    
    override func loadView() {
        view = _view
        view.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.frame = view.bounds
        let address = "Rio de Janeiro, Brazil"
        getCoordinateFrom(address: address) { coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            DispatchQueue.main.async {
                print(address, "\n\n %%%  Location:", coordinate)
            }
        }
    }
    
    func getPrayerTimes() {
         NetworkManager.shared.getAthanTime(month:"4", latValue: String(latitude), longValue: String(longitude)) { [weak self] result in
            guard let self = self else { return }
            switch(result) {
            case .success(let response):
                _view.configure(viewModel: response)
                DispatchQueue.main.async {
                    self._view.table.reloadData()
                }
                
            case .failure(_):
                print("Error in getting country data - USE AN ALERT VIEW")
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//         super.viewDidAppear(animated)
//     }
    
    // get user input for location name
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
     }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() //Hide the keyboard
        navigationController?.present(LocationPrayerTimesViewController(location: textField.text), animated: true)
        return true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }
        
        latitude = first.coordinate.latitude
        longitude = first.coordinate.longitude
        self.getPrayerTimes()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        location.placemark { placemark, error in
            guard let placemark = placemark else {
                print("Error", error ?? "nil")
                return
            }
            
            print(placemark.postalAddress ?? "\n\n *****Error: Address not found")
            guard let localAddress = placemark.postalAddress else {
                print("\n\n *****Error: Error: Address not found")
                return
            }
            
            self._view.addressLabel.text = "  ADDRESS: \n\n\(localAddress)"
            var cleanAddress = self._view.addressLabel.text!.replacingOccurrences(of: ",", with: "\n ")
            cleanAddress = cleanAddress.replacingOccurrences(of: ">", with: " ")
            cleanAddress = cleanAddress.replacingOccurrences(of: "<", with: " ")
            cleanAddress = cleanAddress.replacingOccurrences(of: "street", with: "\n street ")
            
            let location = cleanAddress
                .components(separatedBy: "city=")
                .map { segment -> String in
                        let name = segment.components(separatedBy: "\n")
                        return name.first!
                     }
            self.locationName = location[1]
            self._view.addressLabel.text = cleanAddress
            self.title = "Prayer Times for \(self.locationName)"
        }
    }
    
    
    func getCoordinateFrom(address: String, completion: @escaping(
                    _ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
}

extension CLLocation {
    func placemark(completion: @escaping ( _ placemark: CLPlacemark?, _ error: Error?  ) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }

    }
}


