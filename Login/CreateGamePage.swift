//
//  CreateGamePage.swift
//  Login
//
//  Created by 林湘羚 on 2021/5/9.
//

import SwiftUI

struct CreateGamePage: View {
    @Binding var myGame: game
    @Binding var showGameWaitPage: Bool
    @Binding var showCreateGamePage: Bool
    @Binding var showHomePage: Bool
    let myUserId:String
    @State private var robotPage: Int=0
    @State private var mapPage: Int=0
    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    showCreateGamePage=false
                    showHomePage=true
                }){
                    Image(systemName:"arrow.left.square.fill")
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("建立遊戲")
                    .font(.largeTitle)
                Spacer()
            }
            Text("建立遊戲並透過邀請碼邀請朋友們")
            Text("選擇棋子樣式與地圖")
            HStack{
                ZStack{
                    TabView(selection: $robotPage) {
                        ForEach(1..<7) { (index) in
                            Image("robot\(index)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
                .frame(height:120)
                .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.yellow, lineWidth: 2)
                    )
                VStack{
                    TabView(selection: $mapPage) {
                        Image("world")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .tag(0)
                        Image("covid 19")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    Text(mapPage == 0 ? "環遊世界版" : "居家防疫版")
                }
                .frame(height:120)
                .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.yellow, lineWidth: 2)
                    )
            }
            Spacer()
            Button(action:{
                myGame.map = mapPage
                myGame.players[0].name = getUserName()
                myGame.players[0].id=myUserId
                myGame.hostId=myUserId
                myGame.players[0].figure = "robot\(robotPage+1)"
                addGame(myGame: &myGame)
                showCreateGamePage = false
                showGameWaitPage = true
            }){
                Text("建立")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .padding()
                    .padding(.horizontal, 10)
                    .background(Capsule().fill(Color.yellow))
            }
        }
    }
}

struct JoinGamePage: View {
    @State private var invatationCode:String=""
    @State private var robotPage: Int=0
    @Binding var myGame: game
    @Binding var showGameWaitPage: Bool
    @Binding var showJoinGamePage: Bool
    @Binding var myTurn: Int
    @Binding var showHomePage: Bool
    let myUserId:String
    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    showJoinGamePage=false
                    showHomePage=true
                }){
                    Image(systemName:"arrow.left.square.fill")
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("加入遊戲")
                    .font(.largeTitle)
                Spacer()
            }
            HStack{
                Image(systemName: "number")
                    .foregroundColor(.secondary)
                TextField("請輸入邀請碼", text:$invatationCode)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.yellow, lineWidth: 2)
            )
            Text("輸入邀請碼來加入遊戲")
            Text("選擇棋子")
            VStack{
            TabView(selection: $robotPage) {
                    ForEach(1..<7) { (index) in
                        Image("robot\(index)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
            .frame(width: 100, height: 100)
            .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.yellow, lineWidth: 2)
                )
            Spacer()
            Button(action:{
                fetchGame(gameId: invatationCode) { result in
                    switch result {
                    case .success(let myGame):
                        self.myGame = myGame
                        //把自己加入此game(firebase)
                        myTurn = myGame.players.count
                        setGamePlayerNum(gameId: myGame.invatationCode, num: myGame.playerNum+1)
                        addPlayer(gameId: invatationCode, myPlayer: game.player(index: myGame.players.count, dicePoint: 0, id: myUserId, name: getUserName(), money: 500000, figure: "robot\(robotPage+1)", inJail: false, jailNotDoubleCount: 0, bankrupt: false))
                        showJoinGamePage = false
                        showGameWaitPage = true
                    case .failure(let error):
                        print("邀請碼無效")
                    }
                }
            }){
                Text("加入")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .padding()
                    .padding(.horizontal, 10)
                    .background(Capsule().fill(Color.yellow))
            }
        }
    }
}

//struct CreateGamePage_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateGamePage()
//    }
//}
