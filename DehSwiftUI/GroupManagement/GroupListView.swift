//
//  GroupList.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2021/10/14.
//  Copyright © 2021 mmlab. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire
struct GroupListView: View {
    @State var selection: Int? = nil
    @State private var cancellable: AnyCancellable?
    @EnvironmentObject var settingStorage:SettingStorage
    @State var groups:[Group] = []
    init() {
        
    }
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            List (){
                    ForEach (self.groups) { group in
                        NavigationLink(tag: 3, selection: $selection) {
                                GroupDetailView()
                        } label: {
                            Button {
                                self.selection = 3
                            } label: {
                                ZStack {
                                    HStack{
                                        Image("leaderlisticon")
                                        VStack (alignment: .leading, spacing: 0){
                                            Text(group.name)
                                                .font(.system(size: 20, weight: .medium, design: .default))
                                                .foregroundColor(.black)
                                            Text("test")
                                                .font(.system(size: 16, weight: .light, design: .default))
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                        
                        }
                        
                    }
            }
            .onAppear(perform: {getGroupList()})
            .navigationTitle("Group list".localized)
            .navigationBarItems(trailing: HStack {
                NavigationLink(tag: 1, selection: $selection) {
                    GroupMessageView()
                } label: {
                    Button(action: {
                            self.selection = 1
                    }) {
                        Image(systemName: "message.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                    
                NavigationLink(tag: 2, selection: $selection) {
                    GroupSearchView()
                } label: {
                    Button(action: {
                            self.selection = 2
                    }) {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            })
            Button {
            } label: {
                Text("Create a group")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .font(.system(size: 30, weight: .bold, design: .default))
            }
            
        }
    }
}
extension GroupListView{
    func getGroupList(){
        let url = GroupGetUserGroupListUrl
        let parameters:[String:String] = [
            "user_id": "\(settingStorage.userID)",
            "coi_name": coi,
            "language": "中文",
        ]
        let publisher:DataResponsePublisher<GroupLists> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                print(values.debugDescription)
                self.groups = values.value?.results ?? []
                print(self.groups)
            })
    }
}
struct GroupManagement_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView()
    }
}
