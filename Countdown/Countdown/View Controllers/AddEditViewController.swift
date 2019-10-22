//
//  AddEditViewController.swift
//  Countdown
//
//  Created by Joseph Rogers on 10/20/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import UIKit

protocol AddCountdownDelegate {
    func countdownWasAdded(_ countdown: Countdown)
}

class AddEditViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: AddCountdownDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        guard let name = nameTextField.text,
            let details = detailsTextField.text,
            !name.isEmpty, !details.isEmpty else {return}
        //FIXME: Add arguments for countdown item to have a name and details property.
//        var countdown = Countdown()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
