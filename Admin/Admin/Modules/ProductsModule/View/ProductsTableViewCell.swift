//
//  ProductsTableViewCell.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 02/09/2024.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productVersionLabel: UILabel!
    @IBOutlet weak var productCompany: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }
    
    private func setupCell() {
        self.layer.masksToBounds = false
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 0.3
        productImage.layer.cornerRadius = 20
        selectionStyle = .none
    }
}
