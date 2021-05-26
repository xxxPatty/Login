//
//  ContentView.swift
//  Login
//
//  Created by 林湘羚 on 2021/4/14.
//

import SwiftUI
import Firebase

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
    @State private var myGame: game = game(map: 0, next: false, playerNum: 1, gain: false, buy: false, move: false, start: false, players: [game.player(index:0, dicePoint: 0,userId:"", name: "", money: 2000000, property: [], position: 0, figure: "robot1")], turn: 0, lastEditedTiles: game.simpleSingleTile(index:-1, level: 0, owner: -1), invatationCode: "", hostId: "", lastGainFineRecord: game.gainFineRecord(index: -1, toll: 0))
    //map1，level 1土地，level 2房子
    let map1=[
        game.singleTile(name: "start", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -1),
        game.singleTile(name: "taiwan", imgStr: "taiwanBuilding", level: 0, description: "台北101", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "japan", imgStr: "japanBuilding", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "china", imgStr: "chinaBuilding", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "jail", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -1),
        game.singleTile(name: "australia", imgStr: "australiaBuilding", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "game", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -1),
        game.singleTile(name: "egypt", imgStr: "egyptBuilding", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "break", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -1),
        game.singleTile(name: "france", imgStr: "franceBuilding", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "england", imgStr: "englandBuilding", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "italy", imgStr: "italyBuilding", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "travel", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -1),
        game.singleTile(name: "america", imgStr: "americaBuilding", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "fine", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [100000, 100000], owner: -1),
        game.singleTile(name: "mexico", imgStr: "mexicoBuilding", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1)]
    
    //map2，level 1土地，level 2房子
    let map2=[
        game.singleTile(name: "start", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -1),
        game.singleTile(name: "livingRoom", imgStr: "sofa", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "bedRoom", imgStr: "bed", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "diningRoom", imgStr: "diningTable", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "hospital", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -1),
        game.singleTile(name: "kitchen", imgStr: "refrigerator", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "game", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -1),
        game.singleTile(name: "studyRoom", imgStr: "book", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "backyard", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -1),
        game.singleTile(name: "bathRoom", imgStr: "bathtub", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "studio", imgStr: "computer", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "dressingRoom", imgStr: "cloth", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "market", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [0, 0], owner: -1),
        game.singleTile(name: "parkingLot", imgStr: "car", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1),
        game.singleTile(name: "fine", imgStr: "", level: 0, description: "", price: [0, 0], tolls: [100000, 100000], owner: -1),
        game.singleTile(name: "toliet", imgStr: "chamberPot", level: 0, description: "", price: [100000, 200000], tolls: [10000, 20000], owner: -1)]
    @State private var myMap: [game.singleTile] = []
    @State private var showingPayToll: Bool = false
    @State private var showingGainToll: Bool = false
    @State private var showingGainSalary: Bool = false
    @State private var toll: Int = 0
    var body: some View {
        VStack{
            if showLoginPage {
                LoginPage(showLoginPage: $showLoginPage, showRegisterPage:$showRegisterPage, showUserProfilePage: $showUserProfilePage, userProfile:$userProfile, showHomePage:$showHomePage)
            }else if showRegisterPage{
                RegisterPage(showLoginPage:$showLoginPage, showRegisterPage:$showRegisterPage, showUserProfilePage: $showUserProfilePage, userProfile:$userProfile, showHomePage:$showHomePage)
            }else if showRolePage{
                RolePage(showRolePage:$showRolePage, showUserProfile:$showUserProfilePage, userProfile:$userProfile)
            } else if showUserProfilePage {
                UserProfilePage(showRolePage:$showRolePage, showUserProfilePage:$showUserProfilePage, userProfile:$userProfile, showLoginPage:$showLoginPage, showHomePage:$showHomePage)
            } else if showHomePage {
                HomePage(showHomePage: $showHomePage, showRolePage: $showRolePage, showUserProfilePage: $showUserProfilePage, userProfile: $userProfile, showLoginPage: $showLoginPage, showCreateGamePage: $showCreateGamePage, showJoinGamePage: $showJoinGamePage)
            } else if showCreateGamePage {
                CreateGamePage(myGame: $myGame, showGameWaitPage: $showGameWaitPage, showCreateGamePage: $showCreateGamePage, showHomePage: $showHomePage)
            } else if showJoinGamePage {
                JoinGamePage(myGame: $myGame, showGameWaitPage: $showGameWaitPage, showJoinGamePage: $showJoinGamePage, myTurn: $myTurn, showHomePage: $showHomePage)
            } else if showGameWaitPage {
                GameWaitPage(myGame: $myGame, showHomePage: $showHomePage, showGameWaitPage: $showGameWaitPage, myTurn: $myTurn, showGamePage: $showGamePage, offsetx: $offsetx, offsety: $offsety, position: $position, showTileInforView: $showTileInforView, showTileInforViewIndex: $showTileInforViewIndex, myMap:$myMap, showingPayToll:$showingPayToll, showingGainToll:$showingGainToll, showingGainSalary:$showingGainSalary, toll: $toll, map1:map1, map2:map2)
            } else if showGamePage {
                GamePage(myGame: $myGame, offsetx: $offsetx, offsety: $offsety, position: $position, showTileInforView: $showTileInforView, showTileInforViewIndex: $showTileInforViewIndex, myMap:$myMap, showingPayToll:$showingPayToll, showingGainToll:$showingGainToll, showingGainSalary: $showingGainSalary, toll:toll)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
