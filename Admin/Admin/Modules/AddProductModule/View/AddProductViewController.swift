//
//  AddProductViewController.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 03/09/2024.
//

import UIKit
import Kingfisher

class AddProductViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageUrlTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var addTagsTextField: UITextField!
    @IBOutlet weak var addSizeTextField: UITextField!
    @IBOutlet weak var addColorTextField: UITextField!
    @IBOutlet weak var dropDownOutletForcolor: UIButton!
    @IBOutlet weak var dropDownOutletForType: UIButton!
    @IBOutlet weak var dropDownOutletForSize: UIButton!
    @IBOutlet weak var dropDownOutletForTag: UIButton!
    @IBOutlet weak var dropDownOutletForImage: UIButton!
    @IBOutlet weak var typeTableView: UITableView!
    @IBOutlet weak var sizeTableView: UITableView!
    @IBOutlet weak var colorTableView: UITableView!
    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var addImageCollectionVew: UICollectionView!
    
    let viewModel = AddProductViewModel()
    var tagsArray = ["Kid","Men","Women"]
    var typesArray = ["Running","T-shirt","SHOES","Accessories"]
    var colorsArray = ["Black","White","Blue","Yellow","Green","Gray","Red","Orange","Purple","Gold","Pink"]
    var sizesArray = ["OS","1","2","3","4","5","6","7","8","9","10","12"]
    var imageArray : [String] = []
    var isHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView(tableView: typeTableView)
        setupTableView(tableView: colorTableView)
        setupTableView(tableView: sizeTableView)
        setupTableView(tableView: tagTableView)
        setupCollectionView(collectionView: addImageCollectionVew)
        addColorTextField.isEnabled = false
        addSizeTextField.isEnabled = false
        addTagsTextField.isEnabled = false
        typeTextField.isEnabled = false
        setupView()
    }
    func setupTableView(tableView: UITableView){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
    }
    func setupCollectionView(collectionView: UICollectionView){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = viewModel.vendor
        let saveButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(didSelectSave))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    @IBAction func didSelectDropDownForColor(_ sender: Any) {
        isHidden = !isHidden
        colorTableView.isHidden = isHidden
    }
    
    @IBAction func didSelectDropDownForType(_ sender: Any) {
        isHidden = !isHidden
        typeTableView.isHidden = isHidden
    } 
    @IBAction func didSelectDropDownForSize(_ sender: Any) {
        isHidden = !isHidden
        sizeTableView.isHidden = isHidden
    }
    @IBAction func didSelectDropDownForTag(_ sender: Any) {
        isHidden = !isHidden
        tagTableView.isHidden = isHidden
    }  
    @IBAction func didSelectDropDownForImage(_ sender: Any) {
        if imageUrlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let alert = UIAlertController(title: "Validation Error", message: "Please Enter At leat an Image", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive)
            alert.addAction(dismissAction)
            self.present(alert, animated: true)
            
        }else if imageArray.contains(imageUrlTextField.text!){
            if imageArray.isEmpty == false {
                addImageCollectionVew.isHidden = false
            }
            
            let alert = UIAlertController(title: "Validation Error", message: "This image already exists", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive)
            alert.addAction(dismissAction)
            self.present(alert, animated: true)
            
        }else{
            isHidden = !isHidden
            imageArray.append(imageUrlTextField
                .text ?? "")
            addImageCollectionVew.reloadData()
            addImageCollectionVew.isHidden = isHidden
        }
    }
    
    @objc func didSelectSave() {
        guard let title = titleTextField.text, !title.isEmpty,
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
            "vendor": viewModel.vendor,
            "product_type": productType,
            "body_html": description,
            "variants": [
                [
                    "price" : price,
                    "option1" : color[0],
                    "option2" : size[0],
                    "inventory_quantity": Int(quantity) ?? 0
                ]
            ],
            "images": [["src" : "\(imageArray[0])"]],
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
        descriptionTextView.layer.cornerRadius = 10.0
        dropDownOutletForcolor.layer.cornerRadius = 10.0
        dropDownOutletForType.layer.cornerRadius = 10.0
        dropDownOutletForSize.layer.cornerRadius = 10.0
        dropDownOutletForTag.layer.cornerRadius = 10.0
        dropDownOutletForImage.layer.cornerRadius = 10.0
    }
}
extension AddProductViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case sizeTableView:
            return sizesArray.count
        case colorTableView:
            return colorsArray.count
        case tagTableView:
            return tagsArray.count
        default:
            return typesArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch tableView {
        case sizeTableView:
            cell.textLabel?.text = sizesArray[indexPath.row]
            return cell
        case colorTableView:
            cell.textLabel?.text = colorsArray[indexPath.row]
            return cell
        case tagTableView:
            cell.textLabel?.text = tagsArray[indexPath.row]
            return cell
        default:
            cell.textLabel?.text = typesArray[indexPath.row]
            return cell
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch tableView {
        case sizeTableView:
            if typeTextField.text == "T-shirt" {
                sizesArray = ["OS","XS","S","M","L","XL","XXL","XXXL"]
                sizeTableView.reloadData()
                addSizeTextField.text = sizesArray[indexPath.row]
                sizeTableView.isHidden = true
            }else{
                addSizeTextField.text = sizesArray[indexPath.row]
                sizeTableView.isHidden = true
            }
        case colorTableView:
            addColorTextField.text = colorsArray[indexPath.row]
            colorTableView.isHidden = true
        case tagTableView:
            addTagsTextField.text = tagsArray[indexPath.row]
            tagTableView.isHidden = true
        default:
            typeTextField.text = typesArray[indexPath.row]
            typeTableView.isHidden = true
        }
    }
}
protocol CustomCellDelegate: AnyObject {
    func didTapRemoveButton(at index: Int)
}

extension AddProductViewController : UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout, CustomCellDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddImageCollectionViewCell
        let url = URL(string: imageArray[indexPath.row])
        cell.newImage.kf.setImage(with: url, placeholder: UIImage(named: "noimage"))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 100.0)
    }
    func didTapRemoveButton(at index: Int) {
         imageArray.remove(at: index)
         
         addImageCollectionVew.deleteItems(at: [IndexPath(row: index, section: 0)])
     }
    
    
    
}
