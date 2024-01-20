//
//  ViewController.swift
//  On_off_iOS
//
//  Created by 신예진 on 1/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let tabBarController = CustomTabBarController()
        tabBarController.modalPresentationStyle = .fullScreen

        present(tabBarController, animated: true)
    }
}
