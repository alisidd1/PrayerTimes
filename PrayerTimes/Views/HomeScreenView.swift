//
//  swift
//  PrayerTimes
//
//  Created by Ali Siddiqui on 1/22/24.
//

import UIKit

class HomeScreenView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    private var viewModels: [PrayerTimingsTableViewCellViewModel] = Array(0..<5).map { _ in
        return PrayerTimingsTableViewCellViewModel()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(table)
        addSubview(addressLabel)
        addSubview(locationNameLabel)
        addSubview(locationNameText)
        addSubview(goButton)
        table.delegate = self
        table.dataSource = self
        configureConstraints()
        locationNameText.delegate = self
        locationNameText.becomeFirstResponder()

//        addressLabel.text = "  ADDRESS: \n\n\(localAddress)"

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(PrayerTimingsTableViewCell.self,
                       forCellReuseIdentifier: "PrayerTimingsTableViewCell")
        table.backgroundColor = .systemBackground
        return table
    }()
    
    let addressLabel: UILabel  = {
        let addressLabel               = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.backgroundColor   = .systemBackground
        addressLabel.numberOfLines = 0
        addressLabel.layer.borderWidth = 3
        addressLabel.layer.borderColor = UIColor.systemBlue.cgColor
        return addressLabel
    }()
    
    let locationNameLabel: UILabel  = {
        let locationNameLabel               = UILabel()
        locationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        locationNameLabel.backgroundColor   = .systemBackground
        locationNameLabel.numberOfLines = 0
        locationNameLabel.layer.borderWidth = 3
        locationNameLabel.text = " Enter location name below:"
        locationNameLabel.layer.borderColor = UIColor.systemBlue.cgColor
        return locationNameLabel
    }()
 
    let locationNameText: UITextField      = {
        let locationNameText               = UITextField()
        locationNameText.translatesAutoresizingMaskIntoConstraints = false
        locationNameText.backgroundColor   = .systemBackground
        locationNameText.placeholder = "Enter Loation Name"
        locationNameText.layer.borderWidth = 3
        locationNameText.layer.borderColor = UIColor.systemBlue.cgColor
        return locationNameText
    }()
    
    let goButton: UIButton  = {
        let goButton               = UIButton()
        goButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.backgroundColor   = .systemCyan
        return goButton
    }()

    func configureConstraints() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: topAnchor),
            table.rightAnchor.constraint(equalTo: rightAnchor),
            table.leftAnchor.constraint(equalTo: leftAnchor),
            table.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            
            addressLabel.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 0),
            addressLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -200),
            addressLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            addressLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
 
            locationNameLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 40),
            locationNameLabel.heightAnchor.constraint(equalToConstant: 44),
            locationNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            locationNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -60),

            locationNameText.topAnchor.constraint(equalTo: locationNameLabel.bottomAnchor, constant: 10),
            locationNameText.heightAnchor.constraint(equalToConstant: 44),
            locationNameText.widthAnchor.constraint(equalToConstant: 200),
            locationNameText.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),

            goButton.topAnchor.constraint(equalTo: locationNameLabel.bottomAnchor, constant: 10),
            goButton.heightAnchor.constraint(equalToConstant: 44),
            goButton.widthAnchor.constraint(equalToConstant: 44),
            goButton.leftAnchor.constraint(equalTo: locationNameText.rightAnchor, constant: 20),

        ])
    }

    func configure(viewModel: PrayerTimesModel) {
        self.viewModels[0].timeLabel = viewModel.data[0].timings.fajr
        self.viewModels[0].nameLabel = "Fajr"
        self.viewModels[1].timeLabel = viewModel.data[1].timings.dhuhr
        self.viewModels[1].nameLabel = "Dhuhar"
        self.viewModels[2].timeLabel = viewModel.data[2].timings.asr
        self.viewModels[2].nameLabel = "Asr"
        self.viewModels[3].timeLabel = viewModel.data[3].timings.maghrib
        self.viewModels[3].nameLabel = "Maghrib"
        self.viewModels[4].timeLabel = viewModel.data[4].timings.isha
        self.viewModels[4].nameLabel = "Isha"

        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("/**** \n\n table size - \(viewModels.count)\n\n")
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PrayerTimingsTableViewCell", for: indexPath) as? PrayerTimingsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(viewModel: viewModels[indexPath.row])
        print("/**** \n\n cell")
        print(cell)
        return cell
    }

}
