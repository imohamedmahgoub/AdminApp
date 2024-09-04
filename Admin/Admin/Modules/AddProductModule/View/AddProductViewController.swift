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
        viewModel.parameters["product"]?["title"] = titleTextField.text
        viewModel.parameters["product"]?["vendor"] = vendorTextField.text
        viewModel.parameters["product"]?["product_type"] = typeTextField.text
        viewModel.parameters["product"]?["body_html"] = descriptionTextView.text
        viewModel.parameters["product"]?["price"] = priceTextField.text
        viewModel.parameters["product"]?["inventory_quantity"] = quantityTextField.text
        viewModel.parameters["product"]?["src"] = imageUrlTextField.text
        viewModel.parameters["product"]?["status"] = "active"
        viewModel.createProduct {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
