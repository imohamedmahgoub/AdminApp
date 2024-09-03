//
//  BrandsViewController.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 02/09/2024.
//

import UIKit
import Kingfisher

class BrandsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let viewModel = BrandsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        setupFlowLayout()
        let nib = UINib(nibName: "BrandsCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
    }
    
}
extension BrandsViewController : UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.brandsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BrandsCollectionViewCell
        cell.brandImage.image = UIImage(named: viewModel.brandsArray[indexPath.row].brandImage)
        cell.brandName.text = viewModel.brandsArray[indexPath.row].brandName
        cell.layer.cornerRadius = 20
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductsViewController") as? ProductsViewController
        guard let vc = vc else { return  }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.width - 30) / 2
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        collectionView.collectionViewLayout = flowLayout
    }
}
