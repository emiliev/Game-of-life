//
//  TileView.swift
//  Game-of-Life
//
//  Created by Emil Iliev on 12/5/17.
//  Copyright © 2017 Emil Iliev. All rights reserved.
//

import UIKit

protocol TileViewDelegate: class{
    func tileTapped(tileView: TileView)
}

class TileView: UIView {

    var xPos: Int = 0
    var yPos: Int = 0
    var delegate: TileViewDelegate? = nil
    
    var alive: Bool = true{
        didSet{
            if oldValue != alive{
                DispatchQueue.main.async {
                    let stateColor: UIColor = self.alive ? .white : .black
                    self.backgroundColor = stateColor
                }
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        alive = !alive
        delegate?.tileTapped(tileView: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Could not find initializer")
    }
}
