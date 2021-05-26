//
//  GameWaitPage.swift
//  Login
//
//  Created by 林湘羚 on 2021/5/11.
//

import SwiftUI


struct GameWaitPage: View {
    @Binding var myGame: game   //退出的話會變動
    @Binding var showHomePage: Bool
    @Binding var showGameWaitPage: Bool
    @Binding var myTurn: Int
    @Binding var showGamePage: Bool
    @Binding var offsetx: [Int]
    @Binding var offsety: [Int]
    @Binding var position: [Int]
    @Binding var showTileInforView: Bool
    @Binding var showTileInforViewIndex: Int
    @Binding var myMap: [game.singleTile]
    @Binding var showingPayToll: Bool
    @Binding var showingGainToll: Bool
    @Binding var showingGainSalary: Bool
    @Binding var toll: Int
    let map1: [game.singleTile]
    let map2: [game.singleTile]
    let colors: [Color] = [Color(red:242/255,green:145/255 ,blue:145/255), Color(red:148/255,green:208/255 ,blue:204/255), Color(red:236/255,green:196/255 ,blue:163/245), Color(red:237/255,green:255/255 ,blue:169/255)]
    let colors2: [Color] = [Color.pink, Color.green, Color.purple, Color.yellow]
    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    if myGame.players.count == 1 {
                        deleteGame(gameId: myGame.invatationCode)
                    }else{
                        //改hostId
                        setGameHostId(gameId: myGame.hostId, hostId: myGame.players[1].userId)
                    }
                    removePlayer(gameId: myGame.invatationCode, myPlayer: myGame.players[myTurn])
                    showGameWaitPage=false
                    showHomePage=true
                }){
                    //Text("退出")
                    Image(systemName:"arrow.left.square.fill")
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(myGame.map == 0 ? "airplane" : "covid virus")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                Spacer()
                Text("Lobby")
                Text("Room code: \(myGame.invatationCode)")
            }
            //.background(Color.yellow)
            HStack{
                //Player1
                VStack{
                    if myGame.players.count >= 1 {
                        Text("Player1")
                        Text("\(myGame.players[0].name)")
                            .shadow(color: myGame.players[0].userId == getUserId() ? colors2[0] : .clear, radius: 10)
                        Image("\(myGame.players[0].figure)")
                            .colorMultiply(colors[0])
                            .shadow(color: myGame.players[0].userId == getUserId() ? colors2[0] : .clear, radius: 10)
                    }
                }
                .frame(width:200, height:200)
                .background(colors2[0].opacity(0.3))
                .cornerRadius(10)
                
                //Player2
                VStack{
                    Text("Player2")
                    if myGame.players.count >= 2 {
                        Text("\(myGame.players[1].name)")
                            .shadow(color: myGame.players[1].userId == getUserId() ? colors2[1] : .clear, radius: 10)
                        Image("\(myGame.players[1].figure)")
                            .colorMultiply(colors[1])
                            .shadow(color: myGame.players[1].userId == getUserId() ? colors2[1] : .clear, radius: 10)
                    }
                }
                .frame(width:200, height:200)
                .background(colors2[1].opacity(0.3))
                .cornerRadius(10)
                
                //Player3
                VStack{
                    Text("Player3")
                    if myGame.players.count >= 3 {
                        Text("\(myGame.players[2].name)")
                            .shadow(color: myGame.players[2].userId == getUserId() ? colors2[2] : .clear, radius: 10)
                        Image("\(myGame.players[2].figure)")
                            .colorMultiply(colors[2])
                            .shadow(color: myGame.players[2].userId == getUserId() ? colors2[2] : .clear, radius: 10)
                    }
                }
                .frame(width:200, height:200)
                .background(colors2[2].opacity(0.3))
                .cornerRadius(10)
                
                //Player4
                VStack{
                    Text("Player4")
                    if myGame.players.count >= 4 {
                        Text("\(myGame.players[3].name)")
                            .shadow(color: myGame.players[3].userId == getUserId() ? colors2[3] : .clear, radius: 10)
                        Image("\(myGame.players[3].figure)")
                            .colorMultiply(colors[3])
                            .shadow(color: myGame.players[3].userId == getUserId() ? colors2[3] : .clear, radius: 10)
                    }
                }
                .frame(width:200, height:200)
                .background(colors2[3].opacity(0.3))
                .cornerRadius(10)
            }
            .padding()
            if myGame.hostId == getUserId() {
                Button(action:{
                    setGameStart(gameId: myGame.invatationCode, start: true)
                }){
                    Text("開始遊戲")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                        .padding()
                        .padding(.horizontal, 25)
                        .background(Capsule().fill(Color.yellow))
                        .shadow(color: .gray, radius: 5)
                }
            }
        }
        .onAppear {
            //隨時更新等候室，裡面不能改firebase上的資料，不然會陷入迴圈！！一直重複執行
            fetchGameImmediate(gameId: myGame.invatationCode) { result in
                switch result {
                case .success(let updatedGame):
                    //每次變動都會執行
                    myGame = updatedGame
                    myGame.players.sort(by: {$0.index < $1.index})
                    if myGame.start {   //移動
                        showGameWaitPage = false
                        showGamePage = true
                        if myGame.move {
                            //移動棋子
//                            let tempTurn = myGame.players.count - 1
                            let tempTurn2 = myGame.turn
//                            print("dicePoint: \(myGame.players[tempTurn].dicePoint)")
                            var i = myGame.players[tempTurn2].dicePoint
                            setGameMove(gameId:myGame.invatationCode, move:false)
                            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                                if i==0 {
                                    timer.invalidate()
                                    //如果是自己
//                                    print("tempTurn2: \(tempTurn2)")
                                    if myGame.players.count == myGame.playerNum {
                                        if myGame.players[tempTurn2].userId == getUserId() {
                                        //會有loop嗎？？？？？？？？？？？？？？？？？有.........
                                            print("position: \(position[tempTurn2])")
                                            if (position[tempTurn2] == 1 || position[tempTurn2] == 2  || position[tempTurn2] == 3 || position[tempTurn2] == 5 || position[tempTurn2] == 7 || position[tempTurn2] == 9 || position[tempTurn2] == 10 || position[tempTurn2] == 11 || position[tempTurn2] == 13 || position[tempTurn2] == 15) {
                                                if myMap[position[tempTurn2]].owner == -1 || myMap[position[tempTurn2]].owner == myGame.players[tempTurn2].index {  //沒人或自己的土地，可買、可升級
                                                    showTileInforViewIndex = position[tempTurn2]
                                                    showTileInforView = true
                                                }else {  //有人的地，付過路費
                                                    let index = position[tempTurn2]
                                                    toll = myMap[index].tolls[myMap[index].level-1]
                                                    print("myGame.players.count3: \(myGame.players.count)")
                                                    if myGame.players.count == myGame.playerNum {
                                                        if myGame.players[tempTurn2].money >= toll {
                                                            //扣錢
                                                            print("myGame.turn: \(myGame.turn)")
                                                            print("position[myGame.turn]: \(position[myGame.turn])")
                                                            print("position[myGame.turn]: \(position[myGame.turn])")
                                                            print("myMap[position[myGame.turn]].level: \(myMap[position[myGame.turn]].level)")
                                                            print("myMap[position[myGame.turn]].tolls[myMap[position[myGame.turn]].level-1]: \(myMap[position[myGame.turn]].tolls[myMap[position[myGame.turn]].level-1])")
                                                            showingPayToll = true
                                                            setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[tempTurn2], money: myGame.players[tempTurn2].money - toll)
                                                            //幫地主加錢
                                                            setGainFineRecord(gameId: myGame.invatationCode, record: game.gainFineRecord(index: myMap[index].owner, toll: toll))
                                                            setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[myMap[index].owner], money: myGame.players[myMap[index].owner].money + toll)
                                                            setGameGain(gameId:myGame.invatationCode, gain:true)
                                                        } else {
                                                            //破產
    //                                                       showBankrupt = true
                                                        }
                                                    }
                                                    if myGame.next {
                                                        if myGame.turn+1 >= myGame.players.count {
                                                            setGameTurn(gameId: myGame.invatationCode, turn: 0)
                                                        }else{
                                                            setGameTurn(gameId: myGame.invatationCode, turn: myGame.turn+1)
                                                        }
                                                    }
                                                }
                                            }else{
                                                if myGame.next {
                                                    if myGame.players.count == myGame.playerNum {
                                                        if myGame.players[myGame.turn].userId == getUserId() {
                                                            if myGame.turn+1 >= myGame.players.count {
                                                                setGameTurn(gameId: myGame.invatationCode, turn: 0)
                                                            }else{
                                                                setGameTurn(gameId: myGame.invatationCode, turn: myGame.turn+1)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    return
                                }
                                i -= 1
                                if position[tempTurn2] < 4 {
                                    offsetx[tempTurn2] -= 55
                                    offsety[tempTurn2] -= 30
                                }else if position[tempTurn2] < 8 {
                                    offsetx[tempTurn2] += 55
                                    offsety[tempTurn2] -= 30
                                }else if position[tempTurn2] < 12 {
                                    offsetx[tempTurn2] += 55
                                    offsety[tempTurn2] += 30
                                }else {
                                    offsetx[tempTurn2] -= 55
                                    offsety[tempTurn2] += 30
                                }
                                position[tempTurn2] += 1
                                if position[tempTurn2] >= 16 { //  過一圈，領薪水
                                    position[tempTurn2] = 0
                                    print("myGame.players.count: \(myGame.players.count)")
                                    if myGame.players.count == myGame.playerNum {
                                        if myGame.players[tempTurn2].userId == getUserId() {
                                            setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[tempTurn2], money: myGame.players[tempTurn2].money + 100000)
                                            showingGainSalary = true
                                        }
                                    }
                                }
                            }
                        }
                        //買房中
                        if myGame.buy {
                            //更新畫面（買房、買）, setGameTurn
                            myMap[myGame.lastEditedTiles.index].level = myGame.lastEditedTiles.level
                            myMap[myGame.lastEditedTiles.index].owner = myGame.lastEditedTiles.owner
                            if myGame.players[myGame.turn].userId == getUserId() {
                                setGameBuy(gameId: myGame.invatationCode, buy: false)
                                if myGame.next {
                                    if myGame.players.count == myGame.playerNum {
                                        if myGame.turn+1 >= myGame.players.count {
                                            setGameTurn(gameId: myGame.invatationCode, turn: 0)
                                        }else{
                                            setGameTurn(gameId: myGame.invatationCode, turn: myGame.turn+1)
                                        }
                                    }
                                }
                            }
                        }
                        if myGame.gain {
                            print("myGame.players.count2: \(myGame.players.count)")
                            if myGame.players[myGame.lastGainFineRecord.index].userId == getUserId() {
                                if myGame.players.count == myGame.playerNum {
                                    setGameGain(gameId:myGame.invatationCode, gain:false)
                                    showingGainToll = true
                                }
                            }
                        }
                    }else{
                        if myGame.map == 0{
                            myMap = map1
                        }else{
                            myMap = map2
                        }
                    }
                    
                case .failure(let error):
                    break
                }
            }
        }
    }
}

