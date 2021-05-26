//
//  ContentView.swift
//  RichMan
//
//  Created by 林湘羚 on 2021/4/3.
//

import SwiftUI

struct GamePage: View {
    @Binding var myGame:game
    let colors: [Color] = [Color(red:242/255,green:145/255 ,blue:145/255), Color(red:148/255,green:208/255 ,blue:204/255), Color(red:236/255,green:196/255 ,blue:163/245), Color(red:237/255,green:255/255 ,blue:169/255)]
    @State private var dicePoint = 1
    @State private var dicePoint2 = 1
    @State private var diceDoubleCount = 0
    @Binding var offsetx: [Int]
    @Binding var offsety: [Int]
    @Binding var position: [Int]
    @Binding var showTileInforView: Bool
    @Binding var showTileInforViewIndex: Int
    @Binding var myMap: [game.singleTile]
    @Binding var showingPayToll: Bool
    @Binding var showingGainToll: Bool
    @Binding var showingGainSalary: Bool
    let toll:Int
    var body: some View {
        ZStack {
            if myGame.players.count == myGame.playerNum{
                VStack{
                    ForEach(0..<myGame.players.count) { index in
                        //img改成roleImg
                        playerInforView(imgStr:myGame.players[index].figure, money: myGame.players[index].money, property: 0, turn: index)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.yellow, lineWidth: 2)
                            )
                    }
                }
                .offset(x: -300)
            }
            //扣錢
            if showingPayToll {
                subMoney(showingPayToll: $showingPayToll, money: toll)
            }
            //獲得錢
            if showingGainToll {
                addMoney(showingGainToll: $showingGainToll, money: myGame.lastGainFineRecord.toll)
            }
            if showingGainSalary {
                addSalary(showingGainSalary: $showingGainSalary)
            }
            Group{
                ZStack{
                    Image("\(myMap[8].name)")
                        .resizable()
                        .frame(width:100, height:100)
                        .scaledToFit()
                    Button(action:{
                        print("break")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: 0, y: -140)
                ZStack{
                    if myMap[7].level == 0 || myMap[7].level == 1{
                        Image("\(myMap[7].name)")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                    }
                    if myMap[7].level == 2 {
                        Image("\(myMap[7].name)2")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[7].owner])
                    }
                    if myMap[7].level == 1 {
                        Image("whiteFlag")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[7].owner])
                    }
                    Button(action:{
                        print("egypt")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: -55, y: -110)
                ZStack{
                    if myMap[9].level == 0 || myMap[9].level == 1{
                        Image("\(myMap[9].name)")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                    }
                    if myMap[9].level == 2 {
                        Image("\(myMap[9].name)2")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[9].owner])
                    }
                    if myMap[9].level == 1 {
                        Image("whiteFlag")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[9].owner])
                    }
                    Button(action:{
                        print("france")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: 55, y: -110)
                ZStack{
                    Image("\(myMap[6].name)")
                        .resizable()
                        .frame(width:100, height:100)
                        .scaledToFit()
                    Button(action:{
                        print("game")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: -110, y: -80)
                ZStack{
                    if myMap[10].level == 0 || myMap[10].level == 1{
                        Image("\(myMap[10].name)")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                    }
                    if myMap[10].level == 2 {
                        Image("\(myMap[10].name)2")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[10].owner])
                    }
                    if myMap[10].level == 1 {
                        Image("whiteFlag")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[10].owner])
                    }
                    Button(action:{
                        print("england")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: 110, y: -80)
                ZStack{
                    if myMap[5].level == 0 || myMap[5].level == 1{
                        Image("\(myMap[5].name)")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                    }
                    if myMap[5].level == 2 {
                        Image("\(myMap[5].name)2")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[5].owner])
                    }
                    if myMap[5].level == 1 {
                        Image("whiteFlag")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[5].owner])
                    }
                    Button(action:{
                        print("australia")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: -165, y: -50)
                ZStack{
                    if myMap[11].level == 0 || myMap[11].level == 1{
                        Image("\(myMap[11].name)")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                    }
                    if myMap[11].level == 2 {
                        Image("\(myMap[11].name)2")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[11].owner])
                    }
                    if myMap[11].level == 1 {
                        Image("whiteFlag")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[11].owner])
                    }
                    Button(action:{
                        print("italy")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: 165, y: -50)
                ZStack{
                    Image("\(myMap[4].name)")
                        .resizable()
                        .frame(width:100, height:100)
                        .scaledToFit()
                    Button(action:{
                        print("jail")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: -220, y: -20)
                ZStack{
                    Image("\(myMap[12].name)")
                        .resizable()
                        .frame(width:100, height:100)
                        .scaledToFit()
                    Button(action:{
                        print("travel")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: 220, y: -20)
                ZStack{
                    if myMap[3].level == 0 || myMap[3].level == 1{
                        Image("\(myMap[3].name)")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                    }
                    if myMap[3].level == 2 {
                        Image("\(myMap[3].name)2")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[3].owner])
                    }
                    if myMap[3].level == 1 {
                        Image("whiteFlag")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[3].owner])
                    }
                    Button(action:{
                        print("china")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: -165, y: 10)
            }
            Group{
                ZStack{
                    if myMap[13].level == 0 || myMap[13].level == 1{
                        Image("\(myMap[13].name)")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                    }
                    if myMap[13].level == 2 {
                        Image("\(myMap[13].name)2")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[13].owner])
                    }
                    if myMap[13].level == 1 {
                        Image("whiteFlag")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[13].owner])
                    }
                    Button(action:{
                        print("america")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: 165, y: 10)
                ZStack{
                    if myMap[2].level == 0 || myMap[2].level == 1{
                        Image("\(myMap[2].name)")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                    }
                    if myMap[2].level == 2 {
                        Image("\(myMap[2].name)2")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[2].owner])
                    }
                    if myMap[2].level == 1 {
                        Image("whiteFlag")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[2].owner])
                    }
                    Button(action:{
                        print("japan")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: -110, y: 40)
                ZStack{
                    Image("\(myMap[14].name)")
                        .resizable()
                        .frame(width:100, height:100)
                        .scaledToFit()
                    Button(action:{
                        print("fine")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: 110, y: 40)
                ZStack{
                    if myMap[1].level == 0 || myMap[1].level == 1{
                        Image("\(myMap[1].name)")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                    }
                    if myMap[1].level == 2 {
                        Image("\(myMap[1].name)2")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[1].owner])
                    }
                    if myMap[1].level == 1 {
                        Image("whiteFlag")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[1].owner])
                    }
                    Button(action:{
                        print("taiwan")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: -55, y: 70)
                ZStack{
                    if myMap[15].level == 0 || myMap[15].level == 1{
                        Image("\(myMap[15].name)")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                    }
                    if myMap[15].level == 2 {
                        Image("\(myMap[15].name)2")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[15].owner])
                    }
                    if myMap[15].level == 1 {
                        Image("whiteFlag")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                            .colorMultiply(colors[myMap[15].owner])
                    }
                    Button(action:{
                        print("mexico")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: 55, y: 70)
                ZStack{
                    Image("\(myMap[0].name)")
                        .resizable()
                        .frame(width:100, height:100)
                        .scaledToFit()
                    Button(action:{
                        print("start")
                    }){
                        Text("    ")
                            .frame(width:60, height: 35)
                            .offset(x: 0, y: 20)
                    }
                }
                .offset(x: 0, y: 100)
                //Player1
                if myGame.players.count >= 1 {
                    Image("\(myGame.players[0].figure)")
                        .resizable()
                        .frame(width:30, height:50)
                        .scaledToFit()
                        //                    .colorInvert()
                        .colorMultiply(colors[0])
                        .offset(x: CGFloat(-20 + offsetx[0]), y: CGFloat(110 + offsety[0]))
                }
                //Player2
                if myGame.players.count >= 2 {
                    Image("\(myGame.players[1].figure)")
                        .resizable()
                        .frame(width:30, height:50)
                        .scaledToFit()
//                        .colorInvert()
                        .colorMultiply(colors[1])
                        .offset(x: CGFloat(20 + offsetx[1]), y: CGFloat(110 + offsety[1]))
                }
                //Player3
                if myGame.players.count >= 3 {
                    Image("\(myGame.players[2].figure)")
                        .resizable()
                        .frame(width:30, height:50)
                        .scaledToFit()
//                        .colorInvert()
                        .colorMultiply(colors[2])
                        .offset(x: CGFloat(0 + offsetx[2]), y: CGFloat(90 + offsety[2]))
                }
                //Player4
                if myGame.players.count >= 4 {
                    Image("\(myGame.players[3].figure)")
                        .resizable()
                        .frame(width:30, height:50)
                        .scaledToFit()
//                        .colorInvert()
                        .colorMultiply(colors[3])
                        .offset(x: CGFloat(0 + offsetx[3]), y: CGFloat(130 + offsety[3]))
                }
            }
            Group{
                VStack{
                    Text("你躑到： \(dicePoint) & \(dicePoint2)")
                    //輪到自己時
                    if myGame.players.count == myGame.playerNum {
                        if myGame.players[myGame.turn].userId == getUserId() && myGame.buy == false && myGame.move == false {
                            Text("輪到你囉！")
                            Button(action:{
                                //擲骰子
                                dicePoint = Int.random(in: 1...6)
                                dicePoint2 = Int.random(in: 1...6)
                                if dicePoint == dicePoint2 {
                                    diceDoubleCount += 1
                                    if diceDoubleCount >= 3 {
                                        //進監獄
                                        diceDoubleCount = 0
                                        setGameNext(gameId: myGame.invatationCode, next: true)
                                    }else {
                                        setGameNext(gameId: myGame.invatationCode, next: false)
                                    }
                                }else{
                                    diceDoubleCount = 0
                                    setGameNext(gameId: myGame.invatationCode, next: true)
                                }
                                //存入firebase
                                setPlayerDicePoint(gameId: myGame.invatationCode, myPlayer: myGame.players[myGame.turn], dicePoint: dicePoint+dicePoint2)
                                setGameMove(gameId: myGame.invatationCode, move: true)
                            }){
                                ZStack{
                                    Image("dice\(dicePoint)")
                                        .resizable()
                                        .frame(width:50, height:50)
                                        .scaledToFit()
                                        .offset(x: 20, y: 0)
                                    Image("dice\(dicePoint2)")
                                        .resizable()
                                        .frame(width:50, height:50)
                                        .scaledToFit()
                                        .offset(x: -20, y: 0)
                                }
                        }
                    }
                }
                }
                if showTileInforView {
                    TileInforView(show: $showTileInforView, singleTileInfor: $myMap[showTileInforViewIndex], myGame: $myGame, showTileInforViewIndex: $showTileInforViewIndex)
                }
            }
        }
    }
}

