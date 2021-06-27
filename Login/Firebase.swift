//
//  Firebase.swift
//  Login
//
//  Created by 林湘羚 on 2021/4/14.
//

import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth
import UIKit
import FirebaseStorage
import FirebaseStorageSwift

struct game: Codable {
    @DocumentID var id: String?
    var map: Int
    var next: Bool
    var playerNum: Int
    var gain: Bool
    var buy: Bool
    var move: Bool
    var start: Bool
    var go: Bool
    var trade: Bool
    var over: Bool
    var players: [player]
    var turn: Int
    var lastEditedTiles: simpleSingleTile
    var invatationCode: String
    var hostId: String
    var lastGainFineRecord: gainFineRecord
    var lastEditedPositionRecord: editedPositionRecord
    
    struct player: Codable, Identifiable {
        var index: Int
        var dicePoint: Int
        var id: String
        var name: String
        var money: Int
        var figure: String  //棋子樣式
        var inJail: Bool
        var jailNotDoubleCount: Int
        var bankrupt: Bool
        var dictionary: [String: Any] {
            return ["index": index,
                    "dicePoint" : dicePoint,
                    "id": id,
                    "name": name,
                    "money": money,
                    "figure": figure,
                    "inJail": inJail,
                    "jailNotDoubleCount": jailNotDoubleCount,
                    "bankrupt": bankrupt]
        }
        var nsDictionary: NSDictionary {
            return dictionary as NSDictionary
        }
    }
    
    struct singleTile: Codable {
        //var index: Int
        var name: String
        var imgStr: String
        var level: Int
        var description: String
        var price: [Int]
        var tolls: [Int]  //  過路費
        var owner: Int
    }
    
    struct simpleSingleTile: Codable {
        var index: Int
        var level: Int
        var owner: Int
        var dictionary: [String: Any] {
            return ["index": index, 
                    "level": level,
                    "owner" : owner]
        }
        var nsDictionary: NSDictionary {
            return dictionary as NSDictionary
        }
    }
    struct gainFineRecord: Codable {
        var index: Int
        var toll: Int
        var dictionary: [String: Any] {
            return ["index": index,
                    "toll": toll]
        }
        var nsDictionary: NSDictionary {
            return dictionary as NSDictionary
        }
    }
    struct editedPositionRecord: Codable {
        var index: Int
        var newPosition: Int
        var dictionary: [String: Any] {
            return ["index": index,
                    "newPosition": newPosition]
        }
        var nsDictionary: NSDictionary {
            return dictionary as NSDictionary
        }
    }
}
func deleteGame(gameId: String) {
    print("deleteGame: \(gameId)")
    let db = Firestore.firestore()
    db.collection("games").document(gameId).delete() { err in
        if let err = err {
            print("Error removing game document: \(err)")
        } else {
            print("Game document successfully removed!")
        }
    }
}
func setGameOver(gameId: String, over: Bool, myPlayer: game.player) {
    print("setGameOver: \(over)")
    let db = Firestore.firestore()
    let Ref = db.collection("games").document("\(gameId)")
   
    Ref.updateData([
        "players": FieldValue.arrayRemove([myPlayer.dictionary])
    ])
    var tempPlayer = myPlayer
    tempPlayer.bankrupt = true
    Ref.updateData([
        "players": FieldValue.arrayUnion([tempPlayer.dictionary])
    ])
    
    Ref.updateData(["over":over])
}
func setGameTrade(gameId: String, trade: Bool){
    print("setGameTrade: \(trade)")
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").updateData(["trade":trade])
}
func setGameGo(gameId: String, go: Bool){
    print("setGameGo: \(go)")
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").updateData(["go":go])
}
func setGameLastEditedPositionRecord(gameId: String, lastEditedPositionRecord: game.editedPositionRecord) {
    print("setGameLastEditedPositionRecord: \(lastEditedPositionRecord)")
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").updateData(["lastEditedPositionRecord":lastEditedPositionRecord.dictionary])
}
func setGameNext(gameId: String, next: Bool){
    print("setGameNext: \(next)")
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").updateData(["next":next])
}
func setGamePlayerNum(gameId: String, num: Int) {
    print("setGamePlayerNum: \(num)")
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").updateData(["playerNum":num])
}
func setGameGain(gameId: String, gain: Bool) {
    print("setGameGain: \(gain)")
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").updateData(["gain":gain])
}
func setGainFineRecord(gameId:String, record: game.gainFineRecord){
    print("setGainFineRecord: \(record)")
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").updateData(["lastGainFineRecord":record.dictionary])
}

