//
//  UserProfilePage.swift
//  Login
//
//  Created by 林湘羚 on 2021/5/2.
//

import SwiftUI

struct UserProfilePage: View {
    @Binding var showRolePage:Bool
    @Binding var showUserProfilePage:Bool
    @Binding var userProfile:UIImage?
    @Binding var showLoginPage:Bool
    @Binding var showHomePage:Bool
    @State private var userName:String=getUserName()
    @State private var birthday:Date=Date()
    @State private var gender:Bool=false    //flase->男 true->女
    @State private var mood:Double=50
    @State private var money:Int=2000000
    @State private var start:Date=Date()
    @State private var selectedCountryIndex:Int=0
    let formatter1 = DateFormatter()
    let countryArray = ["Afghanistan","Albania","Algeria","Andorra","Angola","Anguilla","Antigua &amp; Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia &amp; Herzegovina","Botswana","Brazil","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Cape Verde","Cayman Islands","Chad","Chile","China","Colombia","Congo","Cook Islands","Costa Rica","Cote D Ivoire","Croatia","Cruise Ship","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Polynesia","French West Indies","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guam","Guatemala","Guernsey","Guinea","Guinea Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jersey","Jordan","Kazakhstan","Kenya","Kuwait","Kyrgyz Republic","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Mauritania","Mauritius","Mexico","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Namibia","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Saint Pierre &amp; Miquelon","Samoa","San Marino","Satellite","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","South Africa","South Korea","Spain","Sri Lanka","St Kitts &amp; Nevis","St Lucia","St Vincent","St. Lucia","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor L'Este","Togo","Tonga","Trinidad &amp; Tobago","Tunisia","Turkey","Turkmenistan","Turks &amp; Caicos","Uganda","Ukraine","United Arab Emirates","United Kingdom","Uruguay","Uzbekistan","Venezuela","Vietnam","Virgin Islands (US)","Yemen","Zambia","Zimbabwe"]
    var body: some View {
        NavigationView {
            VStack{
                Form{
                    Section(header: Image(systemName: "pencil")){
                        //大頭照
                        Image(uiImage: userProfile ?? UIImage(systemName: "photo")!)
                            .resizable()
                            .scaledToFill()
                            .frame(width:200, height:200)
                            .clipped()
                            //.cornerRadius(20)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                        //名字
                        TextField("姓名", text:$userName)
                        //國家
                        Picker(selection: $selectedCountryIndex, label: Text("國家")) {
                            ForEach(0 ..< countryArray.count) {
                                Text(self.countryArray[$0])
                            }
                        }
                        .accentColor(.yellow)
                        //生日
                        DatePicker("生日", selection: $birthday, in: ...Date(), displayedComponents: .date)
                            .accentColor(.yellow)
                        //性別
                        Toggle(gender ? "性別(女)" : "性別(男)", isOn: $gender)
                            .toggleStyle(SwitchToggleStyle(tint: Color.yellow))
                        //心情
                        HStack{
                            Text("心情(\(Int(mood)))")
                            Slider(value: $mood, in:0...100)
                                .accentColor(.yellow)
                        }
                    }
                    Section(header: Image(systemName: "pencil.slash")){
                        //email
                        HStack{
                            Text("信箱")
                            Spacer()
                            Text("\(getUserEmail())")
                        }
                        //金錢
                        HStack{
                            Text("財產")
                            Spacer()
                            Text("\(money)")
                        }
                        //加入時間
                        HStack{
                            Text("加入日期")
                            Spacer()
                            Text("\(formatter1.string(from: start))")
                        }
                    }
                }
                HStack{
                    Button(action:{
                        showUserProfilePage=false
                        showRolePage=true
                    }){
                        Text("創作角色")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 15))
                            .padding()
                            .padding(.horizontal, 10)
                            .background(Capsule().fill(Color.yellow))
                    }
                    Button(action:{
                        setUserDetail(selectedCountryIndex:selectedCountryIndex, birthday:birthday, gender: gender ? "女" : "男", mood:Int(mood), money: money, start: start)
                        setUserName(name: userName)
                    }){
                        Text("編輯檔案")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 15))
                            .padding()
                            .padding(.horizontal, 10)
                            .background(Capsule().fill(Color.yellow))
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    HStack{
                        Button(action:{
                            showUserProfilePage=false
                            showHomePage=true
                        }){
                            Text("<主頁")
                                .foregroundColor(.yellow)
                        }
                        Spacer()
                        Text("個人檔案")
                            .font(.largeTitle)
                        Spacer()
                    }
                }
            })
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear{
            print("appear")
                    formatter1.dateStyle = .short
                    userName = getUserName()
                    fetchUserDetail(){ result in
                        switch result {
                        case .success(let userDetail):
                            selectedCountryIndex = userDetail.country
                            //country = userDetail.country
                            birthday = userDetail.birthday
                            gender = userDetail.gender == "男" ? false : true
                            mood = Double(userDetail.mood)
                            money = userDetail.money
                            start = userDetail.start
                        case .failure(let error):
                            break
                        }
                    }
        }
    }
}


struct UserProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        UserProfilePage(showRolePage: .constant(false), showUserProfilePage: .constant(true), userProfile: .constant(UIImage(systemName: "photo")), showLoginPage: .constant(false), showHomePage:.constant(false))
    }
}

