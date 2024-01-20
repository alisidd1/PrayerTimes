//
//  ViewController.swift
//  PrayerTimes
//
//  Created by Ali Siddiqui on 1/16/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
     
    private var viewModels: [PrayerTimingsTableViewCellViewModel] = Array(0..<5).map { _ in
        return PrayerTimingsTableViewCellViewModel()
    }
    
    private let manager = CLLocationManager()

    private var longitude: Double = 0.0
    private var latitude: Double = 0.0
    
    private let table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(PrayerTimingsTableViewCell.self,
                       forCellReuseIdentifier: "PrayerTimingsTableViewCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        self.title = "Prayer Times"
        table.delegate = self
        table.dataSource = self
        view.addSubview(table)
        configureConstraints()
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("** -> viewModels.count = \(viewModels.count)")
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PrayerTimingsTableViewCell", for: indexPath) as? PrayerTimingsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(viewModel: viewModels[indexPath.row])
        return cell
    }
    
//  getAthanTime(month: String, latValue: String, longValue: String, completion: @escaping (Result<[Welcome], CustomError>) -> Void ) {
    
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

         DispatchQueue.global(qos: .userInitiated).async {
             sleep(1)
         }
     }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }
        latitude = first.coordinate.latitude
        longitude = first.coordinate.longitude        
        getPrayerTimes()
    }
}




