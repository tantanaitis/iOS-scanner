//
//  PersonIdentityInfoController.swift
//  eDoc
//
//  Created by Titas Antanaitis on 26/09/2017.
//  Copyright © 2017 T.Antanaitis. All rights reserved.
//

import UIKit

class PersonIdentityInfoController: UIViewController {
    
    @IBOutlet var name: UITextField!
    @IBOutlet var surname: UITextField!
    @IBOutlet var civilRegistrationCode: UITextField!
    @IBOutlet var sex: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = "Vardenis"
        surname.text = "Pavardenis"
        civilRegistrationCode.text = "39306121233"
        sex.text = "Vyras"
    }

}
