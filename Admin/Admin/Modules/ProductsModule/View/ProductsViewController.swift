//
//  ProductsViewController.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 02/09/2024.
//

import UIKit

class ProductsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyImage: UIImageView!
    let viewModel = ProductsViewModel()
    let indicator = UIActivityIndicatorView(style: .medium)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        
        let nib = UINib(nibName: "ProductsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Available Products"
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addProduct))
        self.navigationItem.rightBarButtonItem = addButton
        viewModel.getData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                if self.viewModel.productArray.count == 0 {
                    self.tableView.isHidden = true
                }
            }
        }
    }
    @objc
    func addProduct() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as? AddProductViewController
        guard let vc = vc else { return }
        vc.viewModel.vendor = viewModel.vendor
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ProductsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductsTableViewCell
        let url = URL(string: "\(viewModel.productArray[indexPath.row].images?.first?.src ?? "")")
        cell.productImage.kf.setImage(with: url,placeholder: UIImage(named: "noimage"))
        cell.productVersionLabel.text = viewModel.productArray[indexPath.row].title
        cell.productCompany.text = "\(viewModel.productArray[indexPath.row].vendor ?? ""), \(viewModel.productArray[indexPath.row].productType ?? "")"
        cell.productPrice.text = "\(viewModel.productArray[indexPath.row].variants?.first?.price ?? "") EGP"
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
        
        vc.viewModel.sizeArray = self.viewModel.productArray[indexPath.row].options?.filter({ $0.name == .size }) ?? []
        vc.viewModel.colorArray = self.viewModel.productArray[indexPath.row].options?.filter({ $0.name == .color }) ?? []
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
