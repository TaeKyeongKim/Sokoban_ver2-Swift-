import Foundation


let input = """
Stage 1
#####
#OoP#
#####
=====
Stage 2
  #######
###  O  ###
#    o    #
# Oo P oO #
###  o  ###
 #   O  #
 ########
============
Stage 3
  #######
  #  O  #
###     ###
#    o    #
# Oo P oO #
###  o  ###
 #   O  #
 ########
"""

// 0.MARK: Variable initalization
// Initialize score, and inital information of Hole & Ball
var score : Int = 0
var balls = [Ball]()
var holes = [Hole]()

// Record Trace of each ball
var traces = [(Int,(Int,Int))]()


// Record which ball went to which hole.
// Key = ballId, Value = holeI
var scoreRecord = [Int : Int]()

var gameOn = true

// 1.MARK: Process input text stage into array
var stages = initStage(input)
// 2.MARK: Display desired stage
var level = 0
var maxLevel = stages.count

// 3.MARK: Get stage according to level
var currentStage = getCurrentStage(stageLevel: level, totalStages: stages)



// 4.MARK: Move "P" according to user's input.
// Retrieve current position of "P" and initailize holes and balls.
var playerPosition = getPlayerPose(level,stages)

while gameOn {
    
    // 5.MARK: Gets user's input command
    let userInput = getInput()
    
    // 6.MARK: Process user's input
    processInput(inputs: userInput, currStage: &currentStage, playerPose: &playerPosition)
    
    // 7.MARK: Manages level of the game
    if (balls.count == score){
        levelUp()
    }
    
}



func printRecord () {
    for (key,value) in scoreRecord{

        print("Ball Id: \(key), Key Id: \(value)")
        
    }
    
    //TODO: Implement traces array to visualize trace of ball
}
func initStage(_ input:String) -> [[[Character]]]{
    
    var totalStages = [[[Character]]]()
    var aStage = [[Character]]()
    
    //Seperate each lines and exclude String of Stage1,2,3....
    var inputStage = input.components(separatedBy: "\n")
    inputStage.removeAll(where: {$0.contains("Stage")})
    
    for i in 0..<inputStage.count {
        
        if (inputStage[i].contains("=")){
            //Adding a stage into totalStages and remove a stage array
            totalStages.append(aStage)
            aStage.removeAll()
            continue
        }else if(i == (inputStage.count)-1){
            //Adding segmentStage into a stage
            let segmentStage = Array(inputStage[i])
            aStage.append(segmentStage)
            
            //Adding a stage into totalStages and remove a stage array
            totalStages.append(aStage)
            aStage.removeAll()
            continue
        }
        else{
            //Adding segmentStage into a stage
            let segmentStage = Array(inputStage[i])
            aStage.append(segmentStage)
            
        }
        
    }
    
    return totalStages
}


// 2. TODO: Display & Get desired stage
func getCurrentStage(stageLevel: Int, totalStages:[[[Character]]]) -> [[Character]]{
    let levelIndex = stageLevel
    let currentStage:[[Character]] = totalStages[levelIndex]
    
    print(" ►►►►►► Stage \(stageLevel+1) ◄◄◄◄◄◄")
    for seg in totalStages[levelIndex] {
        for eachSeg in seg {
            print(eachSeg, terminator: "")
        }
        print("")
    }
    return currentStage
}


// 3. TODO: Get user's input
func getInput () -> [Character] {
    var inputArray:[Character]
    if let input = readLine(){
        inputArray = Array(input.uppercased())
        return inputArray
    }
    return [Character]()
}


// 4. TODO: Get position of the player
func getPlayerPose(_ level:Int, _ stages:[[[Character]]]) -> (Int,Int){
    var pose:(Int,Int) = (0,0)
    var ballId = 0
    var holdId = 0
    
    for i in 0..<stages[level].count{
        
        for k in 0..<stages[level][i].count{
            
            if stages[level][i][k] == Objects.Ball.rawValue {
              ballId += 1
              let ball = Ball(id: ballId, pose: (k,i))
                balls.append(ball)
            }
            
            else if stages[level][i][k] == Objects.Hole.rawValue{
              holdId += 1
              let hole = Hole(id: holdId, pose: (k,i))
                holes.append(hole)
            }
            
            else if stages[level][i][k] == Objects.Player.rawValue {
               pose = (k,i)
//               return pose
            }
            
            
        }
        
    }
    return pose
}

//W,A,S,D
enum Movement:Character {
    case Up = "W"
    case Right = "D"
    case Down = "S"
    case Left = "A"
}

// Declare objects
enum Objects:Character {
    case Ball = "o"
    case Wall = "#"
    case Hole = "O"
    case Empty = " "
    case Player = "P"
}



func processInput( inputs:[Character], currStage: inout [[Character]], playerPose: inout (Int,Int)){
    
    //Declare an empty Map
    var updatedMap = [[Character]] ()
    
    // MARK: Validate user's input
    for item in inputs {
        
        
        if let movement = Movement(rawValue: item){
            
            print(" ⛏ Processing user's input: \(item)  → It is going \(movement) ....")
            print("")
             updatedMap = movePlayer(movement,&currStage,&playerPose)
            
            //Draw Updated Map
            for i in updatedMap{
                for k in i {
                    print (k,terminator: "")
                }
                print("")
            }
//            print("Updated Player position : (\(playerPose.0) , \(playerPose.1))")
            
        }
        else if item == "R" {
            resetGame(currStage:&currStage , playerPose: &playerPose)
        }
        else{
            print("ERROR: \(item) is not valid command.")
        }
        
        
    }
}

