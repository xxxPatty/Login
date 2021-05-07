//
//  RolePage.swift
//  Login
//
//  Created by 林湘羚 on 2021/4/28.
//

import SwiftUI
import WebKit
import UIKit


//class WebViewModel: ObservableObject {
//    @Published var link: String
//    @Published var didFinishLoading: Bool = false
//
//    init (link: String) {
//        self.link = link
//    }
//}

struct WebView: UIViewRepresentable {
    //@ObservedObject var viewModel: WebViewModel
    
    typealias UIViewType = WKWebView
    let webView = WKWebView()
    func makeUIView(context: Context) -> WKWebView {
        //webView.navigationDelegate = context.coordinator
        
        if let url = URL(string: "https://picrew.me/image_maker/338224") {
            let request = URLRequest(url: url)
            print("make view")
            webView.load(request)
        }
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        print("update!!")
    }
    
//    class Coordinator: NSObject, WKNavigationDelegate {
//        private var viewModel: WebViewModel
//
//        init(_ viewModel: WebViewModel) {
//            self.viewModel = viewModel
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            print("WebView: navigation finished")
//            self.viewModel.didFinishLoading = true
//        }
        //        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //            if let url = navigationAction.request.url {
        //                if url.absoluteString.contains("https://picrew.me/image_maker/338224/complete") {
        //                    print("complete")
        //                    decisionHandler(.allow)
        //                    return
        //                } else if url.absoluteString.contains("https://picrew.me/image_maker/338224") {
        //                    print("yes")
        //                    print(url)
        //                    decisionHandler(.allow)
        //                    return
        //                }else {
        //                    //print(url)
        //                    print("no")
        //                }
        //            }
        //
        //            decisionHandler(.cancel)
        //        }
//    }
//
//    func makeCoordinator() -> WebView.Coordinator {
//        Coordinator(viewModel)
//    }
}

struct RolePage: View {
    @Binding var showRolePage: Bool
    @Binding var showUserProfile: Bool
    @State private var roleImage: UIImage? = nil
    @State private var rect: CGRect = .zero
    @Binding var userProfile:UIImage?
    
    //@ObservedObject var model = WebViewModel(link: "https://picrew.me/image_maker/338224")
    var body: some View {
        VStack{
            Text("創造角色")
                .frame(maxWidth: .infinity)
                .font(.largeTitle)
                .padding()
                .background(Color.yellow)
                .foregroundColor(.white)
            
            WebView()
                .background(RectSettings(rect: $rect))

            Button(action:{
                //截圖
                roleImage = UIApplication.shared.windows[0].rootViewController?.view!.setImage(rect: rect)
                //上傳圖片
                uploadPhoto(image: roleImage!) { result in
                    switch result {
                    case .success(let url):
                        setUserPhoto(url: url){result in
                            switch result {
                            case .success(let str):
                                print(str)
                                downloadUserProfileImg(str:"RolePage", url: url){ result in
                                    switch result {
                                    case .success(let uiimage):
                                        userProfile=uiimage
                                        showRolePage=false
                                        showUserProfile=true
                                    case .failure(let error):
                                        break
                                    }
                                }
                            //會不會設完url前就執行？
                            case .failure(let error):
                                break
                            }
                            
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }){
                Text("完成")
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct RolePage_Previews: PreviewProvider {
    static var previews: some View {
        RolePage(showRolePage: .constant(true), showUserProfile: .constant(false), userProfile: .constant(UIImage(systemName: "photo")))
    }
}

struct RectSettings: View {
    @Binding var rect: CGRect
    var body: some View {
        GeometryReader { geometry in
            setView(proxy:geometry)
        }
    }
    
    func setView(proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            rect = proxy.frame(in: .global)
            //rect = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: Int(UIScreen.main.bounds.width)-500)
        }
        return Rectangle().fill(Color.clear)
    }
}
//將UIVIew轉成Image
extension UIView {
    func setImage(rect: CGRect) -> UIImage {
        let rect2 = CGRect(x: 20, y: 320, width: 400, height: 400)
        let renderer = UIGraphicsImageRenderer(bounds: rect2)
        return renderer.image{ rendererContect in
            layer.render(in: rendererContect.cgContext)
        }
    }
}
