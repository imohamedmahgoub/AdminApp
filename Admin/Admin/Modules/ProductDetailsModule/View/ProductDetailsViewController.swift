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
    var viewModel = ProductDetailsViewModel()
    var index = 0
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
    }
    func setupCollectionViews() {
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        imagesCollectionView.reloadData()
        
        sizeCollectionView.dataSource = self
        sizeCollectionView.delegate = self
        sizeCollectionView.reloadData()
        
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.reloadData()
        
        startAutoScroll()
        addVariantOutlet.layer.cornerRadius = 10.0
        saveOutlet.layer.cornerRadius = 5.0
        addVariantView.isHidden = true
        addVariantView.layer.cornerRadius = 10.0
        closeAddVariantViewOutlet.layer.cornerRadius = 10.0
    }
    
    @IBAction func didSelectAddVariant(_ sender: Any) {
        addVariantView.isHidden = false
    }
    
    @IBAction func didSelectSave(_ sender: Any) {
        addVariantView.isHidden = true
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
            return viewModel.sizeArray.count
        case colorCollectionView:
            return viewModel.colorArray.count
        default:
            return viewModel.imagesArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case sizeCollectionView :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SizeCollectionViewCell
            cell.layer.cornerRadius = 10.0
            cell.productSize.text = viewModel.sizeArray[indexPath.row]
            cell.productSize.layer.cornerRadius = 5.0
            if indexPath.row == selectedSizeIndex {
                cell.layer.borderWidth = 3.0
                cell.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                cell.productSize.layer.borderWidth = 0.0
                cell.productSize.layer.borderColor = UIColor.clear.cgColor
            }
            return cell
        case colorCollectionView :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ColorCollectionViewCell
            cell.layer.cornerRadius = 10.0
            cell.productColor.text = viewModel.colorArray[indexPath.row]
            cell.productColor.layer.cornerRadius = 5.0
            if indexPath.row == selectedColorIndex {
                cell.layer.borderWidth = 3.0
                cell.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                cell.productColor.layer.borderWidth = 0.0
                cell.productColor.layer.borderColor = UIColor.clear.cgColor
            }
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
            return CGSize(width: 30, height: 60)
        case colorCollectionView :
            return CGSize(width: 50, height: 60)
        default:
            return CGSize(width: imagesCollectionView.frame.width, height: imagesCollectionView.frame.height)
        }
    }
    
    func startAutoScroll() {
        viewModel.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoScrollCollectionView), userInfo: nil, repeats: true)
    }
    
    @objc func autoScrollCollectionView() {
        if viewModel.index < viewModel.imagesArray.count - 1{
            viewModel.index += 1
        }else{
            viewModel.index = 0
        }
        pageControl.numberOfPages = viewModel.imagesArray.count
        pageControl.currentPage =  viewModel.index
        imagesCollectionView.scrollToItem(at: IndexPath(item: viewModel.index, section: 0), at: .centeredHorizontally, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case sizeCollectionView :
            sizeCollectionView.deselectItem(at: indexPath, animated: true)
            selectedSizeIndex = indexPath.row
            sizeCollectionView.reloadData()
            return
        case colorCollectionView:
            colorCollectionView.deselectItem(at: indexPath, animated: true)
            selectedColorIndex = indexPath.row
            colorCollectionView.reloadData()
        default:
            break
        }
    }
    
}

