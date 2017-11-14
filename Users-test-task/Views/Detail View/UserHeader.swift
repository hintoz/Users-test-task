//
//  UserHeader.swift
//  Users-test-task
//
//  Created by Евгений Дац on 13.11.2017.
//  Copyright © 2017 Evgeny Dats. All rights reserved.
//

import UIKit

class UserHeader: UIView {
    
    @IBOutlet weak var avatarImageView: UIImageView!

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        avatarImageView.layer.masksToBounds = false
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
        avatarImageView.clipsToBounds = true
    }
}
