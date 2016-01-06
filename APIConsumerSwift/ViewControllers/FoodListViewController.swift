//
//  FoodListViewController.swift
//  APIConsumerSwift
//
//  Created by Andrew Dolce on 1/5/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import UIKit

class FoodListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var foods = [Food]()

    private let foodCellReuseIdentifier = "foodCellReuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupTableView()

        addTestFoods()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // TODO: Fetch the latest foods and update the table
    }

    private func setupNavigation() {
        title = "Food List"
        let addFoodButton = UIBarButtonItem(title: "+", style: .Plain, target: self, action: "addFoodButtonPressed:")
        navigationItem.rightBarButtonItem = addFoodButton
    }

    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func addTestFoods() {
        foods.append(Food(identifier: "foobar1", name: "Hot Dog", isHealthy: false))
        foods.append(Food(identifier: "foobar2", name: "Hamburger", isHealthy: false))
        foods.append(Food(identifier: "foobar3", name: "Salad", isHealthy: true))
        foods.append(Food(identifier: "foobar4", name: "Grapes", isHealthy: true))
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let food = foods[indexPath.row]

        let cell = tableView.dequeueReusableCellWithIdentifier(foodCellReuseIdentifier) ?? UITableViewCell(style: .Default, reuseIdentifier: foodCellReuseIdentifier)
        cell.textLabel?.text = food.name
        cell.textLabel?.textColor = food.isHealthy ? UIColor.greenColor() : UIColor.redColor()

        return cell
    }

    // MARK: - UITableViewDelegate

    // MARK: - Actions

    func addFoodButtonPressed(sender: UIBarButtonItem) {
        let foodCreationViewController = FoodCreationViewController(nibName: "FoodCreationViewController", bundle: nil)
        navigationController?.pushViewController(foodCreationViewController, animated: true)
    }
}
