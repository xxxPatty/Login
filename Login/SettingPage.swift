//
//  SettingPage.swift
//  Login
//
//  Created by 林湘羚 on 2021/6/17.
//

import SwiftUI
import AVFoundation

struct SettingPage: View {
    @Binding var showSettingPage: Bool
    @Binding var showHomePage: Bool
    @Binding var play: Bool
    @State private var volume: Double = 1
    @State private var showRules = false
    @State private var rect: CGRect = .zero
    var body: some View {
        ZStack(alignment:.top){
            VStack(spacing:25){
                HStack{
                    Button(action:{
                        showSettingPage = false
                        showHomePage = true
                    }){
                        Image(systemName:"arrow.left.square.fill")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("設定")
                        .font(.largeTitle)
                    Spacer()
                }
                Spacer()
                HStack{
                    VStack(alignment: .center){
                        Text("背景音樂")
                            .fontWeight(.bold)
                        Toggle("", isOn: $play)
                            .toggleStyle(SwitchToggleStyle(tint: Color.yellow))
                            .onChange(of: play, perform: { play in
                                if play {
                                    AVPlayer.bgQueuePlayer.play()
                                }else{
                                    AVPlayer.bgQueuePlayer.pause()
                                }
                            })
                            .labelsHidden()
                    }
                    VStack(alignment: .center){
                        Text("音量")
                            .fontWeight(.bold)
                        Slider(value: Binding(get: {
                                   self.volume
                               }, set: { (newVal) in
                                   self.volume = newVal
                                   self.sliderChanged()
                               }))
                               .padding(.all)
                        .accentColor(.yellow)
                    }
                }
                Button(action:{
                    showRules = true
                }){
                    Text("遊戲說明")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                        .padding()
                        .padding(.horizontal, 10)
                        .background(Capsule().fill(Color.yellow))
                }
                Spacer()
            }
            if showRules {
                rules(showRules: $showRules)
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
    func sliderChanged(){
        AVPlayer.bgQueuePlayer.volume = Float(self.volume)
    }
}

struct rules: View {
    @Binding var showRules: Bool
    @State private var myRules = ["遊戲人數2~4人。", "機會大於0才能遊戲，若不夠需觀看廣告。", "玩家開始前可選擇自己棋子形象。", "順序由進入等待是的順序決定。", "每位玩家一開始有$500000。", "一開始大家都在起點，輪流擲兩顆骰子前進。", "前進方向為順時針。", "若擲到相同點數可再擲一次。", "若連續三次擲到相同點數則入獄。", "若停留在沒地主的土地可選擇是否買地。", "若停留在有地主的土地需支付過路費給地主。", "若停留在自己的土地且沒房子可以選擇是否建造房子。", "若停留在監獄區必須入獄。", "入獄後下一輪可選擇要支付保釋金或擲骰子出獄。", "選擇支付保釋金的話支付成功即可出獄。", "選擇擲骰子出獄需要擲到相同點數才可出獄，有三次機會，若三次都失敗則強制支付保釋金出獄。", "若停留在遊戲區需進行猜正反的遊戲，猜對獲得獎金，猜錯需付錢。", "若停留在休息區，休息一回合。", "若停留在機場且有土地，選擇自己的土地作為旅行目的地，若沒有土地則跳過。", "若停留在政府的土地需繳納稅。", "若經過起點可領取薪水。", "若支付不起任何罰金時，需與銀行做交易，選擇要拍賣的土地，可拿回該地購入價格的一半，若沒有地則破產。", "當剩下一人時遊戲結束。", "獲勝的玩家可獲得獎勵一次機會，並記錄在排行榜中。", "祝大家玩得愉快！"]
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("遊戲規則")
                        .font(.largeTitle)
                    ForEach(0..<myRules.count) { index in
                        HStack(alignment: .top) {
                            Image(systemName: "arrowtriangle.right.fill")
                                .offset(y:5)
                            Text(myRules[index]).background(BlurView())
                        }
                    }
                }
                .frame(maxWidth: .infinity - 20)
                .padding()
            }
            .background(BlurView())
            .cornerRadius(25)
            
            Button(action:{
                withAnimation{
                    showRules=false
                }
            }){
                Image(systemName: "xmark.circle")
                    .font(.system(size: 20, weight: .bold))
            }
            .padding()
        }
    }
}


