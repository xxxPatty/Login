//
//  LoginPage.swift
//  Login
//
//  Created by 林湘羚 on 2021/4/27.
//

import SwiftUI
import FacebookLogin
import Firebase
import GoogleSignIn

struct LoginPage: View {
    @Binding var showLoginPage:Bool
    @Binding var showRegisterPage:Bool
    @Binding var showUserProfilePage:Bool
    @Binding var userProfile:UIImage?
    @Binding var showHomePage:Bool
    @Binding var myUserDetail:UserDetail
    @Binding var myUserId:String
    @State private var email:String=""
    @State private var password:String=""
    @State private var showPassword:Bool=false
    @State private var showLoginErrorAlert:Bool=false
    @State private var errorMessage:String=""
    let signInGoogleCompletedNotificaiton = NotificationCenter.default.publisher(for: Notification.Name("GoogleSignInSuccess"))
    
    var body: some View {
        VStack{
            Text("歡迎!")
            Text("登入")
                .font(.largeTitle)
            VStack(spacing:20) {
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.secondary)
                    TextField("信箱", text: $email)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.yellow, lineWidth: 2)
                )
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.secondary)
                    if showPassword {
                        TextField("密碼", text: $password)
                    } else {
                        SecureField("密碼", text: $password)
                    }
                    Button(action: { self.showPassword.toggle()}) {
                        Image(systemName: "eye")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.yellow, lineWidth: 2)
                )
                Button(action:{
                    signIn(email: email, password: password) { result in
                        switch result {
                        case .success(let str):
                            print(str)
                            showLoginPage=false
                            showHomePage=true
                            downloadUserProfileImg(str:"UserProfile", url:getUserPhotoURL()){ result in
                                switch result {
                                case .success(let uiimage):
                                    userProfile=uiimage
                                case .failure(let error):
                                    break
                                }
                            }
                            
                            fetchUserImmediate(userId:getUserId()){ result in
                                switch result {
                                case .success(let userDetail):
                                    myUserDetail = userDetail
                                case .failure(let error):
                                    break
                                }
                            }
                            myUserId = getUserId()
                        case .failure(let error):
                            print(error.localizedDescription)
                            errorMessage=error.localizedDescription
                            showLoginErrorAlert=true
                        }
                    }
                }){
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.white)
                        Text("信箱登入")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .medium))
                            .padding()
                    }
                    .padding(.horizontal, 25)
                    .background(Capsule().fill(Color.yellow))
                    .shadow(color: .gray, radius: 5)
                }
                .alert(isPresented: $showLoginErrorAlert) {
                    Alert(title: Text("\(errorMessage)"), message: Text(""), dismissButton: .default(Text("了解!")))
                }
                //FB登入
                Button(action:{
                    loginUseFB(){ resulrMessage in
                        print(resulrMessage)
                        showLoginPage=false
                        showHomePage=true
                        if getUserPhotoURL().absoluteString.contains("firebasestorage") {
                            downloadUserProfileImg(str:"FB ", url:getUserPhotoURL()){ result in
                                switch result {
                                case .success(let uiimage):
                                    userProfile=uiimage
                                case .failure(let error):
                                    break
                                }
                            }
                        }
                        fetchUserImmediate(userId:getUserId()){ result in
                            switch result {
                            case .success(let userDetail):
                                myUserDetail = userDetail
                            case .failure(let error):
                                break
                            }
                        }
                        myUserId = getUserId()
                    }
                }){
                    HStack{
                        Text("f")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 25, weight: .heavy))
                        Text("FACEBOOK登入")
                            .foregroundColor(.white)
                            //.fontWeight(.bold)
                            .font(.system(size: 20, weight: .medium))
                            .padding()
                    }
                    .padding(.horizontal, 25)
                    .background(Capsule().fill(Color.blue))
                    .shadow(color: .gray, radius: 5)
                }
                //google登入
                Button(action:{
                    GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
                    GIDSignIn.sharedInstance().signIn()
                }){
                    HStack{
                        Image("GoogleSign")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text("GOOGLE登入")
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .medium))
                            .padding()
                    }
                    .padding(.horizontal, 25)
                    .background(Capsule().fill(Color.white))
                    .shadow(color: .gray, radius: 5)
                }
                //偵測google登入完成
                .onReceive(signInGoogleCompletedNotificaiton, perform: { _ in
                    showLoginPage=false
                    showHomePage=true
                    if getUserPhotoURL().absoluteString.contains("firebasestorage") {
                        print("download")
                        downloadUserProfileImg(str:"Google ", url:getUserPhotoURL()){ result in
                            switch result {
                            case .success(let uiimage):
                                userProfile=uiimage
                            case .failure(let error):
                                break
                            }
                        }
                    }else {
                        print("no download")
                    }
                    fetchUserImmediate(userId:getUserId()){ result in
                        switch result {
                        case .success(let userDetail):
                            myUserDetail = userDetail
                        case .failure(let error):
                            break
                        }
                    }
                    myUserId = getUserId()
                })
                HStack{
                    Text("還沒有帳號？")
                    Button(action:{
                        showLoginPage=false
                        showRegisterPage=true
                    }){
                        Text("註冊")
                            .foregroundColor(.yellow)
                    }
                }
            }
            .padding()
        }
    }
}

//struct LoginPage_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginPage(showLoginPage: .constant(true), showRegisterPage: .constant(false), showUserProfilePage: .constant(false), userProfile: .constant(UIImage(systemName: "photo")), showHomePage: .constant(false))
//    }
//}
