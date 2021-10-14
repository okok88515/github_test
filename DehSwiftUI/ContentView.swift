//
//  ContentView.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/1.
//  Copyright © 2020 mmlab. All rights reserved.
//

import SwiftUI
import Alamofire
import CryptoKit
import simd
// the personal entry is here
#if DEH
let coi = "deh"
#else
let coi = "deh_default"
#endif
var language = ""
struct ContentView: View {
    init(){
        UserDefaults.standard.register(defaults: [
            "advancedSetting" : false,
            "searchDistance" : 10.0,
            "searchNumber" : 50.0,
            "account" : "",
            "password" : "",
            "loginState" : false,
            "userID" : "0",
        ])
        let languageList = ["zh": "中文",
                            "jp": "日文",
                            "en": "英文",
        ]
        language = languageList[Locale.current.languageCode ?? ""] ?? "英文"
        
        //https://stackoverflow.com/questions/69111478/ios-15-navigation-bar-transparent
        if #available(iOS 15, *) {
            // White non-transucent navigation bar, supports dark appearance
            // iOS 14 doesn't have extra separators below the list by default.
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        else {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
        }
        
        // To remove all separators including the actual ones:
//        UITableView.appearance().separatorStyle = .none
        //list底下的背景色
        UITableView.appearance().backgroundColor = UIColor(rgba:darkGreen)
        
        //解決tab bar半透明的問題
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = UIColor(rgba: lightGreen)
        
        UINavigationBar.appearance().backgroundColor = UIColor(rgba: darkGreen)
        //選取不反白
        UITableViewCell.appearance().selectionStyle = .none
        

    }
    //帶有State 的變數可以動態變更ＵＩ上的值
    @State var isShowingSheet = false
    @State var notLogin = true
    @State var searchTitle = "title"
    @EnvironmentObject var settingStorage:SettingStorage
    //若使用classModel的值則必須使用observation pattern
    //https://stackoverflow.com/questions/60744017/how-do-i-update-a-text-label-in-swiftui
    
    @State var selection: Int? = nil
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                TabView{
                    TabViewElement(title: "My Favorite".localized, image1: "Empty", image2: "Empty",tabItemImage: "member_favorite",tabItemName: "favorite")
                    TabViewElement(title: "Searched Xois".localized, image1: "Empty", image2: "Empty",tabItemImage:"member_searched",tabItemName: "nearby")
                    TabViewElement(title: "Group Interests".localized, image1: "member_grouplist", image2: "search",tabItemImage:"member_group",tabItemName:"group")
                    TabViewElement(title: "My Xois".localized, image1: "Empty", image2: "search",tabItemImage:"member_interests",tabItemName:"mine")
                }
            }
            .navigationBarTitle(Text("HI, ".localized + self.settingStorage.account), displayMode: .inline)
            .navigationBarItems(leading: NavigationLink(destination: Setting(), tag: 1, selection: $selection) {
                HStack {
                    Button(action: {
                        print("setting tapped")
                        self.selection = 1
                    }) {
                        Image("member_setting")
                            .foregroundColor(.blue)
                    }
                    Button(action:{
                        if(self.settingStorage.loginState == true) {
                            isShowingSheet = true
                            notLogin = false
                        }
                    }) {
                        Image("more")
                            .foregroundColor(.blue)
                    }
                 
                    .actionSheet(isPresented: $isShowingSheet) {
                        ActionSheet(title: Text("Select more options".localized), message: Text(""), buttons: [
                            .default(Text("Price".localized)) {
                                
                            },
                            .default(Text("Group".localized)) {
                                openMakeURL()
                            },
                            .cancel()
                        ])
                    }
                }
            }
            ,trailing: NavigationLink(destination: DEHMap(), tag: 2, selection: $selection) {
                HStack{
                    NavigationLink(destination: GameView(), tag: 3, selection: $selection){
                        Button(action: {
                            print("game tap")
                            self.selection = 3
                        }) {
                            Image(systemName: "gamecontroller")
//                                .renderingMode(.original)
//                                .foregroundColor(.white)
                        }
                    }
                    Button(action: {
                        print("map tapped")
                        self.selection = 2
                    }) {
                        Image("member_back")
                            .foregroundColor(.blue)
                    }
                }
            })
        }
        //this line to avoid lots of warning
        //https://stackoverflow.com/questions/65316497/swiftui-navigationview-navigationbartitle-layoutconstraints-issue/65316745
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(){
print("123")
        }
    }
}
extension ContentView {
    func openMakeURL() {
        let url = URL(string: "dehMakeII://")!
        UIApplication.shared.open(url, options: [:], completionHandler: {(success:Bool) in
            if(success){}
            else {
                let downloadURL = URL(string:"")!
                UIApplication.shared.open(downloadURL, options: [:], completionHandler: {(sucess:Bool) in
                    print(success)
                })
                
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SettingStorage())
    }
}