func setGameBuy(gameId:String, buy:Bool){
    print("setGameBuy: \(buy)")
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").updateData(["buy":buy])
}

func setTileLevelOwner(gameId:String, myTile: game.simpleSingleTile){
    print("setTileLevelOwner: \(myTile)")
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").updateData(["lastEditedTiles":myTile.dictionary])
}

func setGameMove(gameId:String, move:Bool){
    print("setGameMove: \(move)")
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").updateData(["move":move])
}

func setGameStart(gameId:String, start:Bool){
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").updateData(["start":start])
}


func setPlayerMoney(gameId:String, myPlayer:game.player, money:Int){
    print("setPlayerMoney: \(myPlayer)")
    print("to \(money)")
    let db = Firestore.firestore()
    let Ref = db.collection("games").document("\(gameId)")
   
    Ref.updateData([
        "players": FieldValue.arrayRemove([myPlayer.dictionary])
    ])
    var tempPlayer = myPlayer
    tempPlayer.money = money
    Ref.updateData([
        "players": FieldValue.arrayUnion([tempPlayer.dictionary])
    ])
}

func setPlayerBankrupt(gameId:String, myPlayer:game.player, bankrupt:Bool){
    print("setPlayerBankrupt: \(myPlayer)")
    print("to \(bankrupt)")
    let db = Firestore.firestore()
    let Ref = db.collection("games").document("\(gameId)")
   
    Ref.updateData([
        "players": FieldValue.arrayRemove([myPlayer.dictionary])
    ])
    var tempPlayer = myPlayer
    tempPlayer.bankrupt = bankrupt
    Ref.updateData([
        "players": FieldValue.arrayUnion([tempPlayer.dictionary])
    ])
}

//double出獄
func setPlayerOutJailWithDouble(gameId: String, myPlayer: game.player, inJail: Bool, jailNotDoubleCount: Int, dicePoint: Int) {
    print("setPlayerOutJailWithDouble: \(myPlayer)")
    let db = Firestore.firestore()
    let Ref = db.collection("games").document("\(gameId)")
   
    Ref.updateData([
        "players": FieldValue.arrayRemove([myPlayer.dictionary])
    ])
    var tempPlayer = myPlayer
    tempPlayer.inJail = inJail
    tempPlayer.jailNotDoubleCount = jailNotDoubleCount
    tempPlayer.dicePoint = dicePoint
    Ref.updateData([
        "players": FieldValue.arrayUnion([tempPlayer.dictionary])
    ])
}

//付款出獄
func setPlayerOutJailWithPay(gameId: String, myPlayer: game.player, inJail: Bool, jailNotDoubleCount: Int, money: Int) {
    print("setPlayerOutJailWithPay: \(myPlayer)")
    let db = Firestore.firestore()
    let Ref = db.collection("games").document("\(gameId)")
   
    Ref.updateData([
        "players": FieldValue.arrayRemove([myPlayer.dictionary])
    ])
    var tempPlayer = myPlayer
    tempPlayer.inJail = inJail
    tempPlayer.jailNotDoubleCount = jailNotDoubleCount
    tempPlayer.money = money
    Ref.updateData([
        "players": FieldValue.arrayUnion([tempPlayer.dictionary])
    ])
}

func setPlayerJailNotDoubleCount(gameId:String, myPlayer:game.player, jailNotDoubleCount:Int){
    print("setPlayerJailNotDoubleCount: \(myPlayer)")
    let db = Firestore.firestore()
    let Ref = db.collection("games").document("\(gameId)")
   
    Ref.updateData([
        "players": FieldValue.arrayRemove([myPlayer.dictionary])
    ])
    var tempPlayer = myPlayer
    tempPlayer.jailNotDoubleCount = jailNotDoubleCount
    Ref.updateData([
        "players": FieldValue.arrayUnion([tempPlayer.dictionary])
    ])
}

func setPlayerInJail(gameId:String, myPlayer:game.player, inJail:Bool){
    print("setPlayerInJail: \(myPlayer)")
//    print("tp \(money)")
    let db = Firestore.firestore()
    let Ref = db.collection("games").document("\(gameId)")
   
    Ref.updateData([
        "players": FieldValue.arrayRemove([myPlayer.dictionary])
    ])
    var tempPlayer = myPlayer
    tempPlayer.inJail = inJail
    Ref.updateData([
        "players": FieldValue.arrayUnion([tempPlayer.dictionary])
    ])
}

