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
    
    @IBOutlet var logger: UILabel?;
    
    @IBAction func showRewardsButtonClicked(sender: Any) {
        crbWidget.setMode(mode: WidgetMode.REWARDS);
        crbWidget.show();
    }
    
    @IBAction func showLoginButtonClicked(sender: Any) {
        crbWidget.setMode(mode: WidgetMode.LOGIN);
        crbWidget.show();
    }
    
    @IBAction func hideButtonClicked(sender: Any) {
        crbWidget.hide();
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
        
        _ = crbWidget.onHide{
            self.logger?.text?.append("Widget is closing!\n");
        }
        
        _ = crbWidget.onGetUserByEmail {email, callback in
            self.logger?.text?.append("Existence of user `\(email)` is requested\n");
            
            callback(Bool.random());
        }
    }
}
