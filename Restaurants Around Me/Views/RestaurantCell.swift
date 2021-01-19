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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        
        separatorInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        
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
            make.bottom.equalToSuperview()
            make.leading.equalTo(pictureView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
    }

}
