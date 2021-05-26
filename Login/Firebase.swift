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
    var players: [player]
    var turn: Int
    var lastEditedTiles: simpleSingleTile
    var invatationCode: String
    var hostId: String
    var lastGainFineRecord: gainFineRecord
    struct player: Codable {
        var index: Int
        var dicePoint: Int
        var userId: String
        var name: String
        var money: Int
        var property: [Int]
        var position: Int
        var figure: String  //棋子樣式
        var dictionary: [String: Any] {
            return ["index": index,
                    "dicePoint" : dicePoint,
                    "userId": userId,
                    "name": name,
                    "money": money,
                    "property": property,
                    "position": position,
                    "figure": figure]
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
    let Ref = db.collection("games").document("\(gameId)")
   
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
    print("tp \(money)")
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
    //let myGame=game(players: [game.player(money: 2000000, property: [], position: 0, figure: "robot1")], turn: 0, tiles: [], invatationCode: "00000")
    var ref: DocumentReference? = nil
    do {
        try ref = db.collection("games").addDocument(from: myGame)
//        try db.collection("games").document("testGame1").setData(from: myGame)
//        print("\(ref?.documentID)")
        //把invatationCode改成games的document id
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

func fetchGameImmediate(gameId: String, completion: @escaping (Result<game, Error>) -> Void) {
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)")
        .addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                completion(.failure(error!))
                return
            }
            do {
                let myGame = try document.data(as: game.self)!
                completion(.success(myGame))
                //print(myGame.players[0].figure)
            } catch {
                print("Error in fetchGame: \(error)")
                completion(.failure(error))
            }
        }
}
func deleteGame(gameId:String){
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").delete()
}
func setGameHostId(gameId:String, hostId:String){
    let db = Firestore.firestore()
    db.collection("games").document("\(gameId)").setData(["hostId":hostId])
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
    let country: Int
    let birthday: Date
    let gender: String
    let mood: Int
    let money:Int
    let start:Date
}

func setUserDetail(selectedCountryIndex:Int, birthday:Date, gender:String, mood:Int, money:Int, start:Date) {
    let db = Firestore.firestore()
    
    let userDetail = UserDetail(country:selectedCountryIndex, birthday:birthday, gender:gender, mood:mood, money:money, start:start)
    do {
        try db.collection("userDetails").document("\(getUserId())").setData(from: userDetail)
    } catch {
        print(error)
    }
}

func fetchUserDetail(completion: @escaping (Result<UserDetail, Error>) -> Void) {
    let db = Firestore.firestore()
    var userDetail = UserDetail(id: getUserId(), country: 0, birthday: Date(), gender: "男", mood: 50, money: 2000000, start: Date())
    
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
