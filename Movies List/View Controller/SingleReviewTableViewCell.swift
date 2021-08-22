//
//  SingleReviewTableViewCell.swift
//  Movies List
//
//  Created by Youssef Eldeeb on 16/08/2021.
//

import UIKit

class SingleReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
