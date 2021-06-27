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
            VStack(spacing: 10){
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
                        //買 or 付過路費
                        if singleTileInfor.level == 0 { //買地
                            //設定level, owner, player tile(property), player money
                            //有必要存player tile(property)嗎
                            if myGame.players[myGame.turn].money >= singleTileInfor.price[0] {
                                show=false
                                setTileLevelOwner(gameId: myGame.invatationCode, myTile: game.simpleSingleTile(index: showTileInforViewIndex, level: 1, owner: myGame.turn))
                                setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[myGame.turn], money: myGame.players[myGame.turn].money - singleTileInfor.price[0])
                                setGameBuy(gameId: myGame.invatationCode, buy: true)
                            }else{
                                //alert💰不夠
                                showingMoneyNotEnoughAlert = true
                            }
                        }else if singleTileInfor.level == 1 {
                            if myGame.players[myGame.turn].money >= singleTileInfor.price[1] {
                                show=false
                                setTileLevelOwner(gameId: myGame.invatationCode, myTile: game.simpleSingleTile(index: showTileInforViewIndex, level: 2, owner: myGame.turn))
                                setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[myGame.turn], money: myGame.players[myGame.turn].money - singleTileInfor.price[1])
                                setGameBuy(gameId: myGame.invatationCode, buy: true)
                            }else{
                                //alert💰不夠
                                showingMoneyNotEnoughAlert = true
                            }
                        }
                    }){
                        Text("買")
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
                        if myGame.next {
                            checkAndSetGameTurn()
                        }
//                        setGameBuy(gameId: myGame.invatationCode, buy: true)
                    }){
                        Text("不買")
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
                    if myGame.next {
                        checkAndSetGameTurn()
                    }
//                    setGameBuy(gameId: myGame.invatationCode, buy: true)
                }
            }){
                Image(systemName: "xmark.circle")
                    .font(.system(size: 20, weight: .bold))
            }
            .padding()
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
            print("tempTurn: \(tempTurn)")
        }while myGame.players[tempTurn].bankrupt;
        print("break")
        setGameTurn(gameId: myGame.invatationCode, turn: tempTurn)
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
    var turn: Int
    var name: String
    var bankrupt: Bool
    let isSelf: Bool
    let colors: [Color] = [Color(red:242/255,green:145/255 ,blue:145/255), Color(red:148/255,green:208/255 ,blue:204/255), Color(red:121/255,green:82/255 ,blue:179/255), Color(red:255/255,green:193/255 ,blue:7/255)]
    var body: some View {
        ZStack(alignment: .topLeading){
            if isSelf {
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
            }
            HStack{
                Image(systemName: !bankrupt ? "\(turn+1).circle" : "xmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                Image(imgStr)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
                    .colorMultiply(colors[turn])
                VStack{
                    Text("\(name)")
                        .fontWeight(.bold)
                    Text("\(money)")
                        .fontWeight(.bold)
                }
            }
        }
    }
}

