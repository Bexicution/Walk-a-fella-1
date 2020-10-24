//
//  LeaderboardTableViewCell.swift
//  Step Out
//
//  Created by Mac on 8/23/20.
//  Copyright © 2020 Bexultan. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    @IBOutlet var ratingNum: UILabel!
    @IBOutlet var personImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var surname: UILabel!
    @IBOutlet var stepsNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure (with person: Person) {
        name.text = person.name
        surname.text = person.surname
        stepsNum.text = "\(person.steps)"
        ratingNum.text = "0"
    }
}
