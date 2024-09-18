//
//  ProductDetailsViewController.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 05/09/2024.
//

import UIKit
import Kingfisher

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var addVariantOutlet: UIButton!
    @IBOutlet weak var saveOutlet: UIButton!
    @IBOutlet weak var addVariantView: UIView!
    @IBOutlet weak var addSizeTextField: UITextField!
    @IBOutlet weak var addColorTextfield: UITextField!
    @IBOutlet weak var addPriceTextField: UITextField!
    @IBOutlet weak var addQuantityTextField: UITextField!
    @IBOutlet weak var closeAddVariantViewOutlet: UIButton!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var updatePriceTextField: UITextField!
    @IBOutlet weak var editPriceButtonOutlet: UIButton!
    @IBOutlet weak var updateQuantityTextField: UITextField!
    @IBOutlet weak var editQuantityButtonOutlet: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var editPriceOutlet: UIButton!
    @IBOutlet weak var editQuantityOutlet: UIButton!
    @IBOutlet weak var EditView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var singleImage: UIImageView!
    @IBOutlet weak var ImageURLTextView: UITextView!
    @IBOutlet weak var deleteOulet: UIButton!
    @IBOutlet weak var cancelOulet: UIButton!
    @IBOutlet weak var delVariantOutlet: UIButton!
    
    var viewModel = ProductDetailsViewModel()
    var index = 0
    var variantIndex = 0
    var variantItemId : Int = 0
    var selectedSizeIndex : Int? = nil
    var selectedColorIndex: Int? = nil
    var imageIndex : IndexPath?
    var id : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupProductDetails(index: index)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let addButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveUpdates))
        self.navigationItem.rightBarButtonItem = addButton
    }
    @objc func saveUpdates() {
        self.navigationController?.popViewController(animated: true)
    }
    func setupProductDetails(index : Int) {
        productTitle.text = viewModel.productArray[index].title
        productBrand.text = "\(viewModel.productArray[index].vendor ?? ""), \(viewModel.productArray[index].productType ?? "")"
        productPriceLabel.text = "\(viewModel.productArray[index].variants?[variantItemId].price ?? "")$"
        productQuantityLabel.text = "\(viewModel.productArray[index].variants?.first?.inventoryQuantity ?? 0) in Stock"
        descriptionTextView.text = viewModel.productArray[index].bodyHTML
        viewModel.id = viewModel.productArray[index].id ?? 0
    }
    func setupVariantDetails(ProductIndex : Int?,variantIndex : Int?){
        viewModel.variantId = viewModel.productArray[ProductIndex ?? 0].variants?.first(where: {$0.position == variantIndex})?.id ?? 404
    }
    func setupViews() {
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        
        sizeCollectionView.dataSource = self
        sizeCollectionView.delegate = self
        
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        
        guard let layout = sizeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 20, height: 40)
        guard let layout = colorCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 20, height: 40)
        
        deleteView.layer.cornerRadius = 10.0
        deleteView.layer.borderWidth = 1.5
        deleteView.layer.borderColor = UIColor.red.cgColor
        deleteView.isHidden = true
        
        EditView.layer.cornerRadius = 10.0
        EditView.layer.borderWidth = 1.0
        EditView.layer.borderColor = UIColor.red.cgColor
        
        singleImage.layer.cornerRadius = 10.0
        
        ImageURLTextView.layer.cornerRadius = 10.0
        
        deleteOulet.layer.cornerRadius = 10.0
        deleteOulet.layer.borderWidth = 1.0
        deleteOulet.layer.borderColor = UIColor.red.cgColor
        
        cancelOulet.layer.cornerRadius = 10.0
        cancelOulet.layer.borderWidth = 1.0
        cancelOulet.layer.borderColor = UIColor.mintGreen.cgColor
        
        addVariantView.layer.cornerRadius = 10.0
        addVariantView.layer.borderWidth = 1.5
        addVariantView.layer.borderColor = UIColor.mintGreen.cgColor
        
        addVariantOutlet.layer.cornerRadius = 10.0
        addVariantOutlet.layer.borderWidth = 1.0
        addVariantOutlet.layer.borderColor = UIColor.mintGreen.cgColor
        
        delVariantOutlet.layer.cornerRadius = 10.0
        delVariantOutlet.layer.borderWidth = 1.0
        delVariantOutlet.layer.borderColor = UIColor.red.cgColor
        
        saveOutlet.layer.cornerRadius = 10.0
        saveOutlet.layer.borderWidth = 1.0
        saveOutlet.layer.borderColor = UIColor.mintGreen.cgColor
        
        closeAddVariantViewOutlet.layer.cornerRadius = 10.0
        closeAddVariantViewOutlet.layer.borderWidth = 1.0
        closeAddVariantViewOutlet.layer.borderColor = UIColor.systemRed.cgColor
        
        descriptionTextView.layer.cornerRadius = 10.0
        
        addVariantView.isHidden = true
        updatePriceTextField.isHidden = true
        updateQuantityTextField.isHidden = true
    }
    
    @IBAction func didSelectDeleteVariant(_ sender: Any) {
        
    
      if selectedSizeIndex != nil{
          let alert = UIAlertController(title: "Delete a Variant", message: "Are you sure?", preferredStyle: .alert)
          let okAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
              self.viewModel.deleteVaiant()
              self.viewModel.productArray[self.index].variants?.removeAll(where: {$0.id == self.id})
              self.sizeCollectionView.reloadData()
              self.colorCollectionView.reloadData()
          }
          let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
          alert.addAction(okAction)
          alert.addAction(dismissAction)
          self.present(alert, animated: true)

      }else if selectedColorIndex != nil{
          let alert = UIAlertController(title: "Delete a Variant", message: "Are you sure?", preferredStyle: .alert)
          let okAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
              self.viewModel.deleteVaiant()
              self.viewModel.productArray[self.index].variants?.removeAll(where: {$0.id == self.id})
              self.sizeCollectionView.reloadData()
              self.colorCollectionView.reloadData()
          }
          let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
          alert.addAction(okAction)
          alert.addAction(dismissAction)
          self.present(alert, animated: true)

      }else{
          let alert = UIAlertController(title: "", message: "Please Select Size or Color", preferredStyle: .alert)
          let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive)
          alert.addAction(dismissAction)
          self.present(alert, animated: true)
      }

    }
    @IBAction func didSelectDeleteImages(_ sender: Any) {
        deleteView.isHidden = false
    }
    
    @IBAction func didSelectCancel(_ sender: Any) {
        deleteView.isHidden = true
    }
    
    @IBAction func didSelectDelete(_ sender: Any) {
        viewModel.deleteImage()
        viewModel.imagesArray.remove(at: imageIndex?.row ?? 0)
        imagesCollectionView.reloadData()
        deleteView.isHidden = true
    }
    
    @IBAction func didSelectAddVariant(_ sender: Any) {
        addVariantView.isHidden = false
    }
    
    @IBAction func didSelectSave(_ sender: Any) {
        let size = addSizeTextField.text ?? "5"
        let color = addColorTextfield.text ?? "Blue"
        let price = addPriceTextField.text ?? "100.00"
        let quantity = Int(addQuantityTextField.text ?? "" ) ?? 10
        
        viewModel.variantParameters = ["variant" : [
            "product_id" : viewModel.id,
            "option1" : size,
            "option2" : color,
            "price" : price
        ]
        ]
        viewModel.addProductVariant {
            DispatchQueue.main.async {
                self.addVariantView.isHidden = true
            }
        }
        viewModel.quantityParameters = [
            "location_id": 72712781961,
            "inventory_item_id": self.variantItemId,
            "available": quantity
        ]
        viewModel.updateProductQuantity {
        }
        colorCollectionView.reloadData()
        sizeCollectionView.reloadData()
    }
    
    @IBAction func didSelectEditPrice(_ sender: Any) {
        editPriceOutlet.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        
        if updatePriceTextField.isHidden == true {
            updatePriceTextField.isHidden = false
        }else{
            guard let price = updatePriceTextField.text , !price.isEmpty
            else { return  }
            let alerrt = UIAlertController(title: "Updating Product's price", message: "Are you sure to save", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                self.viewModel.parameters = [
                    "variant" : [
                        "id": self.viewModel.variantId,
                        "price": price,
                        "metafields": [
                            [
                                "type": "single_line_text_field",
                                "namespace": "global"
                            ]
                        ]
                    ]
                ]
                self.viewModel.updateProduct {
                    DispatchQueue.main.async {
                        self.updatePriceTextField.isHidden = true
                        self.editPriceOutlet.setImage(UIImage(systemName: "pencil.line"), for: .normal)
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            alerrt.addAction(okAction)
            alerrt.addAction(cancelAction)
            self.present(alerrt, animated: true)
        }
        if updatePriceTextField.text != "" {
            productPriceLabel.text = "\(updatePriceTextField.text ?? "").00 EGP"
        }
    }
    
    @IBAction func didSelectEditQuantity(_ sender: Any) {
        editQuantityOutlet.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        if updateQuantityTextField.isHidden == true {
            updateQuantityTextField.isHidden = false
        }else{
            guard let quantity = Int(updateQuantityTextField.text ?? "")
            else { return  }
            let alerrt = UIAlertController(title: "Updating Product's quantity", message: "Are you sure to save", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                self.viewModel.quantityParameters = [
                    "location_id": 72712781961,
                    "inventory_item_id": self.variantItemId,
                    "available": quantity
                ]
                self.viewModel.updateProductQuantity() {
                    DispatchQueue.main.async {
                        self.updateQuantityTextField.isHidden = true
                        self.editQuantityOutlet.setImage(UIImage(systemName: "pencil.line"), for: .normal)
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            alerrt.addAction(okAction)
            alerrt.addAction(cancelAction)
            self.present(alerrt, animated: true)
        }
        if updateQuantityTextField.text != "" {
            productQuantityLabel.text = "\(updateQuantityTextField.text ?? "") in Stock"
        }
    }
    @IBAction func didSelectCloseAddVariantView(_ sender: Any) {
        addSizeTextField.text = ""
        addColorTextfield.text = ""
        addPriceTextField.text = ""
        addQuantityTextField.text = ""
        addVariantView.isHidden = true
    }
}
extension ProductDetailsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case sizeCollectionView :
            return viewModel.sizeArray.first?.values?.count ?? 0
        case colorCollectionView:
            return viewModel.colorArray.first?.values?.count ?? 7
        default:
            pageControl.numberOfPages = viewModel.imagesArray.count
            return viewModel.imagesArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case sizeCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SizeCollectionViewCell
            cell.productSize.text = viewModel.sizeArray.first?.values?[indexPath.row]
            updateCellAppearance(cell: cell, isSelected: indexPath.row == selectedSizeIndex)
            return cell
            
        case colorCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ColorCollectionViewCell
            cell.productColor.text = viewModel.colorArray.first?.values?[indexPath.row]
            updateCellAppearance(cell: cell, isSelected: indexPath.row == selectedColorIndex)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductDetailsCollectionViewCell
            let url = URL(string: viewModel.imagesArray[indexPath.row].src ?? "")
            cell.productImage.clipsToBounds = true
            cell.productImage.kf.setImage(with: url,placeholder: UIImage(named: "noimage"))
            cell.productImage.layer.cornerRadius = 50.0
            singleImage.kf.setImage(with: url,placeholder: UIImage(named: "noimage"))
            ImageURLTextView.text = viewModel.imagesArray[indexPath.row].src
            viewModel.imageId = viewModel.imagesArray[indexPath.row].id ?? 1
            imageIndex = indexPath
            return cell
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if imagesCollectionView != nil {
            let width = imagesCollectionView.frame.size.width
            let currentPage = Int(imagesCollectionView.contentOffset.x / width)
            pageControl.currentPage = currentPage
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case sizeCollectionView, colorCollectionView :
            return CGSize(width: 50, height: 40)
        default:
            return CGSize(width: imagesCollectionView.frame.width, height: imagesCollectionView.frame.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch collectionView {
        case sizeCollectionView:
            id = viewModel.productArray[index].variants?[indexPath.row].id
            if selectedSizeIndex == indexPath.row {
                selectedSizeIndex = nil
            } else {
                selectedSizeIndex = indexPath.row
            }
            variantItemId = viewModel.productArray[index].variants?[indexPath.row].inventoryItemID ?? 0
            productPriceLabel.text = "\(viewModel.productArray[index].variants?[indexPath.row].price ?? "")EGP"
            productQuantityLabel.text = "\(viewModel.productArray[index].variants?[indexPath.row].inventoryQuantity ?? 0) in Stock"
            setupVariantDetails(ProductIndex: index, variantIndex: (indexPath.row + 1))
            sizeCollectionView.reloadData()
            
        case colorCollectionView:
            if selectedColorIndex == indexPath.row {
                selectedColorIndex = nil
            } else {
                selectedColorIndex = indexPath.row
            }
            variantItemId = viewModel.productArray[index].variants?[indexPath.row].inventoryItemID ?? 0
            productPriceLabel.text = "\(viewModel.productArray[index].variants?[indexPath.row].price ?? "")EGP"
            productQuantityLabel.text = "\(viewModel.productArray[index].variants?[indexPath.row].inventoryQuantity ?? 0) in Stock"
            setupVariantDetails(ProductIndex: index, variantIndex: (indexPath.row + 1))
            id = viewModel.productArray[index].variants?[indexPath.row].id
            colorCollectionView.reloadData()
        default:
            break
        }
    }
    func updateCellAppearance(cell: UICollectionViewCell, isSelected: Bool) {
        if isSelected {
            cell.layer.borderWidth = 3.0
            cell.layer.borderColor = UIColor.mintGreen.cgColor
            cell.layer.cornerRadius = 10.0
        } else {
            cell.layer.borderWidth = 0.0
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.cornerRadius = 10.0
        }
    }
}
