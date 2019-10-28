//
//  AddEditViewController.swift
//  Countdown
//
//  Created by Joseph Rogers on 10/20/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import UIKit

protocol AddCountdownDelegate: class {
    func countdownWasAdded(_ countdown: Countdown)
}

class AddEditViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var countdownPicker: UIPickerView!
    @IBOutlet weak var createButton: UIButton!
    
    weak var delegate: AddCountdownDelegate?
    
    private let countdown = Countdown(name: "", details: "")
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }() //why do we init this at the end?
    
    private var duration: TimeInterval {
        let hourString = countdownPicker.selectedRow(inComponent: 0)
        let minuteString = countdownPicker.selectedRow(inComponent: 2)
        let secondString = countdownPicker.selectedRow(inComponent: 4)
        
        let minutes = Int(minuteString)
        let seconds = Int(secondString)
        let hours = Int(hourString)
        
        let totalSeconds = TimeInterval((hours * minutes) * 60 + seconds)
        return totalSeconds
    }
    
    lazy private var countdownPickerData: [[String]] = {
        // Create string arrays using numbers wrapped in string values: ["0", "1", ... "60"]
        let hours: [String] = Array(0...24).map {String($0)}
        let minutes: [String] = Array(0...60).map { String($0) }
        let seconds: [String] = Array(0...59).map { String($0) }
        
        // "min" and "sec" are the unit labels
        let data: [[String]] = [hours, ["Hrs"], minutes, ["min"], seconds, ["sec"]]
        return data
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countdownPicker.dataSource = self
        countdownPicker.delegate = self
        
        countdownPicker.selectRow(0, inComponent: 0, animated: false)
        countdownPicker.selectRow(0, inComponent: 2, animated: false)
        countdownPicker.selectRow(30, inComponent: 4, animated: false)
        
        countdown.duration = duration
        countdown.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        countdown.start()
        guard let name = nameTextField.text,
            let details = detailsTextField.text,
            !name.isEmpty else {return}
        
        
        print(name, " " ,details)
        //FIXME: Add arguments for countdown item to have a name and details property.
        let countdown = Countdown(name: name, details: details)
        
//        print(countdown.name, countdown.details)
        
        
        
        delegate?.countdownWasAdded(countdown)
        
        
        //dismiss(animated: true, completion: nil)
    }
    
    
 
     
    // MARK: - Private
    //nil dismisses the view controller
    private func showAlert() {
        let alert = UIAlertController(title: "Timer Finished!", message: "Your countdown is over", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        detailsTextField.text = string(from: countdown.duration)
    }
    
    private func updateViews() {
        createButton.isEnabled = true
        switch countdown.state {
        case .started:
            detailsTextField.text = string(from: countdown.timeRemaining)
        case .finished:
            detailsTextField.text = string(from: 0)
        case .reset:
            detailsTextField.text = string(from: countdown.duration)
        }
    }
    
    private func timerFinished(_ timer: Timer) {
        showAlert()
    }
    
    private func string(from duration: TimeInterval) -> String {
        //        #warning("return a string value derived from the time interval passed in")
        let date = Date(timeIntervalSinceReferenceDate: duration)
        return dateFormatter.string(from: date)
    }
}

extension AddEditViewController: CountdownDelegate {
    func countdownDidUpdate(timeRemaining: TimeInterval) {
        updateViews()
    }
    
    func countdownDidFinish() {
        updateViews()
        showAlert()
    }
}

extension AddEditViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //        #warning("Change this to return the number of components for the picker view")
        return countdownPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //        #warning("Change this to return the number of rows per component in the picker view")
        return countdownPickerData[component].count
    }
}

extension AddEditViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let timeValue = countdownPickerData[component][row]
        return timeValue
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countdown.duration = duration
        updateViews()
    }
}

