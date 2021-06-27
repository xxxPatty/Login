//
//  Rank.swift
//  Login
//
//  Created by 林湘羚 on 2021/6/17.
//

import SwiftUI


struct RankView: View {
    let rank: [Ranks.Rank]
    let formatter1 = DateFormatter()
    @Environment(\.presentationMode) var presentationMode
    @State private var rankUserDetail: UserDetail = UserDetail(id: "", name:"", country: 0, birthday: Date(), gender: "男", chance: 3, start: Date(), photoURL:"", totalPlayingTimes:0, totalWins:0, bestRecord:0, messageBoard:"")
    @State private var showRankUserDetail = false
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            VStack{
                Text("排行榜")
                    .fontWeight(.bold)
                List(0..<rank.count) { index in
                    Button(action:{
                        fetchOtherUserDetail(userId: rank[index].id){ result in
                            switch result {
                            case .success(let userDetail):
                                rankUserDetail = userDetail
                                showRankUserDetail = true
                                print("fetchOtherUserDetail success")
                                print("rankUserDetail: \(rankUserDetail)")
                            case .failure(let error):
                                break
                            }
                        }
                    }){
                        HStack{
                            Image(systemName: "\(index+1).circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 25)
                            VStack(alignment: .leading){
                                Text(rank[index].name)
                                Text("\(rank[index].money)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("\(formatter1.string(from: rank[index].time))")
                        }
                    }
                }
                .onAppear{
                    formatter1.dateStyle = .short
                }
            }
            Button(action:{
                withAnimation{
                    presentationMode.wrappedValue.dismiss()
                }
            }){
                Image(systemName: "xmark.circle")
                    .font(.system(size: 20, weight: .bold))
            }
            .padding()
            if showRankUserDetail {
                UserRankDetailView(userInfo:rankUserDetail, showRankUserDetail: $showRankUserDetail)
            }
        }
    }
}

struct UserRankDetailView: View {
    let userInfo: UserDetail
    @Binding var showRankUserDetail: Bool
    @State private var winPercentage: Double = 0
    @State private var level: Int = 0
    @State private var rankImage: UIImage?
    let levels = ["copper", "silver", "gold", "platinum", "diamond"]
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            HStack(alignment:.top){
                VStack(spacing:20){
                    Text("玩家資訊")
                    Divider()
                    //user id
                    Text("ID: \(userInfo.id!)")
                    HStack(spacing:20){
                        //user role image
                        Image(uiImage: rankImage ?? UIImage(systemName: "person")!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.yellow, lineWidth: 2)
                            )
//                        Spacer()
                        VStack(alignment:.leading){
                            //user gender & name
                            HStack{
                                Image(userInfo.gender == "男" ? "boy" : "girl")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                Text(userInfo.name)
                            }
                            //user level
                            HStack{
                                Text("等級：")
                                Image(levels[level])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 40)
                            }
                        }
                    }
                    //user message board
                    VStack(alignment:.leading){
                        Text("留言板")
                        TextEditor(text:.constant(userInfo.messageBoard))
                            .frame(height:50)
                            .border(Color.yellow, width: 3)
                            .cornerRadius(10)
                    }
                }
                Divider()
                VStack(spacing:20){
                    Text("經典數據")
                    Divider()
                    HStack{
                        //total playing times
                        VStack(alignment:.leading){
                            Text("遊戲次數")
                            Text("\(userInfo.totalPlayingTimes)")
                        }
                        //total win times
                        VStack(alignment:.leading){
                            Text("獲勝次數")
                            Text("\(userInfo.totalWins)")
                        }
                        //best record
                        VStack(alignment:.leading){
                            Text("最佳紀錄")
                            Text("\(userInfo.bestRecord)")
                        }
                    }
                    //diagram
                    donutChartView(percentages:[winPercentage, 1-winPercentage])
                        .frame(width:100, height:100)
                        //.padding(.bottom, 50)
                    typeLabelWithPercentage(percentages:[winPercentage, 1-winPercentage])
                }
            }
            .padding(.vertical, 25)
            .padding(.horizontal, 30)
            .background(BlurView())
            .cornerRadius(25)
            .onAppear{
                if userInfo.totalPlayingTimes != 0 {
                    winPercentage = Double(userInfo.totalWins) / Double(userInfo.totalPlayingTimes)
                }
                if winPercentage < 0.2 {
                    level = 0
                }else if winPercentage < 0.4 {
                    level = 1
                }else if winPercentage < 0.6 {
                    level = 2
                }else if winPercentage < 0.8 {
                    level = 3
                }else{
                    level = 4
                }
                if userInfo.photoURL != "" {
                    downloadUserProfileImg(str:"RankPage", url: URL(string: userInfo.photoURL)!){ result in
                        switch result {
                        case .success(let uiimage):
                            rankImage=uiimage
                        case .failure(let error):
                            break
                        }
                    }
                }else{
                    rankImage = UIImage(systemName: "photo")
                }
            }
            
            Button(action:{
                withAnimation{
                    showRankUserDetail=false
                }
            }){
                Image(systemName: "xmark.circle")
                    .font(.system(size: 20, weight: .bold))
            }
            .padding()
        }
    }
}

struct typeLabelWithPercentage:View{
    let someDramaTypes=["勝利", "失敗"]
    let pieChartColor=[Color.red, Color.blue, Color.green, Color.yellow, Color.orange, Color.purple, Color.pink, Color.gray]
    var percentages:[Double]
    var body: some View{
        VStack(alignment:.leading){
            ForEach(someDramaTypes.indices){(index) in
                HStack{
                    Circle()
                        .fill(pieChartColor[index])
                        .frame(width:10, height:10)
                    Text("\(someDramaTypes[index])")
                    Text("\(percentages[index]*100, specifier: "%.2f")%")
                }
            }
        }
    }
}
