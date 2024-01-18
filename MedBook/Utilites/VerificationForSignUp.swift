//
//  VerificationForSignUp.swift
//  MedicareApp
//
//  Created by Arrax on 17/01/24.
//

import Foundation

func VerificationForSignUp(email: String, password: String) -> Bool {
    // Validate email format
    guard isEmailValid(email) else {
        print("Invalid email format")
        return false
    }

    // Validate password format
    guard isPasswordValid(password) else {
        print("Invalid password format")
        return false
    }
    
    // If both email and password pass the criteria
    return true
}

func isEmailValid(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}

func isPasswordValid(_ password: String) -> Bool {
    let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-{}\\[\\]:;<>,.?/~]).{8,}$"

    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    return passwordPredicate.evaluate(with: password)
}

func verificationForSignIn(email : String, password : String) -> Bool {
    
    return true
}
