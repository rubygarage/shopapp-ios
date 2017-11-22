//
//  CardValidationViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import MFCard

class CardValidationViewController: BaseViewController<CardValidationViewModel>, MFCardDelegate {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var creditCard: MFCardView!
    
    override func viewDidLoad() {
        viewModel = CardValidationViewModel()
        super.viewDidLoad()

        setupViews()
        
        creditCard.delegate = self
    }
    
    private func setupViews() {
        cancelButton.setTitle(NSLocalizedString("Button.Cancel", comment: String()), for: .normal)
    }
    
    // MARK: - actions
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    // MARK: - MFCardDelegate
    func cardDoneButtonClicked(_ card: Card?, error: String?) {
        if error == nil{
            print(card!)
        }else{
            print(error!)
        }
    }
    
    func cardTypeDidIdentify(_ cardType: String) {
        print()
    }
}
