//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Jack Wong on 10/10/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    var chosenForecast: Forecast!
    var locationName: String!
    var imageView: Image!
    
    lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    lazy var chosenLocationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 18)
        label.text = """
        Forecast for \(locationName!) on \(chosenForecast.formattedDate)
        """
        label.textAlignment = .center
        return label
    }()
    
    lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.text = chosenForecast.summary
        return label
    }()
    
    lazy var highTemperatureLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "High: \(chosenForecast.temperatureHigh) °F"
        label.textAlignment = .center
        return label
    }()
    
    lazy var lowTemperatureLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Low: \(chosenForecast.temperatureLow) °F"
        return label
    }()
    
    lazy var sunriseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Sunrise: \(chosenForecast.formattedSunriseTime)"
        return label
    }()
    
    lazy var sunsetLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Sunset: \(chosenForecast.formattedSunsetTime)"
        return label
    }()
    
    lazy var windSpeedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Wind Speed: \(chosenForecast.windSpeed) mph"
        return label
    }()
    
    lazy var precipitationChanceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        //TODO: Set places after decimal point
        label.text = "Chance of Precipitation: \(chosenForecast.precipProbability*100)%"
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [weatherLabel, highTemperatureLabel, lowTemperatureLabel, sunriseLabel, sunsetLabel, windSpeedLabel, precipitationChanceLabel])
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.alignment = .center
        return vStack
    }()
    
    
    lazy var favoriteButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Save to Favorites", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveToFavorites))
        return barButton
    }()
    
    private enum SavedAlready {
        case yes
        case no
    }
    
    @objc func saveToFavorites(sender: UIBarButtonItem){
        if let existsInFavorites = imageView.existsInFavorites() {
            switch existsInFavorites {
            case false:
                print("Saving to favorites")
                do {
                    try ImagePersistenceHelper.manager.save(newImage: imageView)
                } catch {
                    print(error)
                }
            case true:
                print("Already saved")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = favoriteButton
        self.navigationItem.title = "Forecast"
        
        view.addSubview(chosenLocationLabel)
        view.addSubview(locationImageView)
        view.addSubview(stackView)
        
        setChosenLocationLabelConstraints()
        setImageConstraints()
        setStackViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadImage()
    }
    
    private func loadImage() {
        let urlStr = ImageAPIClient.getSearchResultsURLStr(from: locationName)
        
        ImageAPIClient.manager.getImage(urlStr: urlStr) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let imageDataFromURL):
                    if let someRandomImage = Image.getRandomImage(images: imageDataFromURL) {
                        self.dataToImage(someImage: someRandomImage)
                        self.imageView = someRandomImage
                    }
                }
            }
        }
    }
    
    private func dataToImage(someImage: Image) {
        let urlStr = someImage.url
        
        ImageHelper.manager.getImage(urlStr: urlStr) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                    self.locationImageView.image = UIImage(named: "na")
                case .success(let imageFromURL):
                    self.locationImageView.image = imageFromURL
                }
            }
        }
    }
    
}

extension WeatherDetailViewController {
    
    private func setChosenLocationLabelConstraints(){
        self.chosenLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.chosenLocationLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            self.chosenLocationLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.chosenLocationLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.chosenLocationLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setImageConstraints(){
        self.locationImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.locationImageView.topAnchor.constraint(equalTo: self.chosenLocationLabel.bottomAnchor, constant: 0),
            self.locationImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.locationImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            self.locationImageView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])
    }
    
    
    private func setStackViewConstraints(){
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.locationImageView.bottomAnchor, constant: 10),
            self.stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 20),
            self.stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
