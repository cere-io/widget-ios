//
//  ViewController.swift
//  CerebellumWidgetExample
//
//  Created by C on 2/13/19.
//  Copyright © 2019 Funler. All rights reserved.
//

import UIKit
import CerebellumWidget

class ViewController: UIViewController {
    var crbWidget = CerebellumWidget();

    @IBAction func showButtonClicked(sender: Any) {
        crbWidget.setMode(mode: WidgetMode.REWARDS);
        crbWidget.show();
    }

    @IBAction func logoutButtonClicked(sender: Any) {
        crbWidget.logout();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        crbWidget.initAndLoad(parentController: self,
                              applicationId: "239",
                              sections: ["top_section_1", "top_section_2", "top_section_3"],
                              env: Environment.STAGE);
        crbWidget.show();
    }
}
