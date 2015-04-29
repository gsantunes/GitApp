//
//  ViewController.swift
//  GitApp
//
//  Created by Fernando on 4/28/15.
//  Copyright (c) 2015 Fernando. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
        let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self

        
        if defaults.stringForKey("nome") != nil {
           textField.text = defaults.stringForKey("nome")
        }
      
    }

    @IBAction func btnEntrar(sender: AnyObject) {

        var nickName = textField.text
 
        defaults.setObject(nickName, forKey: "nome")
        
    //self.navigationController!.pushViewController(TableView(), animated: true)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        textField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}

