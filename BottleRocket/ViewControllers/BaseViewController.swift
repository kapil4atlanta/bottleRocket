//
//  BaseViewController.swift
//  BottleRocket
//
//  Created by Kapil Rathan on 3/11/22.
//

import UIKit

class BaseViewController: UIViewController {

    override func loadView() {
        super.loadView()
        setupNavbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func setupNavbar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(red: 67.0/255, green: 232.0/255, blue: 149.0/255, alpha: 1.0)
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}
