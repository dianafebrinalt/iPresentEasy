//
//  SectionTableViewCell.swift
//  iPresentEasy
//
//  Created by Mohammad Sulthan on 04/08/21.
//

import UIKit

class SectionTableViewCell: UITableViewCell {
    @IBOutlet weak var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
