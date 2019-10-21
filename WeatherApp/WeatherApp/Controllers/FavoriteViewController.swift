//
//  FavoriteViewController.swift
//  WeatherApp
//
//  Created by Jack Wong on 10/10/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    var allFavorites = [Image]() {
        didSet{
            imageTableView.reloadData()
        }
    }
    
    lazy var imageTableView: UITableView = {
        
        let tableView = UITableView()
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "favoriteCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = self.view.frame
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        view.addSubview(imageTableView)
        setTableViewContraints()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadFavorites()
        print(allFavorites.count)
        
    }
    
    
    private func loadFavorites() {
        do {
            allFavorites = try ImagePersistenceHelper.manager.get()
        } catch {
            print(error)
        }
    }
    
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource{
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
//    }
//    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imageTableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        let favoriteImage = allFavorites[indexPath.row]
        let imageUrlStr = favoriteImage.url
        
        cell.backgroundColor = .cyan
        ImageHelper.manager.getImage(urlStr: imageUrlStr) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let imageFromURL):
                    print(imageUrlStr)
                    cell.favoriteImageView.image = imageFromURL
                }
            }
        }
        return cell
    }
}

//MARK: - Constraints
extension FavoriteViewController {
    
    private func setTableViewContraints(){
        
        imageTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
}
