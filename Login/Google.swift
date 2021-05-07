//
//  Google.swift
//  Login
//
//  Created by 林湘羚 on 2021/5/4.
//

import Firebase
import GoogleSignIn


func signOutGoogle() {
    GIDSignIn.sharedInstance()?.signOut()
    try! Auth.auth().signOut()
}

func isLoginGoogle() -> Bool {
    if GIDSignIn.sharedInstance()?.currentUser != nil {
        return true
    } else {
        return false
    }
}


