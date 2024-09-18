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
    @IBOutlet weak var addTagsTextField: UITextField!
    @IBOutlet weak var addSizeTextField: UITextField!
    @IBOutlet weak var addColorTextField: UITextField!
    @IBOutlet weak var saveOutlet: UIButton!
    @IBOutlet weak var nextView: UIView!
    @IBOutlet weak var cancelOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vendorTextField.text = viewModel.vendor
        vendorTextField.isEnabled = false
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Add Product"
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPage))
        self.navigationItem.rightBarButtonItem = nextButton
    }
    @objc func nextPage(){
        nextView.isHidden = false
    }
    
    @IBAction func didSelectCancel(_ sender: Any) {
        nextView.isHidden = true
    }
    @IBAction func didSelectSave(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
              let vendor = vendorTextField.text, !vendor.isEmpty,
              let productType = typeTextField.text, !productType.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty,
              let price = priceTextField.text, !price.isEmpty,
              let quantity = quantityTextField.text, !quantity.isEmpty,
              let imageUrl = imageUrlTextField.text, !imageUrl.isEmpty,
              let tag = addTagsTextField.text , !tag.isEmpty,
              let size = addSizeTextField.text?.split(separator: ",").map({ String($0) }), !size.isEmpty,
              let color = addColorTextField.text?.split(separator: ",").map({ String($0) }), !color.isEmpty
        else {
            let alert = UIAlertController(title: "Failed", message: "Please fill in all the fields", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive)
            alert.addAction(dismissAction)
            self.present(alert, animated: true)
            return
        }
        viewModel.parameters = ["product" : [
            "title": title,
            "vendor": vendor,
            "product_type": productType,
            "body_html": description,
            "variants": [
                [
                    "price" : price,
                    "option1" : color[0],
                    "option2" : size[0],
                    "inventory_quantity": Int(quantity) ?? 0
                ],
                [
                    "price" : price,
                    "option1" : color[1],
                    "option2" : size[1],
                    "inventory_quantity": Int(quantity) ?? 0
                ]
            ],
            "images": [["src" : "\(imageUrl)"]],
            "status": "active",
            "tags" : tag,
            "options": [
                [
                    "name": "Color",
                    "values": color
                ],
                [
                    "name": "Size",
                    "values": size
                ]
            ]
        ]
        ]
        viewModel.createProduct {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func setupView() {
        nextView.isHidden = true
        nextView.layer.cornerRadius = 10.0
        nextView.layer.borderColor = UIColor.mintGreen.cgColor
        nextView.layer.borderWidth = 1.5
        
        saveOutlet.layer.cornerRadius = 10.0
        saveOutlet.layer.borderColor = UIColor.mintGreen.cgColor
        saveOutlet.layer.borderWidth = 1.0
        
        cancelOutlet.layer.cornerRadius = 10.0
        cancelOutlet.layer.borderColor = UIColor.red.cgColor
        cancelOutlet.layer.borderWidth = 1.0
        
        descriptionTextView.layer.cornerRadius = 10.0
    }
}
