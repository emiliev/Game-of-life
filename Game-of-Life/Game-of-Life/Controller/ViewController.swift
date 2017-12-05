//
//  ViewController.swift
//  Game-of-Life
//
//  Created by Emil Iliev on 12/5/17.
//  Copyright © 2017 Emil Iliev. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var actionButton: UIButton!
    
    var tiles: [NSManagedObject] = []
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        fetchTiles()
        loadTiles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetAction(_ sender: Any) {
        gridView.cleanBoard()
    }
    
    @IBAction func action(_ sender: Any) {
        if let unwarpedTimer = timer{
            unwarpedTimer.invalidate()
            timer = nil
            gridView.isUserInteractionEnabled = true
            actionButton.setTitle("Start", for: .normal)
        }
        else{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(makeStep), userInfo: nil, repeats: true)
            gridView.isUserInteractionEnabled = false
            actionButton.setTitle("Stop", for: .normal)
        }
    }
    
    @objc private func makeStep(){
        self.gridView.step()
    }
    
    private func fetchTiles(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "\(Entities.Tiles)")
        do {
            tiles = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func loadTiles(){
        guard tiles.isEmpty == false else { return }
        
        gridView.loadTiles(tiles: tiles)
    }
}

//MARK:- ScrollViewDelegate
extension ViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return gridView
    }
}
