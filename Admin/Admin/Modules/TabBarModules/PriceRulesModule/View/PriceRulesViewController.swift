//
//  PriceRulesViewController.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 10/09/2024.
//

import UIKit

class PriceRulesViewController: UIViewController {
    var viewModel = PriceRulesViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addDiscountView: UIView!
    @IBOutlet weak var discountTitleTextField: UITextField!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var discountAmountTextFiled: UITextField!
    @IBOutlet weak var miniSubtotalTextField: UITextField!
    @IBOutlet weak var usageLimitsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupAddDiscountView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getDiscout(completion: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    func setupAddDiscountView() {
        addDiscountView.isHidden = true
        addDiscountView.layer.cornerRadius = 10.0
        addDiscountView.layer.borderWidth = 3.0
        addDiscountView.layer.borderColor = UIColor.red.cgColor
        fromDatePicker.minimumDate = Date()
        toDatePicker.minimumDate = Date()
    }
    
    @IBAction func didSelectAddDiscount(_ sender: Any) {
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
        let prerequisiteQuantity = Int(miniSubtotalTextField.text ?? "0") ?? 0
        let allocationLimit = Int(usageLimitsTextField.text ?? "0") ?? 0
        
        viewModel.parameters = [
            "title": title,
            "value_type": typeSegmentedControl.selectedSegmentIndex == 0 ? "percentage" : "fixed_amount",
            "value": value,
            "customer_selection": "all",
            "target_type": "line_item",
            "target_selection": "entitled",
            "allocation_method": "each",
            "starts_at": startsAt,
            "ends_at": endsAt,
            "prerequisite_collection_ids": [841564295],
            "entitled_product_ids": [921728736],
            "prerequisite_to_entitlement_quantity_ratio": [
                "prerequisite_quantity": prerequisiteQuantity,
                "entitled_quantity": 1
            ],
            "allocation_limit": allocationLimit
        ]
        
        viewModel.addDiscout {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
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
        cell.endDate.text = transformDateWithAddedHours(priceRule.startsAt ?? "", hoursToAdd: 24)
        /*transformDateWithAddedHours((priceRule.endsAt ?? transformDateWithAddedHours(priceRule.startsAt ?? "" , hoursToAdd: 24)) ?? "", hoursToAdd: 0)*/
        cell.MoneyRequired.text = "\(priceRule.value ?? "200")$ After \(priceRule.prerequisiteToEntitlementQuantityRatio?.prerequisiteQuantity ?? "800")"
        cell.maxUsers.text = priceRule.usageLimit ?? "10" + " Max usages"
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
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.systemBlue.cgColor
        cell.layer.cornerRadius = 10.0
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
