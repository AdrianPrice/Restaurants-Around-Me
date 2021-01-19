//
//  TableViewCell.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 18/1/21.
//

import UIKit

class RestaurantCell: UITableViewCell {
    
    var label: UILabel = {
        let label = UILabel()
        label.text = "Restaurant Placeholder"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont(name: "Arial", size: 20)
        
        return label
    }()
    
    let pictureView: UIImageView = {
        let pictureView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        pictureView.image = UIImage(named: "restaurantPlaceholder")
        
        pictureView.layer.masksToBounds = true
        pictureView.layer.cornerRadius = 10
        
        return  pictureView
    }()
    
    var ratingStar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.tintColor = .red
        
        return imageView
    }()
    
    var ratingStars: [UIImageView] = [UIImageView]()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        
        for _ in 0..<5 {
            ratingStars.append(ratingStar.copy())
        }
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupViews() {
        
        addSubview(pictureView)
        
        pictureView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(20)
            make.leading.equalTo(pictureView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
        
        addSubview(ratingStars[0])
        ratingStars[0].snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom)
            make.leading.equalTo(pictureView.snp.trailing).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        for index in 1..<5 {
            addSubview(ratingStars[index])
            ratingStars[index].snp.makeConstraints { (make) in
                make.top.equalTo(label.snp.bottom)
                make.leading.equalTo(ratingStars[index - 1].snp.trailing).offset(10)
                make.height.equalTo(20)
                make.width.equalTo(20)
            }
        }
        
            
    }
    
    func updateRatingStarts(rating: Double) {
        var rounded = round(rating * 2) / 2
        let roundedInt = Int(rounded)
        
        for index in 0..<roundedInt {
            rounded -= 1
            ratingStars[index].image = UIImage(systemName: "star.fill")
        }
        
        if rounded != 0 {
            ratingStars[roundedInt].image = UIImage(systemName: "star.leadinghalf.fill")
        }
    }

}

extension UIImageView {
    func copy() -> UIImageView {
        let newImage: UIImageView = {
            var imageView = UIImageView()
            
            imageView.image = self.image
            imageView.tintColor = self.tintColor
            
            return imageView
        }()
        
        return newImage
    }
}
