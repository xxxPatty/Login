//
//  ContentView.swift
//  Login
//
//  Created by 林湘羚 on 2021/4/14.
//

import SwiftUI
import Firebase
import AppTrackingTransparency

struct ContentView: View {
    @State private var showLoginPage:Bool=true
    @State private var showRegisterPage:Bool=false
    @State private var showRolePage:Bool=false
    @State private var showUserProfilePage:Bool=false
    @State private var showHomePage:Bool=false
    @State private var userProfile:UIImage? = nil
    @State private var currentUser = Auth.auth().currentUser
    @State private var showCreateGamePage:Bool=false
    @State private var showJoinGamePage:Bool=false
    @State private var showGameWaitPage:Bool=false
    @State private var showGamePage:Bool=false
    @State private var myTurn: Int=0
    @State private var offsetx: [Int] = [0, 0, 0, 0]
    @State private var offsety: [Int] = [0, 0, 0, 0]
    @State private var position: [Int] = [0, 0, 0, 0]
    @State private var showTileInforView = false
    @State private var showTileInforViewIndex = 0
    @State private var myGame: game = game(map: 0, next: false, playerNum: 1, gain: false, buy: false, move: false, start: false, go: false, trade: false, over: false, players: [game.player(index:0, dicePoint: 0, id:"", name: "", money: 500000, figure: "robot1", inJail: false, jailNotDoubleCount: 0, bankrupt: false)], turn: 0, lastEditedTiles: game.simpleSingleTile(index:-1, level: 0, owner: -1), invatationCode: "", hostId: "", lastGainFineRecord: game.gainFineRecord(index: -1, toll: 0), lastEditedPositionRecord: game.editedPositionRecord(index: -1, newPosition: -1))
    //map1，level 1土地，level 2房子
    let map1=[
        game.singleTile(name: "start", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -2),
        game.singleTile(name: "taiwan", imgStr: "taiwanBuilding", level: 0, description: "台北101", price: [100000, 200000], tolls: [100000, 200000], owner: -1),
        game.singleTile(name: "japan", imgStr: "japanBuilding", level: 0, description: "", price: [100000, 200000], tolls: [100000, 200000], owner: -1),
        game.singleTile(name: "china", imgStr: "chinaBuilding", level: 0, description: "", price: [100000, 200000], tolls: [100000, 200000], owner: -1),
        game.singleTile(name: "jail", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -2),
        game.singleTile(name: "australia", imgStr: "australiaBuilding", level: 0, description: "", price: [100000, 200000], tolls: [100000, 200000], owner: -1),
        game.singleTile(name: "game", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -2),
        game.singleTile(name: "egypt", imgStr: "egyptBuilding", level: 0, description: "", price: [100000, 200000], tolls: [100000, 200000], owner: -1),
        game.singleTile(name: "break", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -2),
        game.singleTile(name: "france", imgStr: "franceBuilding", level: 0, description: "", price: [100000, 200000], tolls: [100000, 200000], owner: -1),
        game.singleTile(name: "england", imgStr: "englandBuilding", level: 0, description: "", price: [100000, 200000], tolls: [100000, 200000], owner: -1),
        game.singleTile(name: "italy", imgStr: "italyBuilding", level: 0, description: "", price: [100000, 200000], tolls: [100000, 200000], owner: -1),
        game.singleTile(name: "travel", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -2),
        game.singleTile(name: "america", imgStr: "americaBuilding", level: 0, description: "", price: [100000, 200000], tolls: [100000, 200000], owner: -1),
        game.singleTile(name: "fine", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [100000, 200000], owner: -2),
        game.singleTile(name: "mexico", imgStr: "mexicoBuilding", level: 0, description: "", price: [100000, 200000], tolls: [100000, 200000], owner: -1)]
    
