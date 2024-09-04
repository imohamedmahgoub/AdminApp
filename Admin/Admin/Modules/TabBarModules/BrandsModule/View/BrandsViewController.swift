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
    let indicator = UIActivityIndicatorView(style: .medium)
    let viewModel = BrandsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        
        setupFlowLayout()
        let nib = UINib(nibName: "BrandsCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        viewModel.getData {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.indicator.stopAnimating()
            }
        }
    }
    
}
extension BrandsViewController : UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.brandsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BrandsCollectionViewCell
        let url = URL(string: "\(viewModel.brandsArray[indexPath.row].image?.src ?? "")")
        cell.brandImage.kf.setImage(with: url,placeholder: UIImage(named: "noimage"))
        cell.brandName.text = viewModel.brandsArray[indexPath.row].title
        cell.layer.cornerRadius = 20
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductsViewController") as? ProductsViewController
        guard let vc = vc else { return  }
        vc.viewModel.vendor = viewModel.brandsArray[indexPath.row].title ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.width - 30) / 2
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        collectionView.collectionViewLayout = flowLayout
    }
}
