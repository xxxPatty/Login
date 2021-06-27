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
    @Binding var showingJailAnimation: Bool
    @Binding var showingJailAlert: Bool
    @Binding var firstShowingJailAlert: Bool
    @Binding var showingTravel: Bool
    @Binding var isTravel: Bool
    @Binding var showingGuessGame: Bool
    @Binding var showingTakeABreak: Bool
    @Binding var showingTax: Bool
    @Binding var tax: Int
    @Binding var showingTradeMessage: Bool
    @Binding var isTrading: Bool
    @Binding var showingBankruptMessage: Bool
    @Binding var inJail: Bool
    @Binding var showingNoDestinationMessage: Bool
    @Binding var showingGameOverMessage: Bool
    @Binding var showingWinner: Bool
    @Binding var end: Bool
    @Binding var chance: Int
    @Binding var showingGainChance: Bool
    let myUserDetail: UserDetail
    let colors: [Color] = [Color(red:242/255,green:145/255 ,blue:145/255), Color(red:148/255,green:208/255 ,blue:204/255), Color(red:121/255,green:82/255 ,blue:179/255), Color(red:255/255,green:193/255 ,blue:7/255)]
    let colors2: [Color] = [Color.pink, Color.green, Color.purple, Color.yellow]
    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    if myGame.players.count == 1 {
                        deleteGame(gameId: myGame.invatationCode)
                    }else{
                        //改hostId
                        setGameHostId(gameId: myGame.hostId, hostId: myGame.players[1].id)
                    }
                    setGamePlayerNum(gameId: myGame.invatationCode, num: myGame.playerNum - 1)
                    removePlayer(gameId: myGame.invatationCode, myPlayer: myGame.players[myTurn])
                    showGameWaitPage=false
                    showHomePage=true
                    end = true  //remove listener
                }){
                    Image(systemName:"arrow.left.square.fill")
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(myGame.map == 0 ? "airplane" : "covid virus")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                Spacer()
                Text("大廳")
                Text("房間編號: \(myGame.invatationCode)")
            }
            //.background(Color.yellow)
            HStack{
                //Player1
                VStack{
                    if myGame.players.count >= 1 {
                        Text("玩家 1")
                        Text("\(myGame.players[0].name)")
                            .shadow(color: myGame.players[0].id == myUserDetail.id ? colors2[0] : .clear, radius: 10)
                        Image("\(myGame.players[0].figure)")
                            .colorMultiply(colors[0])
                            .shadow(color: myGame.players[0].id == myUserDetail.id ? colors2[0] : .clear, radius: 10)
                    }
                }
                .frame(width:200, height:200)
                .background(colors2[0].opacity(0.3))
                .cornerRadius(10)
                
                //Player2
                VStack{
                    Text("玩家 2")
                    if myGame.players.count >= 2 {
                        Text("\(myGame.players[1].name)")
                            .shadow(color: myGame.players[1].id == myUserDetail.id ? colors2[1] : .clear, radius: 10)
                        Image("\(myGame.players[1].figure)")
                            .colorMultiply(colors[1])
                            .shadow(color: myGame.players[1].id == myUserDetail.id ? colors2[1] : .clear, radius: 10)
                    }
                }
                .frame(width:200, height:200)
                .background(colors2[1].opacity(0.3))
                .cornerRadius(10)
                
                //Player3
                VStack{
                    Text("玩家 3")
                    if myGame.players.count >= 3 {
                        Text("\(myGame.players[2].name)")
                            .shadow(color: myGame.players[2].id == myUserDetail.id ? colors2[2] : .clear, radius: 10)
                        Image("\(myGame.players[2].figure)")
                            .colorMultiply(colors[2])
                            .shadow(color: myGame.players[2].id == myUserDetail.id ? colors2[2] : .clear, radius: 10)
                    }
                }
                .frame(width:200, height:200)
                .background(colors2[2].opacity(0.3))
                .cornerRadius(10)
                
                //Player4
                VStack{
                    Text("玩家 4")
                    if myGame.players.count >= 4 {
                        Text("\(myGame.players[3].name)")
                            .shadow(color: myGame.players[3].id == myUserDetail.id ? colors2[3] : .clear, radius: 10)
                        Image("\(myGame.players[3].figure)")
                            .colorMultiply(colors[3])
                            .shadow(color: myGame.players[3].id == myUserDetail.id ? colors2[3] : .clear, radius: 10)
                    }
                }
                .frame(width:200, height:200)
                .background(colors2[3].opacity(0.3))
                .cornerRadius(10)
            }
            .padding()
            if myGame.hostId == myUserDetail.id {
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
            fetchGameImmediate(gameId: myGame.invatationCode, end: end) { result in
                switch result {
                case .success(let updatedGame):
                    //每次變動都會執行
                    if !end {
                        myGame = updatedGame
                        myGame.players.sort(by: {$0.index < $1.index})
                    }
                    
                    if myGame.over {
                        if !end {
                            print("reomve listener")
                            showingGameOverMessage = true
                            showingWinner = true
                            //1. update userDetails +chance 2. update ranking -> winner do
                            let winnerIndex = checkWinner()
                            if myGame.players[winnerIndex].id == myUserDetail.id {
                                showingGainChance = true
                                if chance < 3 {
                                    setUserChance(userId:myUserDetail.id!, chance:chance+1)
                                }
                                addRankingRecord(ranking: Ranks.Rank(name:getUserName(), money:myGame.players[winnerIndex].money, id:myUserDetail.id!, time:Date()))
                                deleteGame(gameId: myGame.invatationCode)
                                if myGame.players[winnerIndex].money > myUserDetail.bestRecord {
                                    setUserWinBestRecord(userId:myUserDetail.id!, bestRecord: myUserDetail.bestRecord)
                                }else{
                                    setUserWinRecord(userId: myUserDetail.id!)
                                }
                            }else{
                                setUserLoseRecord(userId: myUserDetail.id!)
                            }
                            end = true
                        }
                    }
                    
                    if myGame.start {
                        showGameWaitPage = false
                        showGamePage = true
                        if myGame.move {    //移動
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
                                        if myGame.players[tempTurn2].id == myUserDetail.id {
                                        //會有loop嗎？？？？？？？？？？？？？？？？？有.........
                                            print("position: \(position[tempTurn2])")
                                            if (position[tempTurn2] == 1 || position[tempTurn2] == 2  || position[tempTurn2] == 3 || position[tempTurn2] == 5 || position[tempTurn2] == 7 || position[tempTurn2] == 9 || position[tempTurn2] == 10 || position[tempTurn2] == 11 || position[tempTurn2] == 13 || position[tempTurn2] == 15) {
                                                if myMap[position[tempTurn2]].owner == -1 || myMap[position[tempTurn2]].owner == myGame.players[tempTurn2].index {
                                                    //沒人或自己的土地且沒房子，可買、可升級
                                                    if myMap[position[tempTurn2]].level < 2 {
                                                        showTileInforViewIndex = position[tempTurn2]
                                                        showTileInforView = true
                                                    }else{
                                                        if myGame.next {
                                                            checkAndSetGameTurn()
                                                        }
                                                    }
                                                }else {  //有人的地，付過路費
                                                    let index = position[tempTurn2]
                                                    toll = myMap[index].tolls[myMap[index].level-1]
                                                    print("myGame.players.count3: \(myGame.players.count)")
                                                    if myGame.players.count == myGame.playerNum {
//                                                        if myGame.players[tempTurn2].money >= toll {
                                                        //扣錢
                                                        print("myGame.turn: \(myGame.turn)")
                                                        print("position[myGame.turn]: \(position[myGame.turn])")
                                                        print("position[myGame.turn]: \(position[myGame.turn])")
                                                        print("myMap[position[myGame.turn]].level: \(myMap[position[myGame.turn]].level)")
                                                        print("myMap[position[myGame.turn]].tolls[myMap[position[myGame.turn]].level-1]: \(myMap[position[myGame.turn]].tolls[myMap[position[myGame.turn]].level-1])")
                                                        
                                                        showingPayToll = true
                                                        setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[tempTurn2], money: myGame.players[tempTurn2].money - toll)
                                                        
                                                        checkLoop()
                                                        //幫地主加錢
                                                        setGainFineRecord(gameId: myGame.invatationCode, record: game.gainFineRecord(index: myMap[index].owner, toll: toll))
                                                        setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[myMap[index].owner], money: myGame.players[myMap[index].owner].money + toll)
                                                            setGameGain(gameId:myGame.invatationCode, gain:true)
                                                    }
                                                }
                                            }else{
                                                if(position[tempTurn2]==4){ //監獄
                                                    firstShowingJailAlert = false
                                                    if myGame.next {
                                                        if myGame.players.count == myGame.playerNum {
                                                            if myGame.players[myGame.turn].id == myUserDetail.id {
                                                                checkAndSetGameTurn()
                                                            }
                                                        }
                                                    }
                                                    inJail = true
                                                    setPlayerInJail(gameId: myGame.invatationCode, myPlayer: myGame.players[tempTurn2], inJail: true)
                                                    showingJailAnimation = true
                                                }else if(position[tempTurn2]==6){   //game
                                                    showingGuessGame = true
                                                }else if(position[tempTurn2]==8){   //break
                                                    showingTakeABreak = true
                                                }else if(position[tempTurn2]==12){   //travel
                                                    if checkOwnerDestinationCount() || checkEmptyDestinationCount() {
                                                        showingTravel = true
                                                        isTravel = true
                                                    }else {
                                                        //No destination
                                                        showingNoDestinationMessage = true
                                                        checkAndSetGameTurn()
                                                    }
                                                }else if(position[tempTurn2]==14){   //fine
                                                    tax = myMap[14].tolls[Int.random(in: 0...1)]
                                                    setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[tempTurn2], money: myGame.players[tempTurn2].money - tax)
                                                    showingTax = true
                                                    checkLoop()
                                                }
                                                if myGame.next && position[tempTurn2] != 4 && position[tempTurn2] != 12 && position[tempTurn2] != 6 && position[tempTurn2] != 14 {
                                                    if myGame.players.count == myGame.playerNum {
                                                        if myGame.players[myGame.turn].id == myUserDetail.id {
                                                            checkAndSetGameTurn()
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
                                    withAnimation(.easeInOut(duration: 0.5)){
                                        offsetx[tempTurn2] -= 55
                                        offsety[tempTurn2] -= 30
                                    }
                                }else if position[tempTurn2] < 8 {
                                    withAnimation(.easeInOut(duration: 0.5)){
                                    offsetx[tempTurn2] += 55
                                    offsety[tempTurn2] -= 30
                                    }
                                }else if position[tempTurn2] < 12 {
                                    withAnimation(.easeInOut(duration: 0.5)){
                                    offsetx[tempTurn2] += 55
                                    offsety[tempTurn2] += 30
                                    }
                                }else {
                                    withAnimation(.easeInOut(duration: 0.5)){
                                    offsetx[tempTurn2] -= 55
                                    offsety[tempTurn2] += 30
                                    }
                                }
                                position[tempTurn2] += 1
                                if position[tempTurn2] >= 16 { //  過一圈，領薪水
                                    position[tempTurn2] = 0
                                    print("myGame.players.count: \(myGame.players.count)")
                                    if myGame.players.count == myGame.playerNum {
                                        if myGame.players[tempTurn2].id == myUserDetail.id {
                                            setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[tempTurn2], money: myGame.players[tempTurn2].money + 100000)
                                            showingGainSalary = true
                                        }
                                    }
                                }
                            }
                        }
                        //買房中
                        if myGame.buy {
                            //更新畫面（買房、買地）, setGameTurn
                            myMap[myGame.lastEditedTiles.index].level = myGame.lastEditedTiles.level
                            myMap[myGame.lastEditedTiles.index].owner = myGame.lastEditedTiles.owner
                            if myGame.players[myGame.turn].id == myUserDetail.id {
                                setGameBuy(gameId: myGame.invatationCode, buy: false)
                                if myGame.next {
                                    if myGame.players.count == myGame.playerNum {
                                        checkAndSetGameTurn()
                                    }
                                }
                            }
                        }
                        //交易中
                        if myGame.trade {
                            //更新畫面（房、地）
                            myMap[myGame.lastEditedTiles.index].level = myGame.lastEditedTiles.level
                            myMap[myGame.lastEditedTiles.index].owner = myGame.lastEditedTiles.owner
                        }
                        if myGame.gain {
                            print("myGame.players.count2: \(myGame.players.count)")
                            if myGame.players.count == myGame.playerNum {
                                if myGame.players[myGame.lastGainFineRecord.index].id == myUserDetail.id {
                                    setGameGain(gameId:myGame.invatationCode, gain:false)
                                    showingGainToll = true
                                }
                            }
                        }
                        //alert出獄方式
                        if myGame.players.count == myGame.playerNum {
                            if firstShowingJailAlert && myGame.players[myGame.turn].id == myUserDetail.id && myGame.players[myGame.turn].inJail {
                                print("alert出獄方式")
                                showingJailAlert = true
                                firstShowingJailAlert = false
                            }
                        }
                        //直接移動到某position
                        if myGame.go {
                            position[myGame.lastEditedPositionRecord.index] = myGame.lastEditedPositionRecord.newPosition
                            //!!!!!!!!!!!!設定offset
                            setOffset(playerIndex: myGame.lastEditedPositionRecord.index, newPosition: myGame.lastEditedPositionRecord.newPosition)
                            if myGame.players.count == myGame.playerNum {
                                if myGame.players[myGame.turn].id == myUserDetail.id {
                                    setGameGo(gameId:myGame.invatationCode, go:false)
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
    func setOffset(playerIndex: Int, newPosition: Int) {
        if newPosition < 4 {
            if playerIndex == 0 {
                withAnimation{
                offsetx[0] = (-55) * newPosition
                offsety[0] = (-30) * newPosition
                }
            }else if playerIndex == 1 {
                withAnimation{
                offsetx[1] = (-55) * newPosition
                offsety[1] = (-30) * newPosition
                }
            }else if playerIndex == 2 {
                withAnimation{
                offsetx[2] = (-55) * newPosition
                offsety[2] = (-30) * newPosition
                }
            }else if playerIndex == 3 {
                withAnimation{
                offsetx[3] = (-55) * newPosition
                offsety[3] = (-30) * newPosition
                }
            }
        }else if newPosition < 8 {
            if playerIndex == 0 {
                withAnimation{
                offsetx[0] = (-55) * 4 + 55 * (newPosition - 4)
                offsety[0] = (-30) * 4 + (-30) * (newPosition - 4)
                }
            }else if playerIndex == 1 {
                withAnimation{
                offsetx[1] = (-55) * 4 + 55 * (newPosition - 4)
                offsety[1] = (-30) * 4 + (-30) * (newPosition - 4)
                }
            }else if playerIndex == 2 {
                withAnimation{
                offsetx[2] = (-55) * 4 + 55 * (newPosition - 4)
                offsety[2] = (-30) * 4 + (-30) * (newPosition - 4)
                }
            }else if playerIndex == 3 {
                withAnimation{
                offsetx[3] = (-55) * 4 + 55 * (newPosition - 4)
                offsety[3] = (-30) * 4 + (-30) * (newPosition - 4)
                }
            }
        }else if newPosition < 12 {
            if playerIndex == 0 {
                withAnimation{
                offsetx[0] = (-55) * 4 + 55 * 4 + 55 * (newPosition - 8)
                offsety[0] = (-30) * 4 + (-30) * 4 + 30 * (newPosition - 8)
                }
            }else if playerIndex == 1 {
                withAnimation{
                offsetx[1] = (-55) * 4 + 55 * 4 + 55 * (newPosition - 8)
                offsety[1] = (-30) * 4 + (-30) * 4 + 30 * (newPosition - 8)
                }
            }else if playerIndex == 2 {
                withAnimation{
                offsetx[2] = (-55) * 4 + 55 * 4 + 55 * (newPosition - 8)
                offsety[2] = (-30) * 4 + (-30) * 4 + 30 * (newPosition - 8)
                }
            }else if playerIndex == 3 {
                withAnimation{
                offsetx[3] = (-55) * 4 + 55 * 4 + 55 * (newPosition - 8)
                offsety[3] = (-30) * 4 + (-30) * 4 + 30 * (newPosition - 8)
                }
            }
        }else {
            if playerIndex == 0 {
                withAnimation{
                offsetx[0] = (-55) * 4 + 55 * 4 + 55 * 4 + (-55) * (newPosition - 12)
                offsety[0] = (-30) * 4 + (-30) * 4 + 30 * 4 + 30 * (newPosition - 12)
                }
            }else if playerIndex == 1 {
                withAnimation{
                offsetx[1] = (-55) * 4 + 55 * 4 + 55 * 4 + (-55) * (newPosition - 12)
                offsety[1] = (-30) * 4 + (-30) * 4 + 30 * 4 + 30 * (newPosition - 12)
                }
            }else if playerIndex == 2 {
                withAnimation{
                offsetx[2] = (-55) * 4 + 55 * 4 + 55 * 4 + (-55) * (newPosition - 12)
                offsety[2] = (-30) * 4 + (-30) * 4 + 30 * 4 + 30 * (newPosition - 12)
                }
            }else if playerIndex == 3 {
                withAnimation{
                offsetx[3] = (-55) * 4 + 55 * 4 + 55 * 4 + (-55) * (newPosition - 12)
                offsety[3] = (-30) * 4 + (-30) * 4 + 30 * 4 + 30 * (newPosition - 12)
                }
            }
        }
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
    func checkEmptyDestinationCount() -> Bool {
        var count = 0
        for tile in myMap {
            if tile.owner == -1 {
                count += 1
            }
        }
        return count > 0 ? true : false
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
                return 1    //bankrupt
            }
            print("return 2")
            return 2    //trade
        }else{
            print("return 3")
            return 3    //other
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
    func checkGameOver() -> Bool {
        var count = 0
        for player in myGame.players {
            if player.bankrupt {
                count += 1
            }
        }
        return count + 2 >= myGame.playerNum  ? true : false
    }
    func checkWinner() -> Int {
        for player in myGame.players {
            if !player.bankrupt {
                return player.index
            }
        }
        return 0
    }
}

