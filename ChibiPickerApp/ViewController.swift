//
//  ViewController.swift
//  ChibiPickerApp
//
//  Created by Guilherme Rambo on 03/06/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var chibiContainer: UIView!

    @IBAction func pickChibi(_ sender: UIButton) {
        ChibiPicker.shared.pickChibi { [weak self] image in
            self?.chibiContainer.layer.contents = image?.cgImage
        }
    }

}

