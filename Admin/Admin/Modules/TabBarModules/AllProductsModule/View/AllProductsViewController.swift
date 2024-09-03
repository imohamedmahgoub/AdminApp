//
//  AllProductsViewController.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 03/09/2024.
//

import UIKit
import Kingfisher

class AllProductsViewController: UIViewController {
    let viewModel = AllProductsViewModel()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "ProductsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        viewModel.getData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    

}
extension AllProductsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductsTableViewCell
        let url = URL(string: "\(viewModel.productArray[indexPath.row].images.first?.src ?? "")")
        cell.productImage.kf.setImage(with: url,placeholder: UIImage(named: "1"))
        cell.productVersionLabel.text = viewModel.productArray[indexPath.row].title
        cell.productCompany.text = viewModel.productArray[indexPath.row].vendor
        cell.productPrice.text = viewModel.productArray[indexPath.row].variants.first?.price
        cell.productQuantity.text = "\(viewModel.productArray[indexPath.row].variants.first?.inventoryQuantity ?? 10) in Stock"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
