//
//  Ball.swift
//  Sokoban_ver2
//
//  Created by Kim Tae Kyeong  on 2021/12/28.
//

import Foundation
class Ball {
    var id:Int
    var pose:(Int,Int)
    
    init(id:Int, pose:(Int,Int)){
        self.id = id
        self.pose = pose
    }
}

struct Hole {
    var id:Int
    var pose:(Int,Int)
}
