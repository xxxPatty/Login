//
//  map.swift
//  RichMan
//
//  Created by 林湘羚 on 2021/4/3.
//

import Foundation
import SwiftUI

//每個tile的詳細資訊
struct TileInforView: View {
    @State private var showingMoneyNotEnoughAlert = false
    @Binding var show: Bool
    @Binding var singleTileInfor : game.singleTile
    @Binding var myGame: game
    @Binding var showTileInforViewIndex: Int
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            VStack(spacing: 25){
                Text(singleTileInfor.name)
                    .font(.title)
                Image(singleTileInfor.imgStr)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                Text("土地：$\(singleTileInfor.price[0])")
                Text("地標：$\(singleTileInfor.price[1])")
                Text(singleTileInfor.description)
                
                HStack{
                    Button(action:{
                        show=false
                        //買 or 付過路費
                        if singleTileInfor.level == 0 { //買地
                            //設定level, owner, player tile(property), player money
                            //有必要存player tile(property)嗎
                            if myGame.players[myGame.turn].money >= singleTileInfor.price[0] {
                                setTileLevelOwner(gameId: myGame.invatationCode, myTile: game.simpleSingleTile(index: showTileInforViewIndex, level: 1, owner: myGame.turn))
                                setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[myGame.turn], money: myGame.players[myGame.turn].money - singleTileInfor.price[0])
                                setGameBuy(gameId: myGame.invatationCode, buy: true)
                            }else{
                                //alert💰不夠
                                showingMoneyNotEnoughAlert = true
                            }
                        }else if singleTileInfor.level == 1 {
                            if myGame.players[myGame.turn].money >= singleTileInfor.price[1] {
                                setTileLevelOwner(gameId: myGame.invatationCode, myTile: game.simpleSingleTile(index: showTileInforViewIndex, level: 2, owner: myGame.turn))
                                setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[myGame.turn], money: myGame.players[myGame.turn].money - singleTileInfor.price[1])
                                setGameBuy(gameId: myGame.invatationCode, buy: true)
                            }else{
                                //alert💰不夠
                                showingMoneyNotEnoughAlert = true
                            }
                        }
                    }){
                        Text("Buy")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .background(Color.black)
                            .clipShape(Capsule())
                    }
                    .alert(isPresented: $showingMoneyNotEnoughAlert) {
                        Alert(title: Text("哎呀，錢不夠"), message: Text(""), dismissButton: .default(Text("好吧")))
                    }
                    Button(action:{
                        show=false
                        setGameBuy(gameId: myGame.invatationCode, buy: true)
                    }){
                        Text("No")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .background(Color.black)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.vertical, 25)
            .padding(.horizontal, 30)
            .background(BlurView())
            .cornerRadius(25)
            
            Button(action:{
                withAnimation{
                    show=false
                    setGameBuy(gameId: myGame.invatationCode, buy: true)
                }
            }){
                Image(systemName: "xmark.circle")
                    .font(.system(size: 20, weight: .bold))
            }
            .padding()
        }
    }
}

struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
    }
}

//玩家資訊
struct playerInforView: View {
    var imgStr: String
    var money: Int
    var property: Int
    var turn: Int
    let colors: [Color] = [Color(red:242/255,green:145/255 ,blue:145/255), Color(red:148/255,green:208/255 ,blue:204/255), Color(red:236/255,green:196/255 ,blue:163/245), Color(red:237/255,green:255/255 ,blue:169/255)]
    var body: some View {
        HStack{
            Image(systemName: "\(turn+1).circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 25)
            Image(imgStr)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 50)
                .colorMultiply(colors[turn])
            VStack{
                Text("\(money)")
                    .fontWeight(.bold)
                Text("\(property)")
            }
        }
    }
}

//扣錢
struct subMoney: View {
    @Binding var showingPayToll: Bool
    let money: Int
    var body: some View {
        VStack{
            Image("money")
                .resizable()
                .frame(width: 100, height: 100)
            Text("收取過路費\(money)")
        }
        .shadow(color: Color.red, radius: 10)
        .transition(.scale)
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.showingPayToll = false
            })
        })
    }
}

//獲得過路費
struct addMoney: View {
    @Binding var showingGainToll: Bool
    let money: Int
    var body: some View {
        VStack{
            Image("money")
                .resizable()
                .frame(width: 100, height: 100)
            Text("獲得過路費\(money)")
        }
        .shadow(color: Color.green, radius: 10)
        .transition(.scale)
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.showingGainToll = false
            })
        })
    }
}

//獲得薪水
struct addSalary: View {
    @Binding var showingGainSalary: Bool
    let money: Int = 100000
    var body: some View {
        VStack{
            Image("money")
                .resizable()
                .frame(width: 100, height: 100)
            Text("獲得薪水\(money)")
        }
        .shadow(color: Color.green, radius: 10)
        .transition(.scale)
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.showingGainSalary = false
            })
        })
    }
}
