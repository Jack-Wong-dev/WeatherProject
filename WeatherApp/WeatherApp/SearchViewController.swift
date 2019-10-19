//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Jack Wong on 10/10/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Weather Forecast"
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    lazy var weatherCollectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .cyan
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "weatherCell")
        return collectionView
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter ZipCode"
        return textField
    }()
    
    private var allWeather = [Forecast]() {
        didSet {
            self.weatherCollectionView.reloadData()
        }
    }
    
    private var searchString: String? {
        didSet {
            loadLatLongFromZip()
            self.weatherCollectionView.reloadData()
            
            if let searchString = searchString {
                UserDefaultsWrapper.manager.store(searchString: searchString)
            }
        }
    }
    
    private var locationName = ""
    private var latitude = ""
    private var longitude = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.keyboardType = .numberPad
        textField.addDoneCancelToolbar(onDone: (target: self, action: #selector(self.tapDone)), onCancel: (target: self, action: #selector(self.tapCancel)))
        
        
        self.view.backgroundColor = .cyan
        self.navigationItem.title = "Search Forecast"
        
        self.view.addSubview(weatherLabel)
        self.view.addSubview(textField)
        self.view.addSubview(weatherCollectionView)
        
        if let collectionLayout = weatherCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        }
        
        setWeatherLabelConstraints()
        setTextFieldConstraints()
        setCollectionViewConstraints()
    }
    
    @objc func tapDone() {
        print("tapped Done")
        self.searchString = textField.text
        textField.resignFirstResponder()
        
    }
    
    @objc func tapCancel() {
        print("tapped cancel")
        textField.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setInitialValuesFromUserDefaults()
    }
    
    
    private func setInitialValuesFromUserDefaults() {
        if let savedSearchString = UserDefaultsWrapper.manager.getSearchString() {
            searchString = savedSearchString
        }
    }
    
    private func loadLatLongFromZip() {
        ZipCodeHelper.getLatLong(searchString ?? "") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    self.latitude = String(data.lat)
                    self.longitude = String(data.long)
                    self.locationName = String(data.location)
                    
                    self.loadData()
                    self.updateLocationLabel()
                }
            }
        }
    }
    
    private func loadData() {
        let urlStr = WeatherAPIClient.getSearchResultsURLStr(from: latitude, longitude: longitude)
        
        WeatherAPIClient.manager.getWeather(urlStr: urlStr) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    self.allWeather = data
                }
            }
        }
    }
    
    private func updateLocationLabel() {
        self.weatherLabel.text = "Weekly Forecast for \(locationName)"
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCollectionViewCell
        let selectedWeather = allWeather[indexPath.row]
        
        let date = selectedWeather.formattedDate
        cell.dateLabel.text = date
        
        if let selectedImage = UIImage(named: selectedWeather.icon) {
            cell.weatherImageView.image = selectedImage
        } else {
            cell.weatherImageView.image = UIImage(named: "na")
        }
        
        cell.configureCell(forecast: selectedWeather)
        return cell
    }
    
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchString = textField.text
        textField.resignFirstResponder()
        return true
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width * 0.7 , height: view.bounds.height * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let weatherDetailVC = WeatherDetailViewController()
        weatherDetailVC.chosenForecast = allWeather[indexPath.row]
        weatherDetailVC.locationName = locationName
        
        self.navigationController?.pushViewController(weatherDetailVC, animated: true)
    }
}


extension SearchViewController{
    
    private func setWeatherLabelConstraints() {
        self.weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.weatherLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.weatherLabel.heightAnchor.constraint(equalToConstant: 50),
            self.weatherLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.weatherLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setTextFieldConstraints() {
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.textField.topAnchor.constraint(equalTo: self.weatherCollectionView.bottomAnchor, constant: 10),
            self.textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textField.heightAnchor.constraint(equalToConstant: 30),
            self.textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50)
        ])
    }
    
    private func setCollectionViewConstraints() {
        self.weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.weatherCollectionView.topAnchor.constraint(equalTo: self.weatherLabel.bottomAnchor, constant: 5),
            self.weatherCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.weatherCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.weatherCollectionView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}
