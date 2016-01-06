//
//  FoodCreationViewController.swift
//  APIConsumerSwift
//
//  Created by Andrew Dolce on 1/5/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import UIKit

class FoodCreationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var healthySwitch: UISwitch!

    @IBAction func addFoodButtonPressed(sender: UIButton) {
        if let name = nameTextField.text {
            if name.characters.count > 0 {
                let isHealthy = healthySwitch.on
                FoodService.sharedService.createFoodWithName(name, isHealthy: isHealthy) { response in
                    switch response {
                    case .Success:
                        // Could do something here with the newly created food if we wanted.
                        break
                    case .Failure(let error):
                        print("Failed to create new food: \(error)")
                    }

                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
}
