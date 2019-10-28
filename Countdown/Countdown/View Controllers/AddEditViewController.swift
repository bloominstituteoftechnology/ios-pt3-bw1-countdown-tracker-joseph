//
//  AddEditViewController.swift
//  Countdown
//
//  Created by Joseph Rogers on 10/20/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import UIKit

protocol AddCountdownDelegate: class {
    func countdownWasAdded(_ countdown: CountdownCodableInfo)
}

class AddEditViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailsTextField: UILabel!
    @IBOutlet weak var countdownPicker: UIPickerView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var noteDetailView: UITextView!
    
    weak var delegate: AddCountdownDelegate?
    
    private let countdownInfo = CountdownCodableInfo(name: "", countdownExistingNotes: "")
    private let countdown = Countdown()
    var countdownInfoToUse: CountdownCodableInfo?
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    private var duration: TimeInterval {
        let minuteString = countdownPicker.selectedRow(inComponent: 0)
        let secondString = countdownPicker.selectedRow(inComponent: 2)
        
        let minutes = Int(minuteString)
        let seconds = Int(secondString)
        
        let totalSeconds = TimeInterval(minutes * 60 + seconds)
        return totalSeconds
    }
    
    lazy private var countdownPickerData: [[String]] = {
        let minutes: [String] = Array(0...60).map { String($0) }
        let seconds: [String] = Array(0...59).map { String($0) }
        let data: [[String]] = [minutes, ["min"], seconds, ["sec"]]
        return data
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countdownPicker.dataSource = self
        countdownPicker.delegate = self
        countdownPicker.selectRow(0, inComponent: 0, animated: false)
        countdownPicker.selectRow(30, inComponent: 2, animated: false)
        countdown.duration = duration
        countdown.delegate = self
        setupViews()
    }
    
    func setupViews() {
        if let countdownInfoToUse = countdownInfoToUse {
            nameTextField.text = countdownInfoToUse.name
                nameTextField.isHidden = true
            detailsTextField.text = "Edit your note here!"
            noteDetailView.text = countdownInfoToUse.countdownExistingNotes
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        countdown.start()
        createButton.isHidden = true
        countdownPicker.isHidden = true
    }
    
    // MARK: - Private
    //nil dismisses the view controller
    private func showAlert() {
        let alert = UIAlertController(title: "Timer Finished!", message: "Your countdown is over", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        detailsTextField.text = "reset the counter to go again!"
        
        guard let name = nameTextField.text, let str = noteDetailView.text  else {return}
        let countdown = CountdownCodableInfo(name: name, countdownExistingNotes: str)
        delegate?.countdownWasAdded(countdown)
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
        self.dismiss(animated: true, completion: nil)
        createButton.isHidden = false
        countdownPicker.isHidden = false
    }
    
    private func string(from duration: TimeInterval) -> String {
        //        #warning("return a string value derived from the time interval passed in")
        let date = Date(timeIntervalSinceReferenceDate: duration)
        return dateFormatter.string(from: date)
    }
}
    //MARK: Extensions

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
        return countdownPickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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

