//
//  ViewController.swift
//  PrayerTimes
//
//  Created by Ali Siddiqui on 1/16/24.
//  getAthanTime(month: String, latValue: String, longValue: String, completion: @escaping (
//  Result<[Welcome], CustomError>) -> Void ) {


import UIKit
import CoreLocation
import Contacts

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
     
    private var viewModels: [PrayerTimingsTableViewCellViewModel] = Array(0..<5).map { _ in
        return PrayerTimingsTableViewCellViewModel()
    }
    
    private let manager = CLLocationManager()

    private var locationName: String = ""
    private var longitude: Double = 0.0
    private var latitude: Double = 0.0
    
    private let table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(PrayerTimingsTableViewCell.self,
                       forCellReuseIdentifier: "PrayerTimingsTableViewCell")
        return table
    }()
    
    private let addressLabel: UILabel  = {
        let addressLabel               = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.backgroundColor   = .systemGray
        addressLabel.numberOfLines = 0
        addressLabel.layer.borderWidth = 3
        addressLabel.layer.borderColor = UIColor.systemBlue.cgColor
        return addressLabel
    }()
    
    private let locationNameLabel: UILabel  = {
        let locationNameLabel               = UILabel()
        locationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        locationNameLabel.backgroundColor   = .systemBlue
        locationNameLabel.numberOfLines = 0
        locationNameLabel.layer.borderWidth = 3
        locationNameLabel.text = " Enter your location name below:"
        locationNameLabel.layer.borderColor = UIColor.systemBlue.cgColor
        return locationNameLabel
    }()
 
    private let locationNameText: UITextField  = {
        let locationNameText               = UITextField()
        locationNameText.translatesAutoresizingMaskIntoConstraints = false
        locationNameText.backgroundColor   = .systemGreen
        locationNameText.layer.borderWidth = 3
        locationNameText.layer.borderColor = UIColor.systemBlue.cgColor
        return locationNameText
    }()
    
    private let goButton: UIButton  = {
        let goButton               = UIButton()
        goButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.backgroundColor   = .systemCyan
        return goButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        table.delegate = self
        table.dataSource = self
        view.addSubview(table)
        view.addSubview(addressLabel)
        view.addSubview(locationNameLabel)
        view.addSubview(locationNameText)
        view.addSubview(goButton)
        configureConstraints()
        
   //     self.title = "Prayer Times for \(locationName)"

        let address = "Rio de Janeiro, Brazil"
        getCoordinateFrom(address: address) { coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            // don't forget to update the UI from the main thread
            DispatchQueue.main.async {
                print(address, "Location:", coordinate) // Rio de Janeiro, Brazil Location: CLLocationCoordinate2D(latitude: -22.9108638, longitude: -43.2045436)
            }
        }
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            table.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),
            
            addressLabel.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 0),
            addressLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            addressLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            addressLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
 
            locationNameText.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 40),
            locationNameText.heightAnchor.constraint(equalToConstant: 54),
            locationNameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            locationNameLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -60),

            locationNameText.topAnchor.constraint(equalTo: locationNameLabel.bottomAnchor, constant: 10),
            locationNameText.heightAnchor.constraint(equalToConstant: 44),
            locationNameText.widthAnchor.constraint(equalToConstant: 200),
            locationNameText.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),

            goButton.topAnchor.constraint(equalTo: locationNameLabel.bottomAnchor, constant: 10),
            goButton.heightAnchor.constraint(equalToConstant: 44),
            goButton.widthAnchor.constraint(equalToConstant: 44),
            goButton.leftAnchor.constraint(equalTo: locationNameText.rightAnchor, constant: 20),

        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PrayerTimingsTableViewCell", for: indexPath) as? PrayerTimingsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(viewModel: viewModels[indexPath.row])
        return cell
    }
    
    public private(set) var prayerTimesModel = [PrayerTimesModel]()
    
    func getPrayerTimes() {
         NetworkManager.shared.getAthanTime(month:"4", latValue: String(latitude), longValue: String(longitude)) { [weak self] result in
            guard let self = self else { return }
            switch(result) {
            case .success(let response):
                viewModels[0].timeLabel = response.data[0].timings.fajr
                viewModels[0].nameLabel = "Fajr"
                viewModels[1].timeLabel = response.data[0].timings.dhuhr
                viewModels[1].nameLabel = "Dhuhar"
                viewModels[2].timeLabel = response.data[0].timings.asr
                viewModels[2].nameLabel = "Asr"
                viewModels[3].timeLabel = response.data[0].timings.maghrib
                viewModels[3].nameLabel = "Maghrib"
                viewModels[4].timeLabel = response.data[0].timings.isha
                viewModels[4].nameLabel = "Isha"
                
                DispatchQueue.main.async {
                    self.table.reloadData()
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
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
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
            print(placemark.postalAddress ?? "Error: Address not found")
            guard let localAddress = placemark.postalAddress else {
                print("Error: Address not found")
                return
            }
            self.addressLabel.text = "  ADDRESS: \n\n\(localAddress)"
            var cleanAddress = self.addressLabel.text!.replacingOccurrences(of: ",", with: "\n ")
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
            self.addressLabel.text = cleanAddress
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


