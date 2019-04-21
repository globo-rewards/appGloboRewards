//
//  ViewController.swift
//  GloboRewards
//
//  Created by Carlos Doki on 20/04/19.
//  Copyright © 2019 Carlos Doki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var saldoLbl: UILabel!
    
    var saldonovo = 20
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        saldoLbl.text = "E$ \(saldonovo)"
    }

    @IBAction func capturarBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "Captura", sender: nil)
    }
    
}

