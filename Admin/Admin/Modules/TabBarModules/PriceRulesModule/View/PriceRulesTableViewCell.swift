//
//  PriceRulesTableViewCell.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 10/09/2024.
//

import UIKit

class PriceRulesTableViewCell: UITableViewCell {

    @IBOutlet weak var pricePertentage: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var MoneyRequired: UILabel!
    @IBOutlet weak var maxUsers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
