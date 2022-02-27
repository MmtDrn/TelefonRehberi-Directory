//
//  DirectoryTableViewCell.swift
//  Directory
//
//  Created by MacBook on 26.02.2022.
//

import UIKit

class DirectoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var personLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
