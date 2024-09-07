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
    let indicator = UIActivityIndicatorView(style: .medium)
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        
        let nib = UINib(nibName: "ProductsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        viewModel.getData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
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
        let url = URL(string: "\(viewModel.productArray[indexPath.row].images?.first?.src ?? "")")
        cell.productImage.kf.setImage(with: url,placeholder: UIImage(named: "noimage"))
        cell.productVersionLabel.text = viewModel.productArray[indexPath.row].title
        cell.productCompany.text = viewModel.productArray[indexPath.row].vendor
        cell.productPrice.text = viewModel.productArray[indexPath.row].variants?.first?.price
        cell.productQuantity.text = "\(viewModel.productArray[indexPath.row].variants?.first?.inventoryQuantity ?? 10) in Stock"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as? ProductDetailsViewController
        guard let vc else { return }
        vc.viewModel.productArray = self.viewModel.productArray
        vc.viewModel.imagesArray = self.viewModel.productArray[indexPath.row].images ?? []
        vc.index = indexPath.row
        if let size = self.viewModel.productArray[indexPath.row].options?.first(where: { $0.name == .size }) {
            vc.viewModel.sizeArray = size.values ?? ["NO"]
        }
        if let color = self.viewModel.productArray[indexPath.row].options?.first(where: { $0.name == .color }) {
            vc.viewModel.colorArray = color.values ?? ["NO"]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let product = viewModel.productArray[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            
            self.viewModel.deleteProduct(productId: product.id ?? 0 )
            self.viewModel.productArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
