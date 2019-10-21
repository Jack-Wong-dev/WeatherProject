//
//  FavoriteTableViewCell.swift
//  WeatherApp
//
//  Created by Jack Wong on 10/20/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    lazy var favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(favoriteImageView)
        setImageConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: )")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
}


extension FavoriteTableViewCell {
    
     private func setImageConstraints() {
           favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([
               favoriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
               favoriteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
               favoriteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               favoriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
           ])
       }
    
}
