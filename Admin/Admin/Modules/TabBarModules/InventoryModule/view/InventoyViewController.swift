//
//  InventoyViewController.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 08/09/2024.
//

import UIKit

class InventoyViewController: UIViewController {
    var viewModel = InventoryViewModel()
    let indicator = UIActivityIndicatorView(style: .medium)
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        
        let nib = UINib(nibName: "InventoyTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Branshes"
        self.tabBarController?.navigationItem.rightBarButtonItem?.isHidden = true
        
        viewModel.getLocationData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                if self.viewModel.locationsArray.count == 0 {
                    self.tableView.isHidden = true
                }
            }
        }
        
    }
    
}
extension InventoyViewController : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InventoyTableViewCell
        let location = viewModel.locationsArray[indexPath.row]
        cell.shopName.text = location.name
        cell.shopCountry.text = location.countryName
        cell.shopImage.image = UIImage(named: "1")
        setupCell(cell: cell)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AllProductsViewController") as? AllProductsViewController
        guard let vc else { return  }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupCell (cell : UITableViewCell) {
        cell.layer.cornerRadius = 20.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
    }
     
    
}
