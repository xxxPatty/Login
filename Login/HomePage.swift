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
    @Binding var showCreateGamePage:Bool
    @Binding var showJoinGamePage:Bool
    @Binding var chance:Int
    @Binding var showSettingPage: Bool
    @Binding var rank: [Ranks.Rank]
    @Binding var myUserId: String
    @State private var showInviteRoomAlert:Bool=false
    @State private var showRank: Bool = false
    let rewardedAdController = RewardedAdController()
    var body: some View {
        ZStack{
            Image("city")
                .resizable()
                .scaledToFill()
            
//            Image("background")
//                .resizable()
//                .scaledToFit()
//            Image("airplane")
//                .resizable()
//                .scaledToFit()
//                .frame(height: 200)
//                .offset(x:-60, y:-70)
            
//            Image("richmanHalf")
//                .resizable()
//                .scaledToFit()
//                .frame(height: 300)
//                .shadow(color: .gray, radius: 5)
            Image("monopolyLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .shadow(color: .gray, radius: 5)
                .offset(y:-50)
            VStack {
                HStack{
                    Button(action:{
                        showHomePage = false
                        showUserProfilePage = true
                    }){
                        HStack{
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
                    }
                    Spacer()
                        HStack{
                        HStack{
                            Text("機會 ")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            ForEach(0..<3) {index in
                                HStack{
                                    Image(systemName: index < chance ? "heart.fill" : "heart")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20)
                                        .colorInvert()
                                        .colorMultiply(Color(red:255/255, green:216/255, blue:204/255))
                                }
                            }
                        }
                        Button(action:{
                            showSettingPage = true
                            showHomePage = false
                        }){
                            Image("setting")
                                .resizable()
                                .scaledToFit()
                                .frame(width:30)
                                .colorInvert()
                                .colorMultiply(.yellow)
                        }
                    }
//                    .padding()
//                    .background(Color.yellow.cornerRadius(5))
                }
                .padding()
                VStack{
                    //Spacer()
//                    Text("大富翁")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .padding()
//                        .background(Color.yellow)
//                        .foregroundColor(.white)
//                        .offset(y:-100)
                    Spacer()
                    HStack{
                        Button(action:{
                            if chance > 0 {
                                // - chance
                                setUserChance(userId: myUserId, chance: chance - 1)
                                showInviteRoomAlert = true
                            }else {
                                //看廣告
                                rewardedAdController.showAd()
                            }
                        }){
                            Text("開始遊戲")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                                .padding()
                                .padding(.horizontal, 10)
                                .background(Capsule().fill(Color.yellow))
                                .shadow(color: .gray, radius: 5)
                        }
                        .alert(isPresented:$showInviteRoomAlert) {
                            Alert(
                                title: Text("建立遊戲或加入遊戲?"),
                                message: Text(""),
                                primaryButton: .destructive(Text("建立")) {
                                    showHomePage = false
                                    showCreateGamePage = true
                                },
                                secondaryButton: .destructive(Text("加入")) {
                                    showHomePage = false
                                    showJoinGamePage = true
                                }
                            )
                        }
                        Button(action:{
                            showRank = true
                        }){
                            Text("排行榜")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                                .padding()
                                .padding(.horizontal, 10)
                                .background(Capsule().fill(Color.yellow))
                                .shadow(color: .gray, radius: 5)
                        }
                        .sheet(isPresented: $showRank) {
                            RankView(rank: rank)
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
                                .shadow(color: .gray, radius: 5)
                        }
                    }
                    Spacer()
                }
                .offset(y:70)
            }
            .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width-50, minHeight: 0, maxHeight: UIScreen.main.bounds.height-50, alignment: .center)
        }
        .ignoresSafeArea()
        .onAppear {
            print("HomePage appear")
            print("rank: \(rank)")
            rewardedAdController.loadAd()
            fetchRanking() { result in
                switch result {
                case .success(let loadRanks):
                    rank = loadRanks.rankingArray
                    rank.sort(by: {$0.money > $1.money})
                    print("fetchRanking success")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

//struct HomePage_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePage(showHomePage: .constant(true), showRolePage: .constant(false), showUserProfilePage: .constant(false), userProfile: .constant(UIImage(systemName: "person.fill")), showLoginPage: .constant(false))
//    }
//}
