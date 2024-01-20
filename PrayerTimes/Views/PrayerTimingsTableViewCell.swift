//
//  PrayerTimingsTableViewCell.swift
//  PrayerTimes
//
//  Created by Ali Siddiqui on 1/18/24.
//

import UIKit

class PrayerTimingsTableViewCell: UITableViewCell {
    let identifier = "PrayerTimingsTableViewCell"
 
   let prayerNameLabel: UILabel = {
        let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       label.backgroundColor = .systemBackground
       label.numberOfLines = 0
        return label
    }()
    
    let prayerTimeLabel: UILabel = {
         let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBackground
        label.textAlignment = .right
        label.numberOfLines = 0
         return label
     }()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(prayerNameLabel)
        contentView.addSubview(prayerTimeLabel)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            prayerNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            prayerNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            prayerNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            prayerNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.30),

            prayerTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            prayerTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            prayerTimeLabel.leftAnchor.constraint(equalTo: prayerNameLabel.rightAnchor),
            prayerTimeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        prayerNameLabel.text = nil
        prayerTimeLabel.text = nil
    }

    public func configure(viewModel: PrayerTimingsTableViewCellViewModel) {
        prayerNameLabel.text = viewModel.nameLabel
        prayerTimeLabel.text = viewModel.timeLabel
    }
}
