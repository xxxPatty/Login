//
//  dountChartView.swift
//  Login
//
//  Created by 林湘羚 on 2021/6/21.
//


import SwiftUI

//struct donut:View{
//    var startpercentage:Double
//    var endpercentage:Double
//    var body: some View{
//        Circle()
//            .trim(from: CGFloat(startpercentage), to: CGFloat(endpercentage))
//            .stroke(Color.red, lineWidth: 30)
//    }
//}
struct donutChartView:View{
    var percentages:[Double]
    var donutpercentages:[Double]
    let pieChartColor=[Color.red, Color.blue, Color.green, Color.yellow, Color.orange, Color.purple, Color.pink, Color.gray]
    init(percentages:[Double]){
        self.percentages=percentages
        donutpercentages=[Double]()
        var start:Double=0
        for percentage in percentages{
            donutpercentages.append(start)
            start+=percentage
        }
    }
    var body: some View{
        ZStack {
            ForEach(donutpercentages.indices){(index) in
                if index==donutpercentages.count-1{
                    Circle()
                        .trim(from: CGFloat(donutpercentages[index]), to: 1)
                        .stroke(pieChartColor[index], lineWidth: 15)
                }else{
                    Circle()
                        .trim(from: CGFloat(donutpercentages[index]), to: CGFloat(donutpercentages[index+1]))
                        .stroke(pieChartColor[index], lineWidth: 15)
                }
            }
        }
    }
}