func movePlayer(_ movement:Movement, _ currStage: inout [[Character]], _ playerPose: inout(Int,Int)) -> [[Character]]{
    
    
    var yStep:Int = 0
    var xStep:Int = 0
    
    switch movement {
    case .Up:
        //TODO: Check if there is obstacle ahead of input command
        yStep = -1
        currStage = processMove (currStage: &currStage, yStep: yStep, xStep: xStep, playerPose: &playerPose)
        return currStage
    
    case .Right:
        xStep = 1
        currStage = processMove (currStage: &currStage, yStep: yStep, xStep: xStep, playerPose: &playerPose)
        return currStage

    case .Down:
        yStep = 1
        currStage = processMove (currStage: &currStage, yStep: yStep, xStep: xStep, playerPose: &playerPose)
        return currStage

    case .Left:
        xStep = -1
        currStage = processMove (currStage: &currStage, yStep: yStep, xStep: xStep, playerPose: &playerPose)
        return currStage


    }
    
}

func processMove (currStage: inout [[Character]], yStep:  Int, xStep:  Int, playerPose: inout(Int,Int)) -> [[Character]]{
    

    if let playerAhead = Objects(rawValue: currStage[playerPose.1+yStep][playerPose.0+xStep]){

        //If there is no Obstacles ahead or empty space, make the current position to be blank
        if playerAhead == Objects.Ball||playerAhead==Objects.Empty{
            currStage[playerPose.1][playerPose.0] = Objects.Empty.rawValue
            
            // move the player position
            playerPose.1 = playerPose.1 + yStep
            playerPose.0 = playerPose.0 + xStep
            
            //Update Player with new position
            currStage[(playerPose.1)][playerPose.0] = Objects.Player.rawValue
            
            //TODO: Move the position of Ball
            if playerAhead == Objects.Ball{
                
                //MARK: Updated Ball position = updated Player's position + step
                var ballPose = (playerPose.0+xStep,playerPose.1+yStep)

                //MARK: addTrace() adds traces of ball, and also updates its position.
                addTrace(ballPose, yStep, xStep)
                
                
                //MARK: Updataed Ball Position encounters to Wall or another Ball
                if currStage[(ballPose.1)][ballPose.0] == Objects.Wall.rawValue||currStage[(ballPose.1)][ballPose.0] == Objects.Ball.rawValue{
                    print("Can't move further")
                    playerPose.1 -= yStep
                    playerPose.0 -= xStep
                    ballPose.1 -=  yStep
                    ballPose.0 -=  xStep
                    currStage[(ballPose.1)][ballPose.0] = Objects.Ball.rawValue
                    currStage[(playerPose.1)][playerPose.0] = Objects.Player.rawValue
                    return currStage
                    
                }
                //MARK: Ball Position encounters to a Hole
                else if currStage[(ballPose.1)][ballPose.0] == Objects.Hole.rawValue {
                    
                    //Add ball id and position into recordScore
                    let ballId = traces.last!.0
                    let ballPose = traces.last!.1
                    //check which hole matches with last position of ball
                    for hole in holes {
                        if hole.pose == ballPose{
                            let holeId = hole.id
                            scoreRecord.updateValue(holeId, forKey: ballId)
                        }
                            
                    }
                    score += 1
                    currStage[(ballPose.1)][ballPose.0] = Objects.Empty.rawValue
                                        
                    print("Nice! Current Score : \(score)/\(balls.count)")
                    
                    
                    
                }else{
                    //MARK: Update ball position
                    currStage[(ballPose.1)][ballPose.0] = Objects.Ball.rawValue
                }
                
            }
            return currStage
            
        }
        else{
            //MARK: Player incounters Obstacles
            print("Warning : \(playerAhead) Detected!")
            return currStage
        }
    }
    return currStage
}


func addTrace (_ updatedBallPose:(Int,Int), _ yStep:Int, _ xStep:Int ) {
    
    for ball in balls {
        
            let prevBallPose = (updatedBallPose.0 + -xStep, updatedBallPose.1 + -yStep)
        
            //If the ball is moved from initialized(Updated) poisition.
            if ball.pose == prevBallPose {
                
                //Store the current Ball position into trace
                let traceSegment = (ball.id,updatedBallPose)
                traces.append(traceSegment)
                
                //Update the ball position.
                ball.pose = updatedBallPose

            }
    }
}


func resetGame (currStage: inout [[Character]], playerPose: inout (Int,Int))  {
    resetInfo ()
    currStage = getCurrentStage(stageLevel: level, totalStages: stages)
    playerPose = getPlayerPose(level,stages)
}

func levelUp () {
    level += 1
    if level == maxLevel{
        print("▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌ ")
        print("▐      Congrats! you have completed the Game      ▌ ")
        print("▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌ ")

        gameOn = false
        exit(0)
        
    }
    resetInfo()
    currentStage = getCurrentStage(stageLevel: level, totalStages: stages)
    playerPosition = getPlayerPose(level,stages)
}

func resetInfo () {
    score = 0
    balls.removeAll()
    traces.removeAll()
    traces.removeAll()
    scoreRecord.removeAll()
}
