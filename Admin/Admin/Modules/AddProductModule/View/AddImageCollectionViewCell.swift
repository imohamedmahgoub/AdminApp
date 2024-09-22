//
//  AddImageCollectionViewCell.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 22/09/2024.
//

import UIKit

class AddImageCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CustomCellDelegate?
    var indexPath: IndexPath?
    @IBOutlet weak var newImage: UIImageView!
    @IBAction func removeImage(_ sender: Any) {
        if let index = indexPath?.row {
            delegate?.didTapRemoveButton(at: index)
        }
    }
    
}
