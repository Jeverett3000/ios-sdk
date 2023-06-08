//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world = loadGridWorld(named: "7.4")
public let actor = Actor()

public func playgroundPrologue() {
    let randomCoordinates = [
        Coordinate(column: 0, row: 4),
        Coordinate(column: 1, row: 3),
        Coordinate(column: 3, row: 4),
        Coordinate(column: 3, row: 1),
    ]
    
    placeRandomItems(at: randomCoordinates)
    placeActor()
    placePortals()
    
    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomItems(at: randomCoordinates)
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

// MARK: Placement

func placeRandomItems(at coordinates: [Coordinate]) {
    // Place the Switches as only their open/closed is randomized.
    world.place(nodeOfType: Switch.self, at: coordinates)

    for coor in coordinates {
        world.place(RandomNode(resembling: Switch(open: true)), at: coor)
    }
}

func realizeRandomItems(at coordinates: [Coordinate]) {
    var onCoordinates = coordinates
    // Remove random coordinate to leave one Switch off.
    onCoordinates.remove(at: onCoordinates.randomIndex)
    
    for coor in onCoordinates {
        let switchNode = world.existingItem(ofType: Switch.self, at: coor)
        switchNode?.isOn = randomBool()
    }
}

func placePortals() {
    world.place(Portal(color: .blue), between: Coordinate(column: 1, row: 1), and: Coordinate(column: 2, row: 3))
}

func placeActor() {
    world.place(actor, facing: north, at: Coordinate(column: 0, row: 1))
}
