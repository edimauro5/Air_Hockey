//
//  PointDelegate.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 20/07/22.
//

import Foundation
import MultipeerConnectivity


class PointDelegate : NearbyServiceDelegate
{
    var session : MCSession
    var pointTracker : PointsViewModel
    
    init(session : MCSession,pointTracker : PointsViewModel)
    {
        self.session = session
        self.pointTracker = pointTracker
    }
    
    func didReceive(msg: String) {
        print(msg)
        let numeriStringati = msg.split(separator: ",")
        pointTracker.punteggioGiocatore1 = Int(numeriStringati[0])!
        pointTracker.punteggioGiocatore2 = Int(numeriStringati[1])!
    }
    
}