func setGameTurn(gameId:String, turn:Int){
    print("setGameTurn: \(turn)")
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").updateData(["turn":turn])
}

func setPlayerDicePoint(gameId: String, myPlayer: game.player, dicePoint: Int) {
    print("setPlayerDicePoint: \(dicePoint)")
    let db = Firestore.firestore()
    let Ref = db.collection("games").document("\(gameId)")
   
    Ref.updateData([
        "players": FieldValue.arrayRemove([myPlayer.dictionary])
    ])
    var tempPlayer = myPlayer
    tempPlayer.dicePoint = dicePoint
    Ref.updateData([
        "players": FieldValue.arrayUnion([tempPlayer.dictionary])
    ])
}

//呼叫時要用 addGame(myGame: &game1)
func addGame(myGame: inout game) {
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    do {
        try ref = db.collection("games").addDocument(from: myGame)
        myGame.invatationCode = ref?.documentID ?? ""
        //再存回去
        try db.collection("games").document(ref?.documentID ?? "").setData(from: myGame)
    } catch {
        print(error)
    }
}

func fetchGame(gameId: String, completion: @escaping (Result<game, Error>) -> Void) {
    let db = Firestore.firestore()
    
    db.collection("games").document("\(gameId)").getDocument { document, error in
        guard let document = document, document.exists else { return }
        do {
            let myGame = try document.data(as: game.self)!
            completion(.success(myGame))
        } catch {
            completion(.failure(error))
        }
    }
}

func fetchGameImmediate(gameId: String, end: Bool, completion: @escaping (Result<game, Error>) -> Void) {
    let db = Firestore.firestore()
    let listener = db.collection("games").document("\(gameId)")
        .addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                completion(.failure(error!))
                return
            }
            do {
                let myGame = try document.data(as: game.self)
                if myGame != nil {
                    completion(.success(myGame!))
                }else{
                    completion(.success(game(map: 0, next: false, playerNum: 1, gain: false, buy: false, move: false, start: false, go: false, trade: false, over: true, players: [game.player(index:0, dicePoint: 0, id:"", name: "", money: 500000, figure: "robot1", inJail: false, jailNotDoubleCount: 0, bankrupt: false)], turn: 0, lastEditedTiles: game.simpleSingleTile(index:-1, level: 0, owner: -1), invatationCode: "", hostId: "", lastGainFineRecord: game.gainFineRecord(index: -1, toll: 0), lastEditedPositionRecord: game.editedPositionRecord(index: -1, newPosition: -1))))
                }
            } catch {
                print("Error in fetchGame: \(error)")
                completion(.failure(error))
            }
        }
    if end {
        listener.remove()
    }
}
func setGameHostId(gameId:String, hostId:String){
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").updateData(["hostId":hostId])
}
func addPlayer(gameId:String, myPlayer: game.player) {
    let db = Firestore.firestore()
    let Ref = db.collection("games").document("\(gameId)")
    
    // Atomically add a new region to the "regions" array field.
    //若加入的元素在原陣列中有一模一樣的則無法加入
    Ref.updateData([
        "players": FieldValue.arrayUnion([myPlayer.dictionary])
    ])
}

func removePlayer(gameId:String, myPlayer: game.player) {
    let db = Firestore.firestore()
    let Ref = db.collection("games").document("\(gameId)")
    //    // Atomically remove a region from the "regions" array field.
    Ref.updateData([
        "players": FieldValue.arrayRemove([myPlayer.dictionary])
    ])
}

struct UserDetail: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    let country: Int
    let birthday: Date
    let gender: String
    var chance: Int
    let start: Date
    
    var photoURL: String
    var totalPlayingTimes: Int
    var totalWins: Int
    var bestRecord: Int
    var messageBoard: String
}

func setUserLoseRecord(userId:String){
    let db = Firestore.firestore()
    db.collection("userDetails").document("\(userId)").updateData(["totalPlayingTimes":FieldValue.increment(Int64(1))])
}

func setUserWinBestRecord(userId:String, bestRecord:Int){
    let db = Firestore.firestore()
    db.collection("userDetails").document("\(userId)").updateData(["totalPlayingTimes":FieldValue.increment(Int64(1)), "totalWins":FieldValue.increment(Int64(1)), "bestRecord":bestRecord])
}

