//
//  RegisterPage.swift
//  Login
//
//  Created by 林湘羚 on 2021/4/27.
//

import SwiftUI

struct RegisterPage: View {
    @Binding var showLoginPage:Bool
    @Binding var showRegisterPage:Bool
    @Binding var showUserProfilePage:Bool
    @Binding var userProfile:UIImage?
    @Binding var showHomePage:Bool
    @State private var name:String=""
    @State private var email:String=""
    @State private var password:String=""
    @State private var showPassword:Bool=false
    @State private var showRegisterErrorAlert:Bool=false
    @State private var errorMessage:String=""
    var body: some View {
        VStack{
            Text("註冊")
                .font(.largeTitle)
            Image(systemName: "person.fill")
                .resizable()
                .frame(width:50, height:50)
                .foregroundColor(.white)
                .padding()
                .background(Color.yellow)
                .clipShape(Circle())
            VStack(spacing:20) {
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.secondary)
                    TextField("姓名", text: $name)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.yellow, lineWidth: 2)
                )
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
                    userProfile = UIImage(systemName: "photo")
                    creatUser(email: email, password: password) { result in
                        switch result {
                        case .success(let str):
                            print(str)
                            setUserName(name:name)
                            showRegisterPage=false
                            showHomePage=true
                        case .failure(let error):
                            print(error.localizedDescription)
                            errorMessage=error.localizedDescription
                            showRegisterErrorAlert=true
                        }
                    }
                }){
                    Text("註冊")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .padding()
                        .padding(.horizontal, 25)
                        .background(Capsule().fill(Color.yellow))
                }
                .alert(isPresented: $showRegisterErrorAlert) {
                    Alert(title: Text("\(errorMessage)"), message: Text(""), dismissButton: .default(Text("了解!")))
                }
                HStack{
                    Text("已經有帳號了？")
                    Button(action:{
                        showRegisterPage=false
                        showLoginPage=true
                    }){
                        Text("登入")
                            .foregroundColor(.yellow)
                    }
                }
            }
            .padding()
        }
    }
}

struct RegisterPage_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPage(showLoginPage: .constant(false), showRegisterPage: .constant(true), showUserProfilePage: .constant(false), userProfile: .constant(UIImage(systemName: "photo")), showHomePage: .constant(false))
    }
}
