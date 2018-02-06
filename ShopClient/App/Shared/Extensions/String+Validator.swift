//
//  String+Validator.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

private let kPasswordCharactersCountMin = 6
private let kCardNumberBlockCount = 4

extension String {
    func isValidAsEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidAsHolderName() -> Bool {
        return components(separatedBy: " ").count > 1
    }
    
    func isValidAsPassword() -> Bool {
        return count >= kPasswordCharactersCountMin
    }
    
    func isValidAsCardNumber() -> Bool {
        return count >= CreditCardLimit.cardNumberMinCount && count <= CreditCardLimit.cardNumberMaxCount
    }
    
    func isValidAsCVV() -> Bool {
        return count == CreditCardLimit.cvvMaxCount
    }
    
    func luhnValid() -> Bool {
        var sum = 0
        let reversedCharacters = self.reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else { return false }
            switch ((idx % 2 == 1), digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }
    
    func orNil() -> String? {
        return isEmpty ? nil : self
    }
    
    func hasAtLeastOneSymbol() -> Bool {
        return !isEmpty
    }
    
    func asCardMaskNumber() -> String {
        return grouping(every: kCardNumberBlockCount, with: " ")
    }
    
    func asCardDefaultNumber() -> String {
        return replacingOccurrences(of: " ", with: "")
    }
    
    private func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        return String(cleanedUpCopy.enumerated().map({
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
        }).joined().dropFirst())
    }
}