func setUserWinRecord(userId:String){
    let db = Firestore.firestore()
    db.collection("userDetails").document("\(userId)").updateData(["totalPlayingTimes":FieldValue.increment(Int64(1)), "totalWins":FieldValue.increment(Int64(1))])
}

func setUserPhotoURL(userId:String, photoURL:String){
    let db = Firestore.firestore()
    db.collection("userDetails").document("\(userId)").updateData(["photoURL":photoURL])
}

func setUserChance(userId:String, chance:Int){
    let db = Firestore.firestore()
    db.collection("userDetails").document("\(userId)").updateData(["chance":chance])
}

func setUserDetail(name:String, selectedCountryIndex:Int, birthday:Date, gender:String, chance:Int, start:Date, messageBoard:String) {
    let db = Firestore.firestore()
    
    //let userDetail = UserDetail(name:name, country:selectedCountryIndex, birthday:birthday, gender:gender, chance:chance, start:start, photoURL:"", totalPlayingTimes:0, totalWins:0, bestRecord:0, messageBoard:messageBoard)
    db.collection("userDetails").document("\(getUserId())").updateData(["name":name, "country":selectedCountryIndex, "birthday":birthday, "gender":gender, "chance":chance, "start":start, "messageBoard":messageBoard])
}

func fetchOtherUserDetail(userId:String, completion: @escaping (Result<UserDetail, Error>) -> Void) {
    let db = Firestore.firestore()
    var userDetail = UserDetail(id: getUserId(), name:"", country: 0, birthday: Date(), gender: "男", chance: 3, start: Date(), photoURL:"", totalPlayingTimes:0, totalWins:0, bestRecord:0, messageBoard:"")
    
    print("In fetchOtherUserDetail user id: \(userId)")
    db.collection("userDetails").document(userId).getDocument { document, error in
        guard let document = document, document.exists else { return }
        if document.exists {
            do {
                userDetail = try document.data(as: UserDetail.self)!
                //print("fetchUserDetail money: \(userDetail.money)")
                completion(.success(userDetail))
            } catch {
                print("Error in fetchOtherUserDetail: \(error)")
                completion(.failure(error))
            }
        }else {
            completion(.success(userDetail))
        }
    }
}

func fetchUserDetail(completion: @escaping (Result<UserDetail, Error>) -> Void) {
    let db = Firestore.firestore()
    var userDetail = UserDetail(id: getUserId(), name:"", country: 0, birthday: Date(), gender: "男", chance: 3, start: Date(), photoURL:"", totalPlayingTimes:0, totalWins:0, bestRecord:0, messageBoard:"")
    
    print("In fetchUserDetail user id: \(getUserId())")
    db.collection("userDetails").document("\(getUserId())").getDocument { document, error in
        guard let document = document, document.exists else { return }
        if document.exists {
            do {
                userDetail = try document.data(as: UserDetail.self)!
                //print("fetchUserDetail money: \(userDetail.money)")
                completion(.success(userDetail))
            } catch {
                print("Error in fetchUserDetail: \(error)")
                completion(.failure(error))
            }
        }else {
            completion(.success(userDetail))
        }
    }
}
func fetchUserImmediate(userId: String, completion: @escaping (Result<UserDetail, Error>) -> Void) {
    let db = Firestore.firestore()
    db.collection("userDetails").document("\(userId)")
        .addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                completion(.failure(error!))
                return
            }
            do {
                let myUserDetail = try document.data(as: UserDetail.self)!
                completion(.success(myUserDetail))
                //print(myGame.players[0].figure)
            } catch {
                print("Error in fetchUserImmediate: \(error)")
                completion(.failure(error))
            }
        }
}
func creatUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {   //註冊後會自動登入
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
        guard let user = result?.user,
              error == nil else {
            print(error?.localizedDescription)
            completion(.failure(error as! Error))
            return
        }
        print(user.email, user.uid)
        completion(.success("Register success"))
    }
}

func signIn(email:String, password:String, completion: @escaping (Result<String, Error>) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { result, error in
        guard error == nil else {
            print(error?.localizedDescription)
            completion(.failure(error as! Error))
            return
        }
        completion(.success("Login success"))
    }
}

func isLogin()->Bool {
    if let user = Auth.auth().currentUser {
        print("\(user.uid) login")
        return true
    } else {
        print("not login")
        return false
    }
}

