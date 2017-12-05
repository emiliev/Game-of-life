//
//  Board.swift
//  Game-of-Life
//
//  Created by Emil Iliev on 12/5/17.
//  Copyright © 2017 Emil Iliev. All rights reserved.
//

import Foundation

class Board{
    
    private var tiles: [[Tile]] = [[]]
    var width: Int
    var height: Int
    
    init(width w: Int, height h: Int, tiles: [[Tile]]? = .none){
        width = w
        height = h
        
        loadTiles(tiles: tiles)
    }
    
    private func loadTiles(tiles savedTiles: [[Tile]]?){
        if let unwarpedTiles = savedTiles{
            tiles = unwarpedTiles
        }
        else{
            for row in 0...width{
                tiles.append([])
                for _ in 0...height{
                    let newTile = Tile(state: false)
                    tiles[row].append(newTile)
                }
            }
        }
    }
    
    func step(){
        for row in 0...width{
          for col in 0...height{
                let aliveNeightbours = countAliveNeighbours(ForCellWithXPos: row, andYPos: col)
                changeState(tile: tiles[row][col], aliveNeighbours: aliveNeightbours)
            }
        }
    }
    
    func clean(){
        for row in 0...width{
            for col in 0...height{
                tiles[row][col].alive = false
            }
        }
    }
    
    private func countAliveNeighbours(ForCellWithXPos xPos: Int, andYPos yPos: Int) -> Int{
        let horizontalRange = max(0, xPos - 1)...min(xPos + 1, width - 1)
        let verticalRange = max(0, yPos - 1)...min(yPos + 1, height - 1)
        
        var alive = 0
        for row in verticalRange{
            for col in horizontalRange{
                if row == xPos && col == yPos { continue }
            
                alive += tiles[row][col].alive ? 1 : 0
            }
        }
        
        return alive
    }
    
    private func changeState(tile: Tile, aliveNeighbours: Int){
        if tile.alive && !(2...3 ~= aliveNeighbours){
            tile.alive = false
        }
        else if !tile.alive && aliveNeighbours == 3{
            tile.alive = true
        }
    }

    func setTileValue(xPos: Int, yPos: Int, value: Bool){
        tiles[xPos][yPos].alive = value
    }
    
    func valueAt(xPos: Int, yPos: Int) -> Bool{
        return tiles[xPos][yPos].alive
    }
}







