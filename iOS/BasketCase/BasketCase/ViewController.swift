//
//  ViewController.swift
//  BasketCase
//
//  Created by Kelvin Kao on 3/28/17.
//  Copyright © 2017 Kelvin Kao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var madeNumberLabel: UILabel!
    @IBOutlet weak var attemptedNumberLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDatePicker()
    }
    
    override func didReceiveMemoryWarning() {
        print("date is \(datePicker.date)")
    }
}

private extension ViewController {
    func configureDatePicker() {
        let oneDay: Double = 24*60*24
        datePicker.maximumDate = NSDate(timeIntervalSinceNow: oneDay)
        datePicker.minimumDate = NSDate(timeIntervalSinceNow: -30*oneDay)
    }
    
    func showAlertWithResult(result: FirebaseDudeResult) {
        var message = ""
        switch result {
        case .success:
            message = "Success!"
        case .failure(let error):
            message = "Failed: \(error)"
        }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Sweet", style: .Default, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}

// MARK: Button logic

extension ViewController {
    @IBAction func submitButtonTapped() {
        submitButton.enabled = false
        
        FirebaseDude.recordFieldGoal(made: madeNumber(),
                                     attempted: attemptedNumber(),
                                     date: datePicker.date) { (result) in
                                        dispatch_async(dispatch_get_main_queue()) {
                                            self.submitButton.enabled = true
                                            self.showAlertWithResult(result)
                                        }
        }
    }
    
    @IBAction func madeDecremented() {
        madeNumberLabel.text = decrementedText(madeNumberLabel.text)
    }
    
    @IBAction func madeIncremented() {
        madeNumberLabel.text = incrementedText(madeNumberLabel.text)
    }
    
    @IBAction func attemptedDecremented() {
        attemptedNumberLabel.text = decrementedText(attemptedNumberLabel.text)
    }
    
    @IBAction func attemptedIncremented() {
        attemptedNumberLabel.text = incrementedText(attemptedNumberLabel.text)
    }
    
    func madeNumber() -> Int {
        return numberFromText(madeNumberLabel.text)
    }
    
    func attemptedNumber() -> Int {
        return numberFromText(attemptedNumberLabel.text)
    }
    
    func numberFromText(text: String?) -> Int {
        guard let text = text,
            let num = Int(text) else {
                return 0 }
        return num
    }
    
    func decrementedText(original: String?) -> String {
        let originalNum = numberFromText(original)
        return "\(originalNum - 1)"
    }
    
    func incrementedText(original: String?) -> String {
        let originalNum = numberFromText(original)
        return "\(originalNum + 1)"
    }
}

