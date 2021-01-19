//
//  LaunchScreenView.swift
//  Restaurants Around Me
//
//  Created by Adrian Price on 17/1/21.
//

import Foundation
import UIKit
import SnapKit

class LaunchScreenView: UIView {
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "Find Restaurants"
        label.tintColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 35)
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial", size: 25)
        
        button.backgroundColor = .blue
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .orange
        
        addSubview(title)
        addSubview(startButton)
        
        initialiseView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialiseView() {
        super.layoutSubviews()
        //title.frame = CGRect(x: 0, y: (frame.height / 2) - 100, width: frame.width, height: 200)
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.width.centerX.equalToSuperview()
            make.height.equalTo(200)
        }
        
        //startButton.frame = CGRect(x: 80, y: (frame.height) - 100, width: frame.width - 160, height: 50)
        
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
}
