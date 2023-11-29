//
//  PointsViewModel.swift
//  FingerDragMultiplayer
//
//  Created by aurelio on 15/07/22.
//

import Foundation


class PointsViewModel : ObservableObject
{
    @Published var punteggioGiocatore1 : Int = 0
    @Published var punteggioGiocatore2 : Int = 0
}
