//
//  PriceRulesViewController.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 10/09/2024.
//

import UIKit

class PriceRulesViewController: UIViewController {
    var viewModel = PriceRulesViewModel()
    let indicator = UIActivityIndicatorView(style: .medium)
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addDiscountView: UIView!
    @IBOutlet weak var discountTitleTextField: UITextField!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var discountAmountTextFiled: UITextField!
    @IBOutlet weak var miniSubtotalTextField: UITextField!
    @IBOutlet weak var usageLimitsTextField: UITextField!
    @IBOutlet weak var cancelOutlet: UIButton!
    @IBOutlet weak var saveOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        setupAddDiscountView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Price Rules"
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addDiscount))
        self.tabBarController?.navigationItem.rightBarButtonItem = addButton
        self.tabBarController?.navigationItem.rightBarButtonItem?.isHidden = false

        viewModel.getDiscout(completion: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                if self.viewModel.priceRulesArray.count == 0 {
                    self.tableView.isHidden = true
                }
            }
        })
    }
    func setupAddDiscountView() {
        addDiscountView.isHidden = true
        addDiscountView.layer.cornerRadius = 10.0
        addDiscountView.layer.borderWidth = 1.5
        addDiscountView.layer.borderColor = UIColor.mintGreen.cgColor
        cancelOutlet.layer.cornerRadius = 10.0
        cancelOutlet.layer.borderWidth = 1.0
        cancelOutlet.layer.borderColor = UIColor.red.cgColor
        saveOutlet.layer.cornerRadius = 10.0
        saveOutlet.layer.borderWidth = 1.0
        saveOutlet.layer.borderColor = UIColor.mintGreen.cgColor
        fromDatePicker.minimumDate = Date()
        toDatePicker.minimumDate = Date()
    }
    
    @IBAction func didSelectAddDiscount(_ sender: Any) {
        addDiscountView.isHidden = false
    }
    @objc
    func addDiscount() {
        addDiscountView.isHidden = false
    }
    
    @IBAction func didSelectClose(_ sender: Any) {
        discountTitleTextField.text = ""
        discountAmountTextFiled.text = ""
        miniSubtotalTextField.text = ""
        usageLimitsTextField.text = ""
        addDiscountView.isHidden = true
    }
    
    @IBAction func didSelectSave(_ sender: Any) {
        let dateFormatter = ISO8601DateFormatter()
        let startsAt = dateFormatter.string(from: fromDatePicker.date)
        let endsAt = dateFormatter.string(from: toDatePicker.date)
        
        let title = discountTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let value = discountAmountTextFiled.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"
        let prerequisiteQuantity = miniSubtotalTextField.text ?? "0"
        let allocationLimit = Int(usageLimitsTextField.text ?? "0") ?? 0
        
        viewModel.parameters = [
            "price_rule": [
                "title": title,
                "target_type": "line_item",
                "target_selection": "all",
                "allocation_method": "across",
                "value_type": typeSegmentedControl.selectedSegmentIndex == 0 ? "percentage":"fixed_amount",
                "value": value,
                "customer_selection": "all",
                "starts_at": startsAt,
                "ends_at" : endsAt,
                "usage_limit" : allocationLimit,
                "prerequisite_subtotal_range" : [
                    "greater_than_or_equal_to" : prerequisiteQuantity
                ]
            ]
        ]
        
        viewModel.addDiscout {
            DispatchQueue.main.async {
                self.addDiscountView.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
}
extension PriceRulesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.priceRulesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PriceRulesTableViewCell
        let priceRule = viewModel.priceRulesArray[indexPath.row]
        cell.pricePertentage.text = priceRule.title
        cell.startDate.text = transformDateWithAddedHours(priceRule.startsAt ?? "", hoursToAdd: 0)
        if priceRule.endsAt == nil {
            cell.endDate.text = transformDateWithAddedHours(priceRule.startsAt ?? "", hoursToAdd: 24)
        }else{
            cell.endDate.text = transformDateWithAddedHours(priceRule.endsAt ?? "", hoursToAdd: 0)
        }
        cell.MoneyRequired.text = "\(priceRule.value ?? "200")$ After \(priceRule.prerequisiteToEntitlementQuantityRatio?.prerequisiteQuantity ?? "\(priceRule.prerequisiteSubtotalRange?.greaterThanOrEqualTo ?? "700")")"
        cell.maxUsers.text = "\(priceRule.usageLimit ?? 10)" + " Max Usage"
        updateCellAppearance(cell: cell)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let discount = viewModel.priceRulesArray[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            self.viewModel.deleteDiscount(discountId: discount.id ?? 0)
            self.viewModel.priceRulesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    func updateCellAppearance(cell: UITableViewCell) {
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.mintGreen.cgColor
        cell.layer.cornerRadius = 40.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DiscountCodesViewController") as? DiscountCodesViewController
        guard let vc else {return}
        vc.viewModel.id = viewModel.priceRulesArray[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension PriceRulesViewController {
    func transformDateWithAddedHours(_ dateString: String, hoursToAdd: Int) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        let calendar = Calendar.current
        guard let newDate = calendar.date(byAdding: .hour, value: hoursToAdd, to: date) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        let outputString = outputFormatter.string(from: newDate)
        return outputString
    }
    
}
