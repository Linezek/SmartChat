//
//  UserCell.swift
//  chatchat
//
//  Created by Antoine Galpin on 07/10/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let timelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        return label
    }()
    
    override init(style:UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timelabel)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timelabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timelabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
       // timelabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timelabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
        timelabel.font.withSize(1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Fatal error (inCode) from UserCell")
    }
}
