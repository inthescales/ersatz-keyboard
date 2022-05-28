//  Created by Alexei Baboulevitch on 7/19/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.

/// Represents a cardinal direction
enum Direction: Int, CustomStringConvertible {
    case left = 0, up, right, down

    /// English string representing the direction
    var description: String {
        get {
            switch self {
            case .left:
                return "Left"
            case .right:
                return "Right"
            case .up:
                return "Up"
            case .down:
                return "Down"
            }
        }
    }
    
    /// The next direction clockwise from this one
    var nextClockwise: Direction {
        switch self {
        case .left:
            return .up
        case .right:
            return .down
        case .up:
            return .right
        case .down:
            return .left
        }
    }
    
    /// The next direction counterclockwise from this one
    var nextCounterClockwise: Direction {
        switch self {
        case .left:
            return .down
        case .right:
            return .up
        case .up:
            return .left
        case .down:
            return .right
        }
    }
    
    /// The opposite cardinal direction from this one
    var opposite: Direction {
        switch self {
        case .left:
            return .right
        case .right:
            return .left
        case .up:
            return .down
        case .down:
            return .up
        }
    }
}
