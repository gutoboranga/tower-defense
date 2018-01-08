//
//  EndOfGame.swift
//  TowerDefense
//
//  Created by Augusto Boranga on 01/12/17.
//  Copyright © 2017 gatosDeSchnorrdinger. All rights reserved.
//

import Foundation

enum EndOfGame {
    
    case won
    case lost
    
    init(didWin: Bool) {
        if (didWin) {
            self = .won
        } else {
            self = .lost
        }
    }
    
    var title : String {
        switch self {
        case .won:
            return "You won!"
        default:
            return "Game over"
        }
    }
    
    var description : String {
        switch self {
        case .won:
            return "You saved mars from human invasion :-D"
        default:
            return "Oh no! Mars is fated to fail now :-("
        }
    }
}

