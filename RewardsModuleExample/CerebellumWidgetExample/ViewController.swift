//
//  ViewController.swift
//  RewardsModuleExample
//
//  Created by C on 2/13/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import UIKit
import RewardsModule

class ViewController: UIViewController {
    var crbWidget = RewardsModule();
    
    @IBOutlet var logger: UITextView!;
    
    @IBAction func showRewardsButtonClicked(sender: Any) {
        let placements = crbWidget.getPlacements();
        
        crbWidget.show(placement: placements.count > 0 ? placements[0] : "default");
    }
    
    @IBAction func showLoginButtonClicked(sender: Any) {
        crbWidget.showOnboarding();
    }
    
    @IBAction func hideButtonClicked(sender: Any) {
        crbWidget.hide();
    }
    
    var resized = false;
    
    @IBAction func resize(sender: Any) {
        if (!resized) {
            crbWidget.resize(left: 50, top: 5, width: 50, height: 95);
        } else {
            crbWidget.resize(left: 5, top: 5, width: 90, height: 90);
        }
        
        resized = !resized;
    }
    
    @IBAction func logoutButtonClicked(sender: Any) {
        crbWidget.logout();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        crbWidget.parentController = self;
        crbWidget.initialize(applicationId: "239",
                             env: Environment.STAGE);
        
        _ = crbWidget.onHide{
            self.logger.text.append("Widget is closing!\n");
        }
        .onGetUserByEmail {email, callback in
            self.logger.text.append("Existence of user `\(email)` is requested\n");
            
            callback(Bool.random());
        }
        .onInitializationFinished {
            self.logger.text.append("Widget initialized.\n");
            
            let placements = self.crbWidget.getPlacements();
            
            placements.forEach{ placement in
                if (self.crbWidget.hasItems(forPlacement: placement)) {
                    self.logger.text.append("Widget has items to show in placement `\(placement)`.\n");
                    self.crbWidget.show(placement: placement);
                } else {
                    self.logger.text.append("Widget has no items in placement `\(placement)`.\n");
                }
            }
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator);
        
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            
            self.crbWidget.redraw();
        });
    }
}
