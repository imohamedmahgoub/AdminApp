//
//  DiscountCodesViewController.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 11/09/2024.
//

import UIKit

class DiscountCodesViewController: UIViewController{
    var viewModel = DiscountCodesViewModel()
    let indicator = UIActivityIndicatorView(style: .medium)
    @IBOutlet weak var addDiscountView: UIView!
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var saveOutlet: UIButton!
    @IBOutlet weak var cancelOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        setuoAddDiscountView()
    }
    func setuoAddDiscountView() {
        addDiscountView.isHidden = true
        addDiscountView.layer.cornerRadius = 10.0
        addDiscountView.layer.borderWidth = 1.0
        addDiscountView.layer.borderColor = UIColor.red.cgColor
        
        saveOutlet.layer.cornerRadius = 10.0
        saveOutlet.layer.borderColor = UIColor.red.cgColor
        saveOutlet.layer.borderWidth = 0.5
        
        cancelOutlet.layer.cornerRadius = 10.0
        cancelOutlet.layer.borderColor = UIColor.red.cgColor
        cancelOutlet.layer.borderWidth = 0.5
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Discount Codes"
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addDiscount))
        self.navigationItem.rightBarButtonItem = addButton
        viewModel.getDicountCodes {
            self.tableView.reloadData()
            self.indicator.stopAnimating()
            if self.viewModel.discountCodesArray.count == 0 {
                self.tableView.isHidden = true
            }
        }
    }
    
    @objc
    func addDiscount() {
        addDiscountView.isHidden = false
    }
    
    @IBAction func didSelectClose(_ sender: Any) {
        TitleTextField.text = ""
        addDiscountView.isHidden = true
    }
    
    @IBAction func didSelectSave(_ sender: Any) {
        viewModel.parameters = [
            "discount_code" : [
                "price_rule_id" : viewModel.id ,
                "code" : TitleTextField.text ?? "mm"
            ]
        ]
        viewModel.createAdiscountCode {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.addDiscountView.isHidden = true
            }
        }
    }
}
extension DiscountCodesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.discountCodesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DiscountCodesTableViewCell
        let code = viewModel.discountCodesArray[indexPath.row]
        cell.codeTitle.text = code.code
        cell.usageNumber.text = "\(code.usageCount ?? 5)"
        setupCell(cell: cell)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            self.viewModel.deleteDiscountCode()
            self.viewModel.discountCodesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    func setupCell (cell : UITableViewCell) {
        cell.layer.cornerRadius = 20.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
    }
}
