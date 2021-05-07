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
