//
//  UserTableViewCell.swift
//  Users-test-task
//
//  Created by Евгений Дац on 13.11.2017.
//  Copyright © 2017 Evgeny Dats. All rights reserved.
//

import UIKit
import AlamofireImage

class UserTableViewCell: UITableViewCell {
    static let reuseIdentifier = "UserTableViewCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        configContainerView()
        configAvatarImageView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configContainerView(scale: Bool = true) {
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 5
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.masksToBounds = true
        
        layer.shadowOpacity = 0.35
        layer.shadowOffset = CGSize(width: 1, height: 2)
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func configAvatarImageView() {
//        avatarImageView.layer.borderWidth = 3.0
//        avatarImageView.layer.borderColor = UIColor.lightBlue.cgColor
        avatarImageView.layer.masksToBounds = false
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
        avatarImageView.clipsToBounds = true
    }
    
    func config(with user: User) {
        if let avatarUrl = user.avatarUrl, avatarUrl != "" {
            avatarImageView.af_setImage(withURL: URL(string: avatarUrl)!,
                                        placeholderImage: UIImage(named: "person-placeholder.png"),
                                        imageTransition: .crossDissolve(0.2),
                                        runImageTransitionIfCached: false)
        } else {
            avatarImageView.image = UIImage(named: "person-placeholder.png")
        }
        
        if let firstName = user.firstName, let lastName = user.lastName {
            userNameLabel.text = "\(firstName) \(lastName)"
        }
        
        emailLabel.text = user.email
    }
    
}
