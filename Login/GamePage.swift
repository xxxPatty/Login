//
//  ContentView.swift
//  RichMan
//
//  Created by 林湘羚 on 2021/4/3.
//

import SwiftUI

struct GamePage: View {
    @Binding var myGame:game
    let colors: [Color] = [Color(red:242/255,green:145/255 ,blue:145/255), Color(red:148/255,green:208/255 ,blue:204/255), Color(red:121/255,green:82/255 ,blue:179/255), Color(red:255/255,green:193/255 ,blue:7/255)]
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
    @Binding var showingJailAnimation: Bool
    @Binding var showingJailAlert: Bool
    @Binding var firstShowingJailAlert: Bool
    @Binding var showingTravel: Bool
    @Binding var isTravel: Bool
    @Binding var showingGuessGame: Bool
    @Binding var showingGameWin: Bool
    @Binding var showingGameLose: Bool
    @Binding var showingTakeABreak: Bool
    @Binding var showingTax: Bool
    @Binding var tax: Int
    @Binding var showingTradeMessage: Bool
    @Binding var isTrading: Bool
    @Binding var showingBankruptMessage: Bool
    @Binding var showingMoneyNotEnoughMessage: Bool
    @Binding var inJail: Bool
    @Binding var showingNoDestinationMessage: Bool
    @Binding var showingGameOverMessage: Bool
    @Binding var showingWinner: Bool
    @Binding var showingGainChance: Bool
    @Binding var showGamePage: Bool
    @Binding var showHomePage: Bool
    let myUserId:String
    @State private var leaveJailWay: Int = 0
    @State private var showingPayJail: Bool = false
    @State private var showingEscapeJailSucessMessage: Bool = false
    @State private var showingEscapeJailFailMessage: Bool = false
    @State private var showingEscapeJailWithPay: Bool = false
    @State private var showingNotAllowedTravelDestinationAlert: Bool = false
    @State private var showingDoubleMessage: Bool = false
    @State private var showingNotOwnerAlert: Bool = false
    @State private var showingTradeSuccess: Bool = false
    @State private var tradeGainedMoney: Int = 0
    @State private var showingThreeTimesDoubleMessage: Bool = false
    var body: some View {
        ZStack {
            Image("worldMap")
                .resizable()
                .scaledToFit()
            Group {
                Group{
                    //玩家資訊
                    if myGame.players.count == myGame.playerNum{
                        VStack{
                            Text("Players")
                                .fontWeight(.bold)
                            ForEach(myGame.players, id: \.id) { player in
                                VStack{
                                    //img改成roleImg
                                    playerInforView(imgStr:player.figure, money: player.money, turn: player.index, name: player.name, bankrupt: player.bankrupt, isSelf:myUserId==player.id)
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.yellow, lineWidth: 2)
                                        )
                                }
                            }
                        }
                        .offset(x: -300)
                    }
                }
                Group{
                    ZStack{
                        Image("\(myMap[8].name)")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                        Button(action:{
                            print("break")
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[8], position: 8)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[8], index: 8)
                            }
                        }){
                            Text("    ")
                                .frame(width:60, height: 35)
                                .offset(x: 0, y: 20)
                        }
                    }
                    .offset(x: 0, y: -140)
                    .alert(isPresented: $showingNotAllowedTravelDestinationAlert) {   //禁止旅遊
                        Alert(title: Text("此地禁止旅遊，再選一次"), message: nil, dismissButton: .default(Text("了解")))
                    }
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
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[7], position: 7)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[7], index: 7)
                            }
                        }){
                            Text("    ")
                                .frame(width:60, height: 35)
                                .offset(x: 0, y: 20)
                        }
                    }
                    .offset(x: -55, y: -110)
                    .alert(isPresented:$showingJailAlert) {
                        Alert(
                            title: Text("請選擇離開監獄方式"),
                            message: Text(""),
                            primaryButton: .destructive(Text("擲骰子")) {
                                leaveJailWay = 1
                            },
                            secondaryButton: .destructive(Text("付$200000")) {
                                if myGame.players[myGame.turn].money >= 200000 {
                                    inJail = false
                                    setPlayerOutJailWithPay(gameId: myGame.invatationCode, myPlayer: myGame.players[myGame.turn], inJail: false, jailNotDoubleCount: 0, money: myGame.players[myGame.turn].money - 200000)
                                    firstShowingJailAlert = false
                                    
                                    showingEscapeJailWithPay = true
                                    if myGame.next {
                                        checkAndSetGameTurn()
                                    }
                                }else {
                                    showingMoneyNotEnoughMessage = true
                                    leaveJailWay = 1
                                }
                            }
                        )
                    }
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
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[9], position: 9)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[9], index: 9)
                            }
                        }){
                            Text("    ")
                                .frame(width:60, height: 35)
                                .offset(x: 0, y: 20)
                        }
                    }
                    .offset(x: 55, y: -110)
                    .alert(isPresented: $showingNotOwnerAlert) {   //禁止旅遊
                        Alert(title: Text("不是你的財產，再選一次"), message: nil, dismissButton: .default(Text("了解")))
                    }
                    ZStack{
                        Image("\(myMap[6].name)")
                            .resizable()
                            .frame(width:100, height:100)
                            .scaledToFit()
                        Button(action:{
                            print("game")
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[6], position: 6)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[6], index: 6)
                            }
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
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[10], position: 10)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[10], index: 10)
                            }
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
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[5], position: 5)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[5], index: 5)
                            }
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
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[11], position: 11)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[11], index: 11)
                            }
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
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[4], position: 4)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[4], index: 4)
                            }
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
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[12], position: 12)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[12], index: 12)
                            }
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
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[3], position: 3)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[3], index: 3)
                            }
                        }){
                            Text("    ")
                                .frame(width:60, height: 35)
                                .offset(x: 0, y: 20)
                        }
                    }
                    .offset(x: -165, y: 10)
                }
                .offset(x:50)
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
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[13], position: 13)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[13], index: 13)
                            }
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
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[2], position: 2)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[2], index: 2)
                            }
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
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[14], position: 14)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[14], index: 14)
                            }
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
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[1], position: 1)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[1], index: 1)
                            }
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
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[15], position: 15)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[15], index: 15)
                            }
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
                            if isTravel {
                                checkTravelDestination(selectedSingleTile: myMap[0], position: 0)
                            }
                            if isTrading {
                                checkTileOwner(selectedSingleTile: myMap[0], index: 0)
                            }
                        }){
                            Text("    ")
                                .frame(width:60, height: 35)
                                .offset(x: 0, y: 20)
                        }
                    }
                    .offset(x: 0, y: 100)
                    //Player1
                    if myGame.players.count == myGame.playerNum {
                        if myGame.playerNum >= 1 && !myGame.players[0].bankrupt {
                            Image("\(myGame.players[0].figure)")
                                .resizable()
                                .frame(width:30, height:50)
                                .scaledToFit()
                                .colorMultiply(colors[myGame.players[0].index])
                                .offset(x: CGFloat(-20 + offsetx[0]), y: CGFloat(110 + offsety[0]))
                        }
                        //Player2
                        if myGame.playerNum >= 2 && !myGame.players[1].bankrupt {
                            Image("\(myGame.players[1].figure)")
                                .resizable()
                                .frame(width:30, height:50)
                                .scaledToFit()
                                .colorMultiply(colors[myGame.players[1].index])
                                .offset(x: CGFloat(20 + offsetx[1]), y: CGFloat(110 + offsety[1]))
                        }
                        //Player3
                        if myGame.playerNum >= 3 && !myGame.players[2].bankrupt {
                            Image("\(myGame.players[2].figure)")
                                .resizable()
                                .frame(width:30, height:50)
                                .scaledToFit()
                                .colorMultiply(colors[myGame.players[2].index])
                                .offset(x: CGFloat(0 + offsetx[2]), y: CGFloat(90 + offsety[2]))
                        }
                        //Player4
                        if myGame.playerNum >= 4 && !myGame.players[3].bankrupt {
                            Image("\(myGame.players[3].figure)")
                                .resizable()
                                .frame(width:30, height:50)
                                .scaledToFit()
                                .colorMultiply(colors[myGame.players[3].index])
                                .offset(x: CGFloat(0 + offsetx[3]), y: CGFloat(130 + offsety[3]))
                        }
                    }
                }
                .offset(x:50)
                Group{
                    VStack{
                        Text("你躑到： \(dicePoint) & \(dicePoint2)")
                        
                        //輪到自己時
                        if myGame.players.count == myGame.playerNum && !isTrading && !isTravel {
                            if myGame.players[myGame.turn].id == myUserId && !myGame.buy && !myGame.move && !myGame.players[myGame.turn].bankrupt {
                                if myGame.players[myGame.turn].inJail && leaveJailWay == 1{ //逃離監獄中
                                    Text("擲骰子離開監獄")
                                    Button(action:{
                                        dicePoint = Int.random(in: 1...6)
                                        dicePoint2 = Int.random(in: 1...6)
                                        setGameNext(gameId: myGame.invatationCode, next: true)
                                        if dicePoint == dicePoint2 {    //成功逃出
                                            inJail = false
                                            showingEscapeJailSucessMessage = true
                                            setPlayerOutJailWithDouble(gameId: myGame.invatationCode, myPlayer: myGame.players[myGame.turn], inJail: false, jailNotDoubleCount: 0, dicePoint: dicePoint+dicePoint2)
                                            setGameMove(gameId: myGame.invatationCode, move: true)
                                            firstShowingJailAlert = false
                                        }else { //失敗
                                            if myGame.players[myGame.turn].jailNotDoubleCount >= 3 {    //強制付款
                                                inJail = false
                                                //動畫
                                                showingPayJail = true
                                                //付款出獄
                                                setPlayerOutJailWithPay(gameId: myGame.invatationCode, myPlayer: myGame.players[myGame.turn], inJail: false, jailNotDoubleCount: 0, money: myGame.players[myGame.turn].money - 200000)
                                                checkLoop()
                                                
                                                firstShowingJailAlert = false
                                            }else { //等下一輪嘗試
                                                showingEscapeJailFailMessage = true
                                                let tempTurn = myGame.turn
                                                if myGame.next {
                                                    checkAndSetGameTurn()
                                                }
                                                setPlayerJailNotDoubleCount(gameId: myGame.invatationCode, myPlayer: myGame.players[tempTurn], jailNotDoubleCount: myGame.players[tempTurn].jailNotDoubleCount + 1)
                                            }
                                        }
                                        leaveJailWay = 0
                                        print("myGame.turn: \(myGame.turn)")
                                        print("firstShowingJailAlert: \(firstShowingJailAlert)")
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
                                }else {
                                    Text("輪到你囉！")
                                    Button(action:{
                                        //擲骰子
                                        dicePoint = Int.random(in: 1...6)
                                        dicePoint2 = Int.random(in: 1...6)
                                        let tempPosition = (position[myGame.turn] + dicePoint + dicePoint2) % 16
                                        if dicePoint == dicePoint2 {
                                            diceDoubleCount += 1
                                            if diceDoubleCount >= 3 {   //連續三次double入獄
                                                //進監獄
                                                inJail = true
                                                showingJailAnimation = true
                                                showingThreeTimesDoubleMessage = true
                                                setGameLastEditedPositionRecord(gameId:myGame.invatationCode, lastEditedPositionRecord: game.editedPositionRecord(index: myGame.turn, newPosition: 4))
                                                setGameGo(gameId:myGame.invatationCode, go:true)
                                                
                                                firstShowingJailAlert = false
                                                let tempTurn = myGame.turn
                                                checkAndSetGameTurn()
                                                
                                                setPlayerInJail(gameId: myGame.invatationCode, myPlayer: myGame.players[tempTurn], inJail: true)
                                                showingJailAnimation = true
                                                
                                                diceDoubleCount = 0
                                                setGameNext(gameId: myGame.invatationCode, next: true)
                                            }else {
                                                if tempPosition != 4 {
                                                    showingDoubleMessage = true
                                                    setGameNext(gameId: myGame.invatationCode, next: false)
                                                }
                                                //存入firebase
                                                setPlayerDicePoint(gameId: myGame.invatationCode, myPlayer: myGame.players[myGame.turn], dicePoint: dicePoint+dicePoint2)
                                                setGameMove(gameId: myGame.invatationCode, move: true)
                                            }
                                        }else{
                                            diceDoubleCount = 0
                                            setGameNext(gameId: myGame.invatationCode, next: true)
                                            
                                            //存入firebase
                                            setPlayerDicePoint(gameId: myGame.invatationCode, myPlayer: myGame.players[myGame.turn], dicePoint: dicePoint+dicePoint2)
                                            setGameMove(gameId: myGame.invatationCode, move: true)
                                        }
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
                    }
                }
                .offset(x:50)
                
            }
            
            Group {
                //收過路費
                if showingPayToll {
                    subMoney(showingPayToll: $showingPayToll, text: "收取過路費", money: toll)
                }
                //獲得錢
                if showingGainToll {
                    addMoney(showingGainToll: $showingGainToll, text: "獲得過路費", money: myGame.lastGainFineRecord.toll)
                }
                if showingGainSalary {
                    addMoney(showingGainToll: $showingGainSalary, text: "獲得薪水", money: 100000)
                }
                if showingThreeTimesDoubleMessage {
                    message(showingMessage: $showingThreeTimesDoubleMessage, text: "連續三次double")
                }
                if showingJailAnimation {
                    goToJail(showingJailAnimation: $showingJailAnimation)
                }
                if showingPayJail {
                    subMoney(showingPayToll: $showingPayJail, text: "超過三次，強制收取保釋金", money: 200000)
                }
                if showingEscapeJailSucessMessage {
                    message(showingMessage: $showingEscapeJailSucessMessage, text: "出獄成功")
                }
                if showingEscapeJailFailMessage {
                    message(showingMessage: $showingEscapeJailFailMessage, text: "出獄失敗")
                }
                if showTileInforView {
                    TileInforView(show: $showTileInforView, singleTileInfor: $myMap[showTileInforViewIndex], myGame: $myGame, showTileInforViewIndex: $showTileInforViewIndex)
                }
                if showingMoneyNotEnoughMessage {
                    message(showingMessage: $showingMoneyNotEnoughMessage, text: "錢不夠，請擲骰子")
                }
            }
            Group {
                if showingEscapeJailWithPay {
                    subMoney(showingPayToll: $showingEscapeJailWithPay, text: "收取保釋金，成功出獄", money: 200000)
                }
                if showingTravel {
                    travel(showingTravel: $showingTravel)
                }
                if showingGuessGame {
                    guessGame(showingGuessGame: $showingGuessGame, myGame: $myGame, showingGameWin: $showingGameWin, showingGameLose: $showingGameLose, myMap: myMap, showingTradeMessage: $showingTradeMessage, isTrading: $isTrading, showingBankruptMessage: $showingBankruptMessage)
                }
                if showingGameWin {
                    addMoney(showingGainToll: $showingGameWin, text: "獲得獎金", money: 200000)
                }
                if showingGameLose {
                    subMoney(showingPayToll: $showingGameLose, text: "賠", money: 200000)
                }
                if showingDoubleMessage {
                    message(showingMessage: $showingDoubleMessage, text: "可再擲一次")
                }
                if showingTakeABreak {
                    takeABreak(showingTakeABreak: $showingTakeABreak)
                }
                if showingTax {
                    subMoney(showingPayToll: $showingTax, text: "徵稅", money: tax)
                }
                if showingTradeMessage {
                    message(showingMessage: $showingTradeMessage, text: "選擇要賣的房地產")
                }
                if showingBankruptMessage {
                    message(showingMessage: $showingBankruptMessage, text: "破產")
                }
            }
            Group {
                if showingTradeSuccess {
                    addMoney(showingGainToll: $showingTradeSuccess, text: "交易成功", money: tradeGainedMoney)
                }
                if showingNoDestinationMessage {
                    message(showingMessage: $showingNoDestinationMessage, text: "沒有可旅行的地點")
                }
                if showingWinner {
                    winner(showingWinner: $showingWinner, turn: checkWinner(), myGame: $myGame, showGamePage: $showGamePage, showHomePage: $showHomePage)
                }
                if showingGameOverMessage {
                    message(showingMessage: $showingGameOverMessage, text: "遊戲結束")
                }
                if showingGainChance {
                    message(showingMessage: $showingGainChance, text: "恭喜獲勝，獲得一條生命")
                        .offset(y:100)
                }
            }
        }
    }
    func checkWinner() -> Int {
        for player in myGame.players {
            if !player.bankrupt {
                return player.index
            }
        }
        return 0
    }
    func checkTravelDestination(selectedSingleTile: game.singleTile, position: Int) {
        print("selectedSingleTile.owner: \(selectedSingleTile.owner)")
        print("myGame.turn: \(myGame.turn)")
        if selectedSingleTile.owner == -1 || selectedSingleTile.owner == myGame.turn {
            //position check level:buy or turn
            setGameLastEditedPositionRecord(gameId:myGame.invatationCode, lastEditedPositionRecord: game.editedPositionRecord(index: myGame.turn, newPosition: position))
            setGameGo(gameId:myGame.invatationCode, go:true)
            if  selectedSingleTile.level < 2 {  //可買、可升級
                showTileInforViewIndex = position
                showTileInforView = true
            }else{
                if myGame.next {
                    checkAndSetGameTurn()
                }
            }
            isTravel = false
        }else{
            //alert未開放此地旅遊，再選一次
            showingNotAllowedTravelDestinationAlert = true
        }
    }
    func checkTileOwner(selectedSingleTile: game.singleTile, index: Int){
        if selectedSingleTile.owner == myGame.players[myGame.turn].index {
            //與銀行交易
            setTileLevelOwner(gameId: myGame.invatationCode, myTile: game.simpleSingleTile(index: index, level: 0, owner: -1))
            if selectedSingleTile.level == 2 {
                tradeGainedMoney = (selectedSingleTile.price[0] + selectedSingleTile.price[1]) / 2
                setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[myGame.turn], money: myGame.players[myGame.turn].money + (selectedSingleTile.price[0] + selectedSingleTile.price[1]) / 2)
            }else{
                tradeGainedMoney = selectedSingleTile.price[0] / 2
                setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[myGame.turn], money: myGame.players[myGame.turn].money + selectedSingleTile.price[0] / 2)
            }
            setGameTrade(gameId: myGame.invatationCode, trade: true)
            showingTradeSuccess = true
        }else {
            //不是你的財產
            showingNotOwnerAlert = true
        }
    }
    func checkMoneyNegative() -> Int{
        print("money: \(myGame.players[myGame.turn].money)")
        if myGame.players[myGame.turn].money < 0 {
            //檢查是否有房地產
            if checkOwnerDestinationCount() {
                showingTradeMessage = true
                isTrading = true
            }else {
                let tempTurn = myGame.turn
                showingBankruptMessage = true
                if checkGameOver() {  //剩一人，遊戲結束
                    print("遊戲結束")
                    setGameOver(gameId: myGame.invatationCode, over: true, myPlayer: myGame.players[tempTurn])
                    
                }else {
                    //破產
                    setPlayerBankrupt(gameId: myGame.invatationCode, myPlayer: myGame.players[tempTurn], bankrupt: true)
                }
                print("return 1")
                return 1
            }
            print("return 2")
            return 2
        }else{
            print("return 3")
            return 3
        }
    }
    func checkLoop() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let temp = checkMoneyNegative()
            if temp == 3 || temp == 1 {
                print("break")
                isTrading = false
                
                if temp == 3 {
                    if myGame.next {
                        checkAndSetGameTurn()
                    }
                }else {
                    checkAndSetGameTurn()
                    if myGame.next {
                        setGameNext(gameId: myGame.invatationCode, next: true)
                    }
                }
                timer.invalidate()
            }
        }
    }
    func checkAndSetGameTurn(){
        var tempTurn = myGame.turn
        repeat {
            if tempTurn+1 >= myGame.players.count {
                tempTurn = 0
            }else{
                tempTurn = tempTurn + 1
            }
        }while myGame.players[tempTurn].bankrupt;
        setGameTurn(gameId: myGame.invatationCode, turn: tempTurn)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            if inJail {
                firstShowingJailAlert = true
            }
        })
    }
    func checkOwnerDestinationCount() -> Bool {
        var count = 0
        for tile in myMap {
            if tile.owner == myGame.turn {
                count += 1
            }
        }
        return count > 0 ? true : false
    }
    func checkGameOver() -> Bool {
        var count = 0
        for player in myGame.players {
            if player.bankrupt {
                count += 1
            }
        }
        return count + 2 >= myGame.playerNum  ? true : false
    }
}