//扣錢
struct subMoney: View {
    @Binding var showingPayToll: Bool
    let text: String
    let money: Int
    var body: some View {
        VStack{
            Image("money")
                .resizable()
                .frame(width: 100, height: 100)
            Text("\(text) \(money)")
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

//加錢
struct addMoney: View {
    @Binding var showingGainToll: Bool
    let text: String
    let money: Int
    var body: some View {
        VStack{
            Image("money")
                .resizable()
                .frame(width: 100, height: 100)
            Text("\(text) \(money)")
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


//入獄
struct goToJail: View {
    @Binding var showingJailAnimation: Bool
    @State var prisonerOffsetX: Int = 100
    var body: some View {
        VStack{
            Image("jail")
                .resizable()
                .frame(width: 200, height: 200)
            Image("prisoner")
                .resizable()
                .scaledToFit()
                .frame(height: 60)
                .offset(x:CGFloat(prisonerOffsetX), y:-100)
        }
        .transition(.scale)
        .onAppear(perform: {
            withAnimation(.easeInOut(duration: 1.5)) { prisonerOffsetX = 0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.showingJailAnimation = false
            })
        })
    }
}

//成功 失敗出獄 double
struct message: View {
    @Binding var showingMessage: Bool
    let text: String
    @State private var scale: CGFloat = 1
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .scaleEffect(scale)
            .animation(.easeIn)
            .onAppear(perform: {
                withAnimation(.easeInOut(duration: 1.5)) { scale = 1.5 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.showingMessage = false
                })
            })
    }
}

//旅行
struct travel: View {
    @Binding var showingTravel: Bool
    @State var airplaneOffsetX: Int = 200
    @State var airplaneOffsetY: Int = 100
    @State private var scale: CGFloat = 1
    var body: some View {
        VStack{
            Text("選擇想旅遊的目的地")
                .font(.largeTitle)
                .scaleEffect(scale)
                .animation(.easeIn)
            Image("airplane2")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .offset(x:CGFloat(airplaneOffsetX), y:CGFloat(airplaneOffsetY))
        }
        .transition(.scale)
        .onAppear(perform: {
            withAnimation(.easeInOut(duration: 1.5)) { airplaneOffsetX = -200;  airplaneOffsetY = -100; scale = 1.5}
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.showingTravel = false
            })
        })
    }
}

//猜正反game
struct guessGame: View {
    @Binding var showingGuessGame: Bool
    @Binding var myGame: game
    @Binding var showingGameWin: Bool
    @Binding var showingGameLose: Bool
    let myMap: [game.singleTile]
    @Binding var showingTradeMessage: Bool
    @Binding var isTrading: Bool
    @Binding var showingBankruptMessage: Bool
    @State private var degrees = 0.0
    @State private var r = 1
    @State private var guess = 0
    @State private var showingNotGuessAlert = false
    @State private var checked = false
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            VStack(spacing: 25){
                Text("猜正反面")
                    .font(.largeTitle)
                Text(!checked ? "" : guess == r ? "恭喜答對" : "答錯")
                    .font(.largeTitle)
                Image(r == 1 ? "head" : "tail")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .rotation3DEffect(.degrees(degrees), axis: (x: 1, y: 1, z: 1))
                HStack {
                    Button(action:{
                        guess = 1
                        withAnimation(.easeInOut(duration: 1.5)) {
                            self.degrees += 360 * 3
                        }
                        r = Int.random(in: 1...2)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            checkAns()
                            checked = true
                        })
                    }){
                        Text("正面")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .background(Color.black)
                            .clipShape(Capsule())
                    }
                    Button(action:{
                        guess = 2
                        withAnimation(.easeInOut(duration: 1.5)) {
                            self.degrees += 360 * 3
                        }
                        r = Int.random(in: 1...2)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            checkAns()
                            checked = true
                        })
                    }){
                        Text("反面")
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
                if guess != 0 {
                    showingGuessGame=false
                }else{
                    showingNotGuessAlert = true
                }
            }){
                Image(systemName: "xmark.circle")
                    .font(.system(size: 20, weight: .bold))
            }
            .padding()
            .alert(isPresented: $showingNotGuessAlert) {
                Alert(title: Text("請猜一個選項"), message: Text(""), dismissButton: .default(Text("好吧")))
            }
        }
    }
    func checkAns(){
        if myGame.players.count == myGame.playerNum{
            if r == guess { //猜對
                showingGameWin = true
                setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[myGame.turn], money: myGame.players[myGame.turn].money + 200000)
                if myGame.next {
                    checkAndSetGameTurn()
                }
            }else { //猜錯
                showingGameLose = true
                setPlayerMoney(gameId: myGame.invatationCode, myPlayer: myGame.players[myGame.turn], money: myGame.players[myGame.turn].money - 200000)
                checkLoop()
            }
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
            print("tempTurn: \(tempTurn)")
        }while myGame.players[tempTurn].bankrupt;
        print("break")
        setGameTurn(gameId: myGame.invatationCode, turn: tempTurn)
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
    func checkOwnerDestinationCount() -> Bool {
        var count = 0
        for tile in myMap {
            if tile.owner == myGame.turn {
                count += 1
            }
        }
        return count > 0 ? true : false
    }
}

