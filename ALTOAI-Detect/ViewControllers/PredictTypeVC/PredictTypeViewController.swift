//
//  PredictTypeViewController.swift
//  ALTOAI-Detect
//
//  Created by krish on 7/18/22.
//

import UIKit

public

class PredictTypeViewController: UIViewController {

    @IBOutlet weak var textfield: UITextField!
    var yolo = YOLO()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        //had issue where keyboard wasn't disappearing for the textfield input
        //gesture recognizer to hide the keyboard when screen is tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //screen tap to hide keyboard.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //uses regular model for bounding box predictions
    @IBAction func didTapNormal(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CameraVCID") as! CameraVC
        vc.yolo = yolo
        //pass in null for the address and set hasApiInput to false
        vc.apiInput = "null"
        vc.hasApiInput = false
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //uses the AltoAI Docker API access for bounding box predictions
    @IBAction func didTapAPI(_ sender: Any) {
        if(textfield.hasText) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CameraVCID") as! CameraVC
            vc.yolo = yolo
            //pass in the IP address and set hasApiInput to true
            vc.apiInput = textfield.text!
            vc.hasApiInput = true
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //back button (change viewcontroller to be part of navigation controller in the future)
    @IBAction func didTapBack(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
}
