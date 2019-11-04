//
//  WordTableViewCell.swift
//  Dictionary
//
//  Created by 勝山翔紀 on 2019/10/28.
//  Copyright © 2019 勝山翔紀. All rights reserved.
//

import UIKit

class WordTableViewCell: UITableViewCell {

    @IBOutlet weak var wordNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
