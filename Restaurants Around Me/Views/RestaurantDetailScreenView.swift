//
//  RestaurantDetailScreenView.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 19/1/21.
//

import Foundation
import UIKit
import SnapKit

class RestaurantDetailScreenView: UIView {
    let headerImage: UIImageView = {
        let pictureView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        pictureView.image = UIImage(named: "restaurantPlaceholder")
        
        return  pictureView
    }()
    
    var screenTitle: UILabel = {
        var label = UILabel()
        
        label.text = "Otto Enoteca & Pizzeria"
        label.font = UIFont(name: "Arial", size: 30)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var addressLabel: UILabel = {
        var label = UILabel()
        
        label.text = "1 5th Avenue, New York, NY 10003"
        label.font = UIFont(name: "Arial", size: 15)
        
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let mapSymbol: UIImageView = {
        var imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        imageView.tintColor = .black
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        addSubview(headerImage)
        addSubview(screenTitle)
        addSubview(addressLabel)
        addSubview(mapSymbol)
        
        initialiseView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialiseView () {
        headerImage.snp.makeConstraints { (make) in
            make.top.equalTo(snp_topMargin).inset(-50)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        screenTitle.snp.makeConstraints { (make) in
            make.top.equalTo(headerImage.snp.bottom)
            //make.centerY.equalToSuperview()
            //            make.top.equalTo(snp_topMargin)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(30)
            make.width.equalTo(400)
        }
        
        mapSymbol.snp.makeConstraints { (make) in
            make.top.equalTo(screenTitle.snp.bottom).offset(10)
            make.height.equalTo(15)
            make.width.equalTo(15)
            make.leading.equalToSuperview().offset(20)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(screenTitle.snp.bottom).offset(10)
            make.leading.equalTo(mapSymbol.snp.trailing).offset(5)
            //make.height.equalTo(45)
            make.width.equalToSuperview().inset(10)
        }
    }
    
    func updateValues (restaurantModel: RestaurantModel) {
        DispatchQueue.main.async {
            self.screenTitle.text = restaurantModel.name
            self.addressLabel.text = restaurantModel.location.address
            if let url = URL(string: restaurantModel.images.featureImage) {
                self.headerImage.load(url: url)
            }
            
        }
    }
    
    
}