    //map2，level 1土地，level 2房子
    let map2=[
        game.singleTile(name: "start", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -2),
        game.singleTile(name: "livingRoom", imgStr: "sofa", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "bedRoom", imgStr: "bed", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "diningRoom", imgStr: "diningTable", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "hospital", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -2),
        game.singleTile(name: "kitchen", imgStr: "refrigerator", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "game", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -2),
        game.singleTile(name: "studyRoom", imgStr: "book", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "backyard", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -2),
        game.singleTile(name: "bathRoom", imgStr: "bathtub", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "studio", imgStr: "computer", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "dressingRoom", imgStr: "cloth", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "market", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -2),
        game.singleTile(name: "parkingLot", imgStr: "car", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "fine", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [100000, 200000], owner: -2),
        game.singleTile(name: "toliet", imgStr: "chamberPot", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1)]
    @State private var myMap: [game.singleTile] = []
    @State private var showingPayToll: Bool = false
    @State private var showingGainToll: Bool = false
    @State private var showingGainSalary: Bool = false
    @State private var toll: Int = 0
    @State var myUserDetail = UserDetail(id: getUserId(), name:"", country: 0, birthday: Date(), gender: "男", chance: 3, start: Date(), photoURL:"", totalPlayingTimes:0, totalWins:0, bestRecord:0, messageBoard:"")
    @State private var showingJailAnimation: Bool = false
    @State private var showingJailAlert: Bool = false
    @State private var firstShowingJailAlert: Bool = false
    @State private var showingTravel: Bool = false
    @State private var isTravel: Bool = false
    @State private var showingGuessGame: Bool = false
    @State private var showingGameWin: Bool = false
    @State private var showingGameLose: Bool = false
    @State private var showingTakeABreak: Bool = false
    @State private var showingTax: Bool = false
    @State private var tax: Int = 0
    @State private var showingTradeMessage: Bool = false
    @State private var isTrading: Bool = false
    @State private var showingBankruptMessage: Bool = false
    @State private var showingMoneyNotEnoughMessage = false
    @State private var inJail: Bool = false
    @State private var showingNoDestinationMessage: Bool = false
    @State private var showingGameOverMessage: Bool = false
    @State private var showingWinner: Bool = false
    @State private var end: Bool = false
    @State private var showingGainChance: Bool = false
    @State private var showSettingPage: Bool = false
    @State private var rank: [Ranks.Rank] = []
    @State private var play = true
    @State private var myUserId: String = ""
    var body: some View {
        VStack{
            if showLoginPage {
                LoginPage(showLoginPage: $showLoginPage, showRegisterPage:$showRegisterPage, showUserProfilePage: $showUserProfilePage, userProfile:$userProfile, showHomePage:$showHomePage, myUserDetail: $myUserDetail, myUserId: $myUserId)
            }else if showRegisterPage{
                RegisterPage(showLoginPage:$showLoginPage, showRegisterPage:$showRegisterPage, showUserProfilePage: $showUserProfilePage, userProfile:$userProfile, showHomePage:$showHomePage)
            }else if showRolePage{
                RolePage(showRolePage:$showRolePage, showUserProfile:$showUserProfilePage, userProfile:$userProfile, myUserId:myUserId)
            } else if showUserProfilePage {
                UserProfilePage(showRolePage:$showRolePage, showUserProfilePage:$showUserProfilePage, userProfile:$userProfile, showLoginPage:$showLoginPage, showHomePage:$showHomePage, myUserDetail: $myUserDetail)
            } else if showHomePage {
                HomePage(showHomePage: $showHomePage, showRolePage: $showRolePage, showUserProfilePage: $showUserProfilePage, userProfile: $userProfile, showLoginPage: $showLoginPage, showCreateGamePage: $showCreateGamePage, showJoinGamePage: $showJoinGamePage, chance: $myUserDetail.chance, showSettingPage: $showSettingPage, rank: $rank, myUserId: $myUserId)
            } else if showCreateGamePage {
                CreateGamePage(myGame: $myGame, showGameWaitPage: $showGameWaitPage, showCreateGamePage: $showCreateGamePage, showHomePage: $showHomePage, myUserId:myUserId)
            } else if showJoinGamePage {
                JoinGamePage(myGame: $myGame, showGameWaitPage: $showGameWaitPage, showJoinGamePage: $showJoinGamePage, myTurn: $myTurn, showHomePage: $showHomePage, myUserId:myUserId)
            } else if showGameWaitPage {
                GameWaitPage(myGame: $myGame, showHomePage: $showHomePage, showGameWaitPage: $showGameWaitPage, myTurn: $myTurn, showGamePage: $showGamePage, offsetx: $offsetx, offsety: $offsety, position: $position, showTileInforView: $showTileInforView, showTileInforViewIndex: $showTileInforViewIndex, myMap:$myMap, showingPayToll:$showingPayToll, showingGainToll:$showingGainToll, showingGainSalary:$showingGainSalary, toll: $toll, map1:map1, map2:map2, showingJailAnimation: $showingJailAnimation, showingJailAlert: $showingJailAlert, firstShowingJailAlert: $firstShowingJailAlert, showingTravel: $showingTravel, isTravel: $isTravel, showingGuessGame: $showingGuessGame, showingTakeABreak: $showingTakeABreak, showingTax: $showingTax, tax: $tax, showingTradeMessage: $showingTradeMessage, isTrading: $isTrading, showingBankruptMessage: $showingBankruptMessage, inJail: $inJail, showingNoDestinationMessage: $showingNoDestinationMessage, showingGameOverMessage: $showingGameOverMessage, showingWinner: $showingWinner, end: $end, chance: $myUserDetail.chance, showingGainChance: $showingGainChance, myUserDetail: myUserDetail)
            } else if showGamePage {
                GamePage(myGame: $myGame, offsetx: $offsetx, offsety: $offsety, position: $position, showTileInforView: $showTileInforView, showTileInforViewIndex: $showTileInforViewIndex, myMap:$myMap, showingPayToll:$showingPayToll, showingGainToll:$showingGainToll, showingGainSalary: $showingGainSalary, toll:toll, showingJailAnimation: $showingJailAnimation, showingJailAlert: $showingJailAlert, firstShowingJailAlert: $firstShowingJailAlert, showingTravel: $showingTravel, isTravel: $isTravel, showingGuessGame: $showingGuessGame, showingGameWin: $showingGameWin, showingGameLose: $showingGameLose, showingTakeABreak: $showingTakeABreak, showingTax: $showingTax, tax: $tax, showingTradeMessage: $showingTradeMessage, isTrading: $isTrading, showingBankruptMessage: $showingBankruptMessage, showingMoneyNotEnoughMessage: $showingMoneyNotEnoughMessage, inJail: $inJail, showingNoDestinationMessage: $showingNoDestinationMessage, showingGameOverMessage: $showingGameOverMessage, showingWinner: $showingWinner, showingGainChance: $showingGainChance, showGamePage: $showGamePage, showHomePage: $showHomePage, myUserId:myUserId)
            }else if showSettingPage {
                SettingPage(showSettingPage: $showSettingPage, showHomePage: $showHomePage, play: $play)
            }
        }
        .onAppear {
            requestTracking()
            UITableView.appearance().separatorStyle = .none
            UITextView.appearance().isScrollEnabled = false
        }
    }
    
    func requestTracking() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .notDetermined:
                break
            case .restricted:
                break
            case .denied:
                break
            case .authorized:
                break
            @unknown default:
                break
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
