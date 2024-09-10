//
//  ProductDetailsViewController.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 05/09/2024.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

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
    @IBOutlet weak var saveAllUpdatesOutlet: UIButton!
    var viewModel = ProductDetailsViewModel()
    var disposeBag = DisposeBag()
    var index = 0
    var variantIndex = 0
    var variantItemId = 0
    var selectedSizeIndex : Int? = nil
    var selectedColorIndex: Int? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        setupProductDetails(index: index)
    }
    func setupProductDetails(index : Int) {
        productTitle.text = viewModel.productArray[index].title
        productBrand.text = "\(viewModel.productArray[index].vendor ?? ""), \(viewModel.productArray[index].productType ?? "")"
        productPriceLabel.text = "\(viewModel.productArray[index].variants?.first?.price ?? "")$"
        productQuantityLabel.text = "\(viewModel.productArray[index].variants?.first?.inventoryQuantity ?? 0) in Stock"
        descriptionTextView.text = viewModel.productArray[index].bodyHTML
        viewModel.id = viewModel.productArray[index].id ?? 0
    }
    func setupVariantDetails(ProductIndex : Int?,variantIndex : Int?){
        viewModel.variantId = viewModel.productArray[ProductIndex ?? 0].variants?.first(where: {$0.position == variantIndex})?.id ?? 404
        print(viewModel.variantId)
    }
    func setupCollectionViews() {
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        
        sizeCollectionView.dataSource = self
        sizeCollectionView.delegate = self
        
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        
        startAutoScroll()
        addVariantOutlet.layer.cornerRadius = 10.0
        saveOutlet.layer.cornerRadius = 5.0
        addVariantView.layer.cornerRadius = 10.0
        closeAddVariantViewOutlet.layer.cornerRadius = 10.0
        descriptionTextView.layer.cornerRadius = 10.0
        saveAllUpdatesOutlet.layer.cornerRadius = 10.0
        
        addVariantView.isHidden = true
        updatePriceTextField.isHidden = true
        updateQuantityTextField.isHidden = true
    }
    
    @IBAction func didSelectAddVariant(_ sender: Any) {
        addVariantView.isHidden = false
    }
    
    @IBAction func didSelectSave(_ sender: Any) {
        addVariantView.isHidden = true
    }
    
    @IBAction func didSelectEditPrice(_ sender: Any) {
        if updatePriceTextField.isHidden == true {
            updatePriceTextField.isHidden = false
        }else{
            guard let price = updatePriceTextField.text , !price.isEmpty
                    // let quantity = Int(updateQuantityTextField.text ?? "")
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
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            alerrt.addAction(okAction)
            alerrt.addAction(cancelAction)
            self.present(alerrt, animated: true)
        }
        if updatePriceTextField.text != "" {
            productPriceLabel.text = "\(updatePriceTextField.text ?? "").00 $"
        }
    }
    
    @IBAction func didSelectEditQuantity(_ sender: Any) {
        if updateQuantityTextField.isHidden == true {
            updateQuantityTextField.isHidden = false
        }else{
            guard let quantity = Int(updateQuantityTextField.text ?? "")
            else { return  }
            print(variantItemId)
            let alerrt = UIAlertController(title: "Updating Product's quantity", message: "Are you sure to save", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                
                self.viewModel.quantityParameters = [
                    "inventory_level" : [
                        "set" :  [ [], // Params
                                   ["location_id" : 72712781961, "inventory_item_id" : self.variantItemId, "available" : quantity] ]// Body
                    ]
                ]
                self.viewModel.updateProduct {
                    DispatchQueue.main.async {
                        self.updateQuantityTextField.isHidden = true
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
    
    @IBAction func didSelectSaveAllUpdates(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ProductDetailsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case sizeCollectionView :
            return viewModel.sizeArray.count
        case colorCollectionView:
            return viewModel.colorArray.count
        default:
            pageControl.numberOfPages = viewModel.imagesArray.count
            return viewModel.imagesArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case sizeCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SizeCollectionViewCell
            cell.productSize.text = viewModel.sizeArray[indexPath.row]
            updateCellAppearance(cell: cell, isSelected: indexPath.row == selectedSizeIndex)
            return cell
            
        case colorCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ColorCollectionViewCell
            cell.productColor.text = viewModel.colorArray[indexPath.row]
            updateCellAppearance(cell: cell, isSelected: indexPath.row == selectedColorIndex)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductDetailsCollectionViewCell
            let url = URL(string: viewModel.imagesArray[indexPath.row].src ?? "")
            cell.productImage.clipsToBounds = true
            cell.productImage.kf.setImage(with: url,placeholder: UIImage(named: "noimage"))
            cell.productImage.layer.cornerRadius = 50.0
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case sizeCollectionView :
            return CGSize(width: 30, height: 40)
        case colorCollectionView :
            return CGSize(width: 50, height: 40)
        default:
            return CGSize(width: imagesCollectionView.frame.width, height: imagesCollectionView.frame.height)
        }
    }
    
    func startAutoScroll() {
        viewModel.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(autoScrollCollectionView), userInfo: nil, repeats: true)
    }
    
    @objc func autoScrollCollectionView() {
        if viewModel.index >= viewModel.imagesArray.count{
            viewModel.index = 0
        }
        imagesCollectionView.scrollToItem(at: IndexPath(item: viewModel.index, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage =  viewModel.index
        viewModel.index += 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case sizeCollectionView:
            if selectedSizeIndex == indexPath.row {
                selectedSizeIndex = nil
            } else {
                selectedSizeIndex = indexPath.row
            }
//            variantItemId = viewModel.productArray[indexPath.row].variants?[indexPath.row].inventoryItemID ?? 0
            variantIndex = indexPath.row
            setupVariantDetails(ProductIndex: index, variantIndex: (indexPath.row + 1))
            sizeCollectionView.reloadData()
            
        case colorCollectionView:
            if selectedColorIndex == indexPath.row {
                selectedColorIndex = nil
            } else {
                selectedColorIndex = indexPath.row
            }
            colorCollectionView.reloadData()
            
        default:
            break
        }
    }
    func updateCellAppearance(cell: UICollectionViewCell, isSelected: Bool) {
        if isSelected {
            cell.layer.borderWidth = 3.0
            cell.layer.borderColor = UIColor.systemBlue.cgColor
            cell.layer.cornerRadius = 10.0
        } else {
            cell.layer.borderWidth = 0.0
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.cornerRadius = 10.0
        }
    }
    
}
