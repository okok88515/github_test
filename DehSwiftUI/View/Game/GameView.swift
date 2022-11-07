//
//  Game.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2021/4/27.
//  Copyright © 2021 mmlab. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire
struct GameView: View {
    @EnvironmentObject var settingStorage:SettingStorage
    @StateObject var gameVM:GameViewModel = GameViewModel()
//    @State private var cancellable: AnyCancellable?
//    @State var gameList : [gameListtuple] = []
    var body: some View {
        List{
            ForEach(gameVM.gameList,id: \.self){
                game in
                Section(header: Text(game.sectionName)){
                    ForEach(game.groupList ,id: \.id){
                        group in
                        NavigationLink(
                            destination: SessionView(group: group,gameVM: gameVM),
                            label: {
                                Text(group.name)
                                    .foregroundColor(Color.white)
                                    .allowsTightening(true)
                                    .lineLimit(1)
                                    .background(Color.init(UIColor(rgba:lightGreen)))
                            })
                    }
                }
                .listRowBackground(Color.init(UIColor(rgba: lightGreen)))
            }
            
        }
            .onAppear(perform: {
                if(gameVM.gameList.isEmpty){
                    gameVM.getGameList(userID:settingStorage.userID)
                }
                
            })
    }
}

extension GameView{
//    func getGameList(){
//        let url = privateGetGroupList
//        let parameters:[String:String] = [
//            "user_id": "\(settingStorage.userID)",
//            "coi_name": coi,
//            "language": "中文",
//        ]
//        var tempList : [gameListtuple] = []
//        let publisher:DataResponsePublisher<GroupLists> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
//        self.cancellable = publisher
//            .sink(receiveValue: {(values) in
//                print(values.debugDescription)
//                if let eventList = values.value?.eventList {
//                    tempList.append(gameListtuple("public".localized,eventList))
//                }
//                if let groupList = values.value?.groupList{
//                    if(!groupList.isEmpty){
//                        tempList.append(gameListtuple("private".localized,groupList))
//                    }}
//                self.gameList = tempList
//            })
//    }
   
}


struct Game_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(SettingStorage())
    }
}
