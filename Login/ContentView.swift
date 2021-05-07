//
//  ContentView.swift
//  Login
//
//  Created by 林湘羚 on 2021/4/14.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State private var showLoginPage:Bool=true
    @State private var showRegisterPage:Bool=false
    @State private var showRolePage:Bool=false
    @State private var showUserProfilePage:Bool=false
    @State private var showHomePage:Bool=false
    @State private var userProfile:UIImage? = nil
    @State private var currentUser = Auth.auth().currentUser
    
    var body: some View {
        VStack{
            if showLoginPage {
                LoginPage(showLoginPage: $showLoginPage, showRegisterPage:$showRegisterPage, showUserProfilePage: $showUserProfilePage, userProfile:$userProfile, showHomePage:$showHomePage)
            }else if showRegisterPage{
                RegisterPage(showLoginPage:$showLoginPage, showRegisterPage:$showRegisterPage, showUserProfilePage: $showUserProfilePage, userProfile:$userProfile, showHomePage:$showHomePage)
            }else if showRolePage{
                RolePage(showRolePage:$showRolePage, showUserProfile:$showUserProfilePage, userProfile:$userProfile)
            } else if showUserProfilePage {
                UserProfilePage(showRolePage:$showRolePage, showUserProfilePage:$showUserProfilePage, userProfile:$userProfile, showLoginPage:$showLoginPage, showHomePage:$showHomePage)
            }else if showHomePage {
                HomePage(showHomePage: $showHomePage, showRolePage: $showRolePage, showUserProfilePage: $showUserProfilePage, userProfile: $userProfile, showLoginPage: $showLoginPage)
            }
        }
//        .onAppear{
//            if currentUser != nil {
//                if getUserPhotoURL().absoluteString.contains("firebasestorage") {
//                    downloadUserProfileImg(str:"UserProfile", url:getUserPhotoURL()){ result in
//                        switch result {
//                        case .success(let uiimage):
//                            userProfile=uiimage
//                            showLoginPage = false
//                            showUserProfilePage = true
//                        case .failure(let error):
//                            break
//                        }
//                    }
//                }
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
