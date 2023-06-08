//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world = loadGridWorld(named: "7.9")
public let actor = Actor()

public func playgroundPrologue() {
    
    placeRandomItems()
    placeActor()
    placePortals()
    
    
    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomItems()
    }
    //// ----
}

// Called from LiveView.swift to initially set the LiveView.
public func presentWorld() {
    setUpLiveViewWith(world)
    
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}

func placeActor() {
    world.place(actor, facing: north, at: Coordinate(column: 3, row: 1))
}

func realizeRandomItems() {
    let switches = [
        Coordinate(column: 0, row: 2),
        Coordinate(column: 1, row: 0),
        Coordinate(column: 1, row: 7),
        Coordinate(column: 2, row: 7),
        Coordinate(column: 3, row: 7),
        Coordinate(column: 3, row: 5),
        Coordinate(column: 3, row: 4),
        Coordinate(column: 3, row: 3),
        Coordinate(column: 3, row: 0),
        Coordinate(column: 4, row: 7),
        Coordinate(column: 5, row: 1),
        Coordinate(column: 5, row: 3),
        Coordinate(column: 5, row: 4),
        Coordinate(column: 5, row: 5),
        Coordinate(column: 5, row: 6),
        
        ]
    for coordinate in switches {
        world.place(Switch(open: randomBool()), at: coordinate)
    }
    
    let item = [
        Coordinate(column: 0, row: 4),
        
        ]
    world.placeGems(at: item)
}

func placeRandomItems() {
    let switches = [
        Coordinate(column: 0, row: 2),
        Coordinate(column: 1, row: 0),
        Coordinate(column: 1, row: 7),
        Coordinate(column: 2, row: 7),
        Coordinate(column: 3, row: 7),
        Coordinate(column: 3, row: 5),
        Coordinate(column: 3, row: 4),
        Coordinate(column: 3, row: 3),
        Coordinate(column: 3, row: 0),
        Coordinate(column: 4, row: 7),
        Coordinate(column: 5, row: 1),
        Coordinate(column: 5, row: 3),
        Coordinate(column: 5, row: 4),
        Coordinate(column: 5, row: 5),
        Coordinate(column: 5, row: 6),
        
        ]
    let switchNode = Switch()
    for eachSwitch in switches {
        world.place(RandomNode(resembling: switchNode), at: eachSwitch)
    }
}

func placePortals() {
    world.place(Portal(color: .blue), between: Coordinate(column: 0, row: 7), and: Coordinate(column: 4, row: 6))
}
