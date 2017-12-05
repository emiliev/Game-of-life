//
//  GridView.swift
//  Game-of-Life
//
//  Created by Emil Iliev on 12/5/17.
//  Copyright © 2017 Emil Iliev. All rights reserved.
//

import UIKit
import CoreData
class GridView: UIView {

    private let TILE_HEIGHT: CGFloat = 10
    private let TILE_WIDTH: CGFloat = 10
    private var timer: Timer? = nil
    
    var board: Board = Board(width: 0, height: 0)
    var cells: [[TileView]] = [[]]
    
    lazy var numRows = Int(self.frame.width / TILE_WIDTH)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self._init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self._init()
    }
    
    func loadTiles(tiles: [NSManagedObject]){
        for tile in tiles{
            guard let xPos = tile.value(forKey: "\(EntitiesKeys.TilesKeys.xPos)") as? Int,
                let yPos = tile.value(forKey: "\(EntitiesKeys.TilesKeys.yPos)") as? Int,
                let isAlive = tile.value(forKey: "\(EntitiesKeys.TilesKeys.alive)") as? Bool
                else { continue }
            
            cells[xPos][yPos].alive = isAlive
            board.setTileValue(xPos: xPos, yPos: yPos, value: isAlive)
        }
    }
    
    private func _init(){
        self.board = Board(width: numRows, height: numRows)
        setupCells()
    }
    
    private func setupCells(){
        for row in 0...numRows{
            cells.append([])
            for col in 0...numRows{
                let frame = CGRect(x: CGFloat(col) * TILE_WIDTH, y: CGFloat(row) * TILE_HEIGHT, width: TILE_WIDTH, height: TILE_HEIGHT)
                let tileView = TileView(frame: frame, xPos: row, yPos: col)
                tileView.alive = false
                tileView.delegate = self
                cells[row].append(tileView)
                self.addSubview(tileView)
            }
        }
    }
    
    @objc func step(){
        board.step()
        for row in 0...numRows{
            for col in 0...numRows{
                cells[row][col].alive = board.valueAt(xPos: row, yPos: col)
            }
        }
        saveTiles()
    }

    private func saveTiles(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "\(Entities.Tiles)",
                                                in: managedContext)!
        for row in 0...numRows{
            for col in 0...numRows{
                let tile = NSManagedObject(entity: entity,
                                           insertInto: managedContext)
                tile.setValue(row, forKey: "\(EntitiesKeys.TilesKeys.xPos)")
                tile.setValue(col, forKey: "\(EntitiesKeys.TilesKeys.yPos)")
                tile.setValue(cells[row][col].alive, forKey: "\(EntitiesKeys.TilesKeys.alive)")
            }
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func cleanBoard(){
        board.clean()
        
        for row in 0...numRows{
            for col in 0...numRows{
                cells[row][col].alive = false
            }
        }
    }
}

extension GridView: TileViewDelegate{
 
    func tileTapped(tileView: TileView) {
        board.setTileValue(xPos: tileView.xPos, yPos: tileView.yPos, value: tileView.alive)
    }
}