func setUserImgAndName(imgURL:String, name:String) {
    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    changeRequest?.photoURL = URL(string: imgURL)
    changeRequest?.displayName = name
    changeRequest?.commitChanges(completion: { error in
        guard error == nil else {
            print(error?.localizedDescription)
            return
        }
        
    })
}

func getUserInfo() {
    if let user = Auth.auth().currentUser {
        print(user.uid, user.email, user.displayName, user.photoURL)
    }
}

func getUserName() -> String {
    var name:String=""
    let defaultName:String?=""
    if let user = Auth.auth().currentUser {
        name = user.displayName ?? defaultName!
    }
    return name
}

func getUserId() -> String {
    var id:String=""
    let defaultId:String?=""
    if let user = Auth.auth().currentUser {
        id = user.uid ?? defaultId!
    }
    return id
}

func getUserEmail() -> String {
    var email:String=""
    let defaultEmail:String?=""
    if let user = Auth.auth().currentUser {
        email = user.email ?? defaultEmail!
    }
    return email
}

func logOut() {
    do {
        try Auth.auth().signOut()
    } catch {
        print(error)
    }
}

//將照片存到firebase
func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
    
    let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
    if let data = image.jpegData(compressionQuality: 0.9) {
        
        fileReference.putData(data, metadata: nil) { result in
            switch result {
            case .success(_):
                fileReference.downloadURL { result in
                    switch result {
                    case .success(let url):
                        completion(.success(url))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//將照片設成user大頭照
func setUserPhoto(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
    print("setUserPhoto URL: \(url)")
    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    changeRequest?.photoURL = url
    changeRequest?.commitChanges(completion: { error in
        guard error == nil else {
            print(error?.localizedDescription)
            completion(.failure(error!))
            return
        }
    })
    completion(.success("setUserPhoto success"))
}

func setUserName(name:String) {
    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    changeRequest?.displayName = name
    changeRequest?.commitChanges(completion: { error in
        guard error == nil else {
            print(error?.localizedDescription)
            return
        }
    })
}

func downloadUserProfileImg(str:String, url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
    if url == URL(string: "https://www.google.com.tw/?client=safari&channel=iphone_bm")! {
        completion(.success(UIImage(systemName: "person")!))
    }
    if let user = Auth.auth().currentUser {
        // Create a reference to the file you want to download
        let httpsReference = Storage.storage().reference(forURL:url.absoluteString)
        print("downloadUserProfileImg(\(str): \(httpsReference)")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error.localizedDescription)
                completion(.failure(error))
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                completion(.success(image ?? UIImage(systemName: "person")!))
            }
        }
    }
}

func getUserPhotoURL() ->URL {
    var url:URL=URL(string: "https://www.google.com.tw/?client=safari&channel=iphone_bm")!
    let defaultURL:URL? = URL(string: "")
    if let user = Auth.auth().currentUser {
        url = user.photoURL ?? defaultURL!
    }
    return url
}
struct JSON {
    static let encoder = JSONEncoder()
}
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}

struct Ranks: Codable {
    let rankingArray: [Rank]
    struct Rank:Codable, Identifiable {
        let name: String
        let money: Int
        let id: String
        let time:Date
        var dictionary: [String: Any] {
            return ["name": name,
                    "money": money,
                    "id" : id,
                    "time": time]
        }
        var nsDictionary: NSDictionary {
            return dictionary as NSDictionary
        }
    }
}
func addRankingRecord(ranking: Ranks.Rank) {
    print("addRankingRecord: \(ranking)")
    let db = Firestore.firestore()
    let Ref = db.collection("rankingRecord").document("00000")
   
    Ref.updateData([
        "rankingArray": FieldValue.arrayUnion([ranking.dictionary])
    ])
}

func fetchRanking(completion: @escaping (Result<Ranks, Error>) -> Void) {
    let db = Firestore.firestore()
    var rankingArray:Ranks = Ranks(rankingArray: [])
    print("fetchRanking")
    db.collection("rankingRecord").document("00000").getDocument { document, error in
        guard let document = document, document.exists else { return }
        if document.exists {
            do {
                rankingArray = try document.data(as: Ranks.self)!
                completion(.success(rankingArray))
            } catch {
                print("Error in fetchUserDetail: \(error)")
                completion(.failure(error))
            }
        }else {
            completion(.success(rankingArray))
        }
    }
}
