//
//  ProductDetailsViewController.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 05/09/2024.
//

import UIKit
import Kingfisher

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel = ProductDetailsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        startAutoScroll()
    }
}
extension ProductDetailsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductDetailsCollectionViewCell
        let url = URL(string: viewModel.imagesArray[indexPath.row].src ?? "")
        cell.productImage.clipsToBounds = true
        cell.productImage.kf.setImage(with: url,placeholder: UIImage(named: "noimage"))
        cell.productImage.layer.cornerRadius = 50
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
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
        collectionView.scrollToItem(at: IndexPath(item: viewModel.index, section: 0), at: .centeredHorizontally, animated: true)
    }
 
}