//take a break
struct takeABreak: View {
    @Binding var showingTakeABreak: Bool
    @State private var scale: CGFloat = 1
    var body: some View {
        VStack{
            Text("休息一回合")
                .font(.largeTitle)
                .scaleEffect(scale)
                .animation(.easeIn)
            Image("sloth")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .rotationEffect(Angle(degrees: 10))
                .animation(Animation.default.repeatForever(autoreverses: true))
        }
        .transition(.scale)
        .onAppear(perform: {
            withAnimation(.easeInOut(duration: 1.5)) { scale = 1.5}
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.showingTakeABreak = false
            })
        })
    }
}

struct winner: View {
    @Binding var showingWinner: Bool
    let turn: Int
    @Binding var myGame: game
    @Binding var showGamePage: Bool
    @Binding var showHomePage: Bool
    var body: some View {
        ZStack{
            EmitterLayerView()
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
                VStack(spacing: 25){
                    Text("恭喜玩家 \(turn+1) 成為地產大亨")
                        .font(.largeTitle)
                    Image("richman")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                }
                .padding(.vertical, 25)
                .padding(.horizontal, 30)
                .background(BlurView())
                .cornerRadius(25)
                
                Button(action:{
                    showingWinner = false
                    //reset game
                    myGame = game(map: 0, next: false, playerNum: 1, gain: false, buy: false, move: false, start: false, go: false, trade: false, over: false, players: [game.player(index:0, dicePoint: 0, id:"", name: "", money: 500000, figure: "robot1", inJail: false, jailNotDoubleCount: 0, bankrupt: false)], turn: 0, lastEditedTiles: game.simpleSingleTile(index:-1, level: 0, owner: -1), invatationCode: "", hostId: "", lastGainFineRecord: game.gainFineRecord(index: -1, toll: 0), lastEditedPositionRecord: game.editedPositionRecord(index: -1, newPosition: -1))
                    //回HomdePage
                    showGamePage = false
                    showHomePage = true
                }){
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 20, weight: .bold))
                }
                .padding()
            }
        }
    }
}

struct EmitterLayerView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        let snowEmitterCell = CAEmitterCell()
        let snowEmitterLayer = CAEmitterLayer()
        snowEmitterCell.contents = UIImage(named: "dollar1")?.cgImage
        snowEmitterCell.birthRate = 1
        snowEmitterCell.lifetime = 2
        snowEmitterCell.velocity = 100
        snowEmitterCell.lifetime = 20
        snowEmitterCell.yAcceleration = 30
        snowEmitterCell.scale = 0.5
        snowEmitterCell.scaleRange = 0.03
        snowEmitterCell.scaleSpeed = -0.02
        snowEmitterCell.spin = 0.5
        snowEmitterCell.spinRange = 1
        snowEmitterCell.emissionRange = CGFloat.pi
        
        let snowEmitterCell2 = CAEmitterCell()
        snowEmitterCell2.contents = UIImage(named: "dollar2")?.cgImage
        snowEmitterCell2.birthRate = 1
        snowEmitterCell2.lifetime = 2
        snowEmitterCell2.velocity = 100
        snowEmitterCell2.lifetime = 20
        snowEmitterCell2.yAcceleration = 30
        snowEmitterCell2.scale = 0.5
        snowEmitterCell2.scaleRange = 0.03
        snowEmitterCell2.scaleSpeed = -0.02
        snowEmitterCell2.spin = 0.5
        snowEmitterCell2.spinRange = 1
        snowEmitterCell2.emissionRange = CGFloat.pi
        
        snowEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2, y: -50)
        snowEmitterLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
        snowEmitterLayer.emitterShape = .line
        snowEmitterLayer.scale = 2
        snowEmitterLayer.birthRate = 2
        snowEmitterLayer.emitterCells = [snowEmitterCell, snowEmitterCell2]
        view.layer.addSublayer(snowEmitterLayer)

        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    typealias UIViewType = UIView
}
