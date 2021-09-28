//
//  SchoolListTableViewCell.swift
//  20210918-JohnRussell-NYCSchools
//
//  Created by john Russell on 9/18/21.
//

import UIKit

class SchoolListTableViewCell: UITableViewCell {

    // Prompts
    @IBOutlet weak var namePromptLabel: UILabel!
    @IBOutlet weak var middleRowPromptLabel: UILabel!
    @IBOutlet weak var cityPromptLabel: UILabel!
    @IBOutlet weak var zipPromptLabel: UILabel!
    // Data
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var middleRowLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
