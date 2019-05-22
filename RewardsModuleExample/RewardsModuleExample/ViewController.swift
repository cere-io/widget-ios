//
//  ViewController.swift
//  RewardsModuleExample
//
//  Created by C on 2/13/19.
//  Copyright © 2019 Cerebellum Network, Inc. All rights reserved.
//

import UIKit
import RewardsModule

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var rewardsModule: RewardsModule!;
    var placements:[String] = [];
    
    @IBOutlet var logger: UITextView!;
    
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var applicationIDField: UITextField!
    @IBOutlet weak var placementPicker: UIPickerView!
    @IBOutlet weak var environmentControl: UISegmentedControl!
    
    @IBAction func environmentChanged(_ sender: Any) {
        applicationIDField.resignFirstResponder();
        initRewardsModule();
    }
    
    @IBAction func userIDChanged(_ sender: Any)  {
        if (userID.text != nil) {
            rewardsModule.setUsername(userID.text!);
        }
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
            rewardsModule.resize(left: 0, top: 0, width: 100, height: 100);
        }
        
        resized = !resized;
    }
    
    @IBAction func logoutButtonClicked(sender: Any) {
        rewardsModule.logout();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.placementPicker.delegate = self;
        self.placementPicker.dataSource = self;
        
        self.environmentControl.addTarget(self, action: #selector(self.environmentChanged(_:)), for: .valueChanged);
        
        initRewardsModule();
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator);
        
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            
            self.rewardsModule.redraw();
        });
    }

    @IBAction func reInitWidget(_ sender: Any) {
        initRewardsModule();
    }
    
    @IBAction func appIDChanged(_ sender: Any) {
        initRewardsModule();
    }
    
    func initRewardsModule() {
        self.placementPicker.isHidden = true;
        let appID = self.applicationIDField.text ?? "0";
        let envID = self.environmentControl.selectedSegmentIndex == 0 ? Environment.STAGE :
            Environment.PRODUCTION;
        
        if (appID == "0" || appID == "") {
            self.logger.text.append("Specify Application ID.\n");
            
            return;
        }
        self.logger.text.append("Loading widget for appID=\(appID) and env=\(envID.name)!\n");
        rewardsModule = RewardsModule();
        rewardsModule.parentController = self;
        rewardsModule.initialize(applicationId: appID, env: envID);
        
        _ = rewardsModule.onHide{
            self.logger.text.append("Widget is closing!\n");
            self.prepareAndShowPicker();
            }
            .onGetUserByEmail {email, callback in
                let userExists = Bool.random();
                self.logger.text.append("Existence of user `\(email)` is requested\n. Responding with `\(userExists)`");
                
                callback(userExists);
            }
            .onInitializationFinished {
                self.logger.text.append("Widget initialized.\n");
                
                self.placements = self.rewardsModule.getPlacements();
                
                self.placements.forEach{ placement in
                    if (self.rewardsModule.hasItems(forPlacement: placement)) {
                        self.logger.text.append("Widget has items to show in placement `\(placement)`.\n");
                    } else {
                        self.logger.text.append("Widget has no items in placement `\(placement)`.\n");
                    }
                }
                
                self.prepareAndShowPicker();
                self.userIDChanged(self);
            }
            .onGetClaimedRewards { callback in
                callback([ClaimedRewardItem(
                    title: "Some title",
                    imageUrl: "http://example.img/",
                    price: 1.0,
                    currency: "TKN",
                    redemptionInstructions: "None",
                    additionalInfo: [])]);
        }

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.placements.count;
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.placements[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (row > 0) {
            self.rewardsModule.show(placement: self.placements[row]);
            self.placementPicker.isHidden = true;
        }
    }
    
    func prepareAndShowPicker() {
        self.placements = rewardsModule.getPlacements();
        self.placements.insert("Select Placement:", at: 0);

        self.placementPicker.reloadAllComponents();
        self.placementPicker.selectedRow(inComponent: 0);
        self.placementPicker.isHidden = false;
    }
}
