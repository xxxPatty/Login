//
//  HomePage.swift
//  Login
//
//  Created by 林湘羚 on 2021/5/7.
//

import SwiftUI

struct HomePage: View {
    @Binding var showHomePage:Bool
    @Binding var showRolePage:Bool
    @Binding var showUserProfilePage:Bool
    @Binding var userProfile:UIImage?
    @Binding var showLoginPage:Bool
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .scaledToFit()
            Image("airplane")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .offset(x:-60, y:-70)
            ZStack(alignment: .topLeading) {
                Button(action:{
                    showHomePage = false
                    showUserProfilePage = true
                }){
                    Image(uiImage: userProfile ?? UIImage(systemName: "person")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.yellow, lineWidth: 2)
                        )
                }
                .padding()
                VStack{
                    
                    Text("Monopoly")
                        .offset(y:150)
                        .font(.largeTitle)
                    VStack{
                        Button(action:{
                            
                        }){
                            Text("開始遊戲")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                                .padding()
                                .padding(.horizontal, 10)
                                .background(Capsule().fill(Color.yellow))
                        }
                        Button(action:{
                            if  isLoginGoogle() {
                                signOutGoogle()
                            } else if isLogin() {
                                logOut()
                            }else if isLoginFB(){
                                logOutFB()
                                logOut()
                            }
                            showHomePage=false
                            showLoginPage=true
                        }){
                            Text("登出")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                                .padding()
                                .padding(.horizontal, 10)
                                .background(Capsule().fill(Color.yellow))
                        }
                    }
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/3*2)
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage(showHomePage: .constant(true), showRolePage: .constant(false), showUserProfilePage: .constant(false), userProfile: .constant(UIImage(systemName: "person.fill")), showLoginPage: .constant(false))
    }
}
