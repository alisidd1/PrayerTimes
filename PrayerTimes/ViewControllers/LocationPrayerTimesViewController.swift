//
//  LocationPrayerTimesViewController.swift
//  PrayerTimes
//
//  Created by Ali Siddiqui on 1/21/24.
//

import UIKit

class LocationPrayerTimesViewController: ViewController {
    
    var location: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        super.getCoordinateFrom(address: location ?? "") { coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            // don't forget to update the UI from the main thread
            DispatchQueue.main.async {
                print(self.location, "Location:", coordinate)
                // Rio de Janeiro, Brazil Location: CLLocationCoordinate2D(latitude: -22.9108638, longitude: -43.2045436)
            }
        }

    }
    
    init(location: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.location = location
        print(location)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
