//
//  InventoyTableViewCell.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 08/09/2024.
//

import UIKit

class InventoyTableViewCell: UITableViewCell {

    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopCountry: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
