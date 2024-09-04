//
//  AddProductViewController.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 03/09/2024.
//

import UIKit

class AddProductViewController: UIViewController {
    
    let viewModel = AddProductViewModel()
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var vendorTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageUrlTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vendorTextField.text = viewModel.vendor
        vendorTextField.isEnabled = false
    }
    @IBAction func didSelectSave(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
              let vendor = vendorTextField.text, !vendor.isEmpty,
              let productType = typeTextField.text, !productType.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty,
              let price = priceTextField.text, !price.isEmpty,
              let quantity = quantityTextField.text, !quantity.isEmpty,
              let imageUrl = imageUrlTextField.text, !imageUrl.isEmpty
        else {
            let alert = UIAlertController(title: "Failed", message: "Please fill in all the fields", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive)
            alert.addAction(dismissAction)
            self.present(alert, animated: true)
            return
        }
        viewModel.parameters = [
            "title": title,
            "vendor": vendor,
            "product_type": productType,
            "body_html": description,
            "variants": [
                ["price": price, "inventory_quantity": Int(quantity) ?? 0]
            ],
            "image": ["src": imageUrl],
            "status": "active"
        ]
        viewModel.createProduct {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
