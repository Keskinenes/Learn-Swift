//
//  PrivateUser.swift
//  SwiftOOP
//
//  Created by Enes Keskin on 8/11/22.
//

import Foundation

class PrivateUser : User {
    
    func newFunc(){
        print("New Function runned.")
    }
    
    override func exampleFunc() {
        super.exampleFunc()
        print("Private User Example")
    }
    
}
