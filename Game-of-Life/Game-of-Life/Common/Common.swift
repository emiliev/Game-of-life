//
//  Common.swift
//  Game-of-Life
//
//  Created by Emil Iliev on 12/5/17.
//  Copyright © 2017 Emil Iliev. All rights reserved.
//

import Foundation
import UIKit

extension TileView{
    
    convenience init(frame: CGRect, xPos: Int, yPos: Int){
        self.init(frame: frame)
        self.xPos = xPos
        self.yPos = yPos
    }
}

enum Entities{
    case Tiles
}

enum EntitiesKeys{
    enum TilesKeys{
        case xPos
        case yPos
        case alive
    }
}
