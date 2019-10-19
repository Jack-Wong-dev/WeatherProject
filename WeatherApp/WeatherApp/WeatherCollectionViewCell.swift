//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Jack Wong on 10/17/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    lazy var highTemperatureLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var lowTemperatureLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [highTemperatureLabel, lowTemperatureLabel])
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpCellAppearance()
        
        self.contentView.addSubview(weatherImageView)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(vStack)
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func addConstraints() {
        setDateLabelConstraints()
        setWeatherImageViewConstraints()
        setLabelStackViewConstraints()
    }
    
    func configureCell(forecast: Forecast){
        backgroundColor = .systemTeal
        highTemperatureLabel.text = "High: \(forecast.temperatureHigh)°F"
        lowTemperatureLabel.text = "Low: \(forecast.temperatureLow)°F"
    }
    
    
}

//MARK: - Constraints
extension WeatherCollectionViewCell{
    
    private func setUpCellAppearance() {
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.masksToBounds = true
    }
    
    private func setDateLabelConstraints() {
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 5),
            self.dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setWeatherImageViewConstraints() {
        self.weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.weatherImageView.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 5),
            self.weatherImageView.heightAnchor.constraint(equalToConstant: 100),
            self.weatherImageView.widthAnchor.constraint(equalToConstant: 100),
            self.weatherImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setLabelStackViewConstraints() {
        self.vStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.vStack.topAnchor.constraint(equalTo: self.weatherImageView.bottomAnchor, constant: 5),
            self.vStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            self.vStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 5),
            self.vStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ])
    }
}
