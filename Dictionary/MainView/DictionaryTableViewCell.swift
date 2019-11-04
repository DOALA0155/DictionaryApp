//
//  DictionaryTableViewCell.swift
//  Dictionary
//
//  Created by 勝山翔紀 on 2019/10/26.
//  Copyright © 2019 勝山翔紀. All rights reserved.
//

import UIKit

class DictionaryTableViewCell: UITableViewCell {

    @IBOutlet weak var dictionaryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
