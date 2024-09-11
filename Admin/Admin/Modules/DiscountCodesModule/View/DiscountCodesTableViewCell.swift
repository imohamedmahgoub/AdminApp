//
//  DiscountCodesTableViewCell.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 11/09/2024.
//

import UIKit

class DiscountCodesTableViewCell: UITableViewCell {
    @IBOutlet weak var codeTitle: UILabel!
    @IBOutlet weak var usageNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
