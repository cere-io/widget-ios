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
    var rewardsModule = RewardsModule();
    
    @IBOutlet var logger: UITextView!;
    
    @IBAction func showRewardsButtonClicked(sender: Any) {
        let placements = rewardsModule.getPlacements();
        
        rewardsModule.show(placement: placements.count > 0 ? placements[0] : "default");
    }
    
    @IBAction func showLoginButtonClicked(sender: Any) {
        rewardsModule.showOnboarding();
    }
    
    @IBAction func hideButtonClicked(sender: Any) {
        rewardsModule.hide();
    }
    
    var resized = false;
    
    @IBAction func resize(sender: Any) {
        if (!resized) {
            rewardsModule.resize(left: 50, top: 5, width: 50, height: 95);
        } else {
            rewardsModule.resize(left: 5, top: 5, width: 90, height: 90);
        }
        
        resized = !resized;
    }
    
    @IBAction func logoutButtonClicked(sender: Any) {
        rewardsModule.logout();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        rewardsModule.parentController = self;
        rewardsModule.initialize(applicationId: "239",
                             env: Environment.STAGE);
        
        _ = rewardsModule.onHide{
            self.logger.text.append("Widget is closing!\n");
        }
        .onGetUserByEmail {email, callback in
            self.logger.text.append("Existence of user `\(email)` is requested\n");
            
            callback(Bool.random());
        }
        .onInitializationFinished {
            self.logger.text.append("Widget initialized.\n");
            
            let placements = self.rewardsModule.getPlacements();
            
            placements.forEach{ placement in
                if (self.rewardsModule.hasItems(forPlacement: placement)) {
                    self.logger.text.append("Widget has items to show in placement `\(placement)`.\n");
                    self.rewardsModule.show(placement: placement);
                } else {
                    self.logger.text.append("Widget has no items in placement `\(placement)`.\n");
                }
            }
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator);
        
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            
            self.rewardsModule.redraw();
        });
    }
}
