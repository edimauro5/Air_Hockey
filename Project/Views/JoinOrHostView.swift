//
//  JoinOrHostView.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 19/07/22.
//

import SwiftUI


struct JoinOrHostView: View {
    @Binding var language : String
    @EnvironmentObject var nearbyService : NearbyService
    @State var joining : Bool = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack
        {
            Button(JoinOrHostView.LANGUAGESDICTS[language]!["host"]!, action:
                    {
                nearbyService.beginHosting()
            })
            .padding(EdgeInsets(
                top: 150, leading: 0, bottom: 0, trailing: 0))
            .font(
                .system(size: 25))
            Button(JoinOrHostView.LANGUAGESDICTS[language]!["join"]!, action:
                    {
                joining = true
                nearbyService.beginBrowsing()
            })
            .padding(EdgeInsets(
                top: 50, leading: 0, bottom: 200, trailing: 0))
            .font(.system(size: 25))
        }
        .sheet(isPresented: $joining, onDismiss: {presentationMode.wrappedValue.dismiss()}, content: {PeerView()})
    }
    
    static let WORDSEN = [
        "host":"Host",
        "join":"Join"
    ]
    
    static let WORDSIT = [
        "host":"Ospita",
        "join":"Partecipa"
    ]
    
    static var LANGUAGESDICTS = ["en" : WORDSEN,"it" : WORDSIT]
}
