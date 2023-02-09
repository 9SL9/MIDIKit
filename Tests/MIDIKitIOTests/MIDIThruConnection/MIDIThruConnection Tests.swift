//
//  MIDIThruConnection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if shouldTestCurrentPlatform && !targetEnvironment(simulator)

import XCTest
@_implementationOnly import MIDIKitInternals
@testable import MIDIKitIO
import MIDIKitC
import CoreMIDI

final class MIDIThruConnection_Tests: XCTestCase {
    override func setUp() {
        wait(sec: 0.2)
    }
    
    @ThreadSafeAccess private var connEvents: [MIDIEvent] = []
    
    func testNonPersistentThruConnection_DefaultMethod() throws {
        try runNonPersistentThruConnection(using: nil)
    }
    
    func testNonPersistentThruConnection_UsingWorkaround() throws {
        try runNonPersistentThruConnection(using: CMIDIThruConnectionCreateNonPersistent)
    }
    
    private func runNonPersistentThruConnection(
        using nonPersistentConnectionBlock: (
            (CFData, UnsafeMutablePointer<CoreMIDIThruConnectionRef>) -> OSStatus
        )?
    ) throws {
        if nonPersistentConnectionBlock == nil {
             try XCTSkipIf(
                 !MIDIThruConnection.isNonPersistentThruConnectionsSupported,
                 MIDIThruConnection.midiThruConnectionsNotSupportedOnCurrentPlatformErrorReason
             )
        }
        
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        wait(sec: 0.1)
        
        defer {
            // as a failsafe, clean up any persistent connections with an empty owner ID.
            // tnis is to account for the possible re-emergence of the Core MIDI thru bug
            manager.removeAllUnmanagedPersistentThruConnections(ownerID: "")
        }
        
        // initial state
        connEvents.removeAll()
        
        // create virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests thruConnection In",
            tag: input1Tag,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .events(translateMIDI1NoteOnZeroVelocityToNoteOff: false) { events in
                self.connEvents.append(contentsOf: events)
            }
        )
        let input1 = try XCTUnwrap(manager.managedInputs[input1Tag])
        // let input1ID = try XCTUnwrap(input1.uniqueID)
        // let input1Ref = try XCTUnwrap(input1.coreMIDIInputPortRef)
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests thruConnection Out",
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output1 = try XCTUnwrap(manager.managedOutputs[output1Tag])
        // let output1ID = try XCTUnwrap(output1.uniqueID)
        // let output1Ref = try XCTUnwrap(output1.coreMIDIOutputPortRef)
        
        wait(sec: 0.2)
        
        // add new connection
        
        let connTag = "testThruConnection"
        try manager.addThruConnection(
            outputs: [output1.endpoint],
            inputs: [input1.endpoint],
            tag: connTag,
            lifecycle: .nonPersistent,
            using: nonPersistentConnectionBlock
        )
        
        XCTAssertNotNil(manager.managedThruConnections[connTag])
        XCTAssert(manager.managedThruConnections[connTag]?.coreMIDIThruConnectionRef != .init())
        
        wait(sec: 0.2)
        
        // send an event - it should be received by the input
        try output1.send(event: .start())
        wait(for: connEvents, equals: [.start()], timeout: 1.0)
        connEvents = []
        
        manager.remove(.nonPersistentThruConnection, .withTag(connTag))
        
        XCTAssertNil(manager.managedThruConnections[connTag])
        
        // send an event - it should not be received by the input
        try output1.send(event: .start())
        wait(sec: 0.2) // wait a bit in case an event is sent
        XCTAssertEqual(connEvents, [])
        connEvents = []
        
        // Due to a Swift Core MIDI bug, all thru connections are created as persistent.
        // - See ThruConnection.swift for details
        let conns = try manager.unmanagedPersistentThruConnections(ownerID: "")
        
        XCTAssert(conns.isEmpty)
    }
    
    func testPersistentThruConnection() throws {
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        wait(sec: 0.1)
        
        // initial state
        connEvents.removeAll()
        let ownerID = "com.orchetect.midikit.testNonPersistentThruConnection"
        manager.removeAllUnmanagedPersistentThruConnections(ownerID: ownerID)
    
        // create virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests thruConnection In",
            tag: input1Tag,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .events(translateMIDI1NoteOnZeroVelocityToNoteOff: false) { events in
                self.connEvents.append(contentsOf: events)
            }
        )
        let input1 = try XCTUnwrap(manager.managedInputs[input1Tag])
        // let input1ID = try XCTUnwrap(input1.uniqueID)
        // let input1Ref = try XCTUnwrap(input1.coreMIDIInputPortRef)
        
        wait(sec: 0.2)
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests thruConnection Out",
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output1 = try XCTUnwrap(manager.managedOutputs[output1Tag])
        // let output1ID = try XCTUnwrap(output1.uniqueID)
        // let output1Ref = try XCTUnwrap(output1.coreMIDIOutputPortRef)
        
        wait(sec: 0.2)
        
        // add new connection
        
        let connTag = "testThruConnection"
        try manager.addThruConnection(
            outputs: [output1.endpoint],
            inputs: [input1.endpoint],
            tag: connTag,
            lifecycle: .persistent(ownerID: ownerID)
        )
        
        wait(sec: 0.2)
        
        XCTAssertEqual(
            try manager.unmanagedPersistentThruConnections(ownerID: ownerID).count,
            1
        )
        
        // send an event - it should be received by the input
        try output1.send(event: .start())
        wait(for: connEvents, equals: [.start()], timeout: 1.0)
        connEvents = []
        
        manager.removeAllUnmanagedPersistentThruConnections(ownerID: ownerID)
        
        XCTAssertEqual(
            try manager.unmanagedPersistentThruConnections(ownerID: ownerID).count,
            0
        )
        
        XCTAssertEqual(manager.managedThruConnections.count, 0)
        
        // send an event - it should not be received by the input
        try output1.send(event: .start())
        wait(sec: 0.2) // wait a bit in case an event is sent
        XCTAssertEqual(connEvents, [])
        connEvents = []
    }
    
    func testGetParams_DefaultMethod() throws {
        try runGetParams(using: nil)
    }
    
    func testGetParams_UsingWorkaround() throws {
        try runGetParams(using: CMIDIThruConnectionCreateNonPersistent)
    }
    
    /// Tests getting thru connection parameters from Core MIDI after creating the thru connection
    /// and verifying they are correct.
    private func runGetParams(
        using nonPersistentConnectionBlock: (
            (CFData, UnsafeMutablePointer<CoreMIDIThruConnectionRef>) -> OSStatus
        )?
    ) throws {
        if nonPersistentConnectionBlock == nil {
            try XCTSkipIf(
                !MIDIThruConnection.isNonPersistentThruConnectionsSupported,
                MIDIThruConnection.midiThruConnectionsNotSupportedOnCurrentPlatformErrorReason
            )
        }
        
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        try manager.start()
        wait(sec: 0.1)
        
        defer {
            // as a failsafe, clean up any persistent connections with an empty owner ID.
            // tnis is to account for the possible re-emergence of the Core MIDI thru bug
            manager.removeAllUnmanagedPersistentThruConnections(ownerID: "")
        }
    
        // initial state
        connEvents.removeAll()
        
        // create virtual input
        let input1Tag = "input1"
        try manager.addInput(
            name: "MIDIKit IO Tests thruConnection In",
            tag: input1Tag,
            uniqueID: .adHoc,
            // allow system to generate random ID each time, without persistence
            receiver: .events(translateMIDI1NoteOnZeroVelocityToNoteOff: false) { events in
                self.connEvents.append(contentsOf: events)
            }
        )
        let input1 = try XCTUnwrap(manager.managedInputs[input1Tag])
        let input1ID = try XCTUnwrap(input1.uniqueID)
        let input1Ref = try XCTUnwrap(input1.coreMIDIInputPortRef)
        
        // create a virtual output
        let output1Tag = "output1"
        try manager.addOutput(
            name: "MIDIKit IO Tests thruConnection Out",
            tag: output1Tag,
            uniqueID: .adHoc // allow system to generate random ID each time, without persistence
        )
        let output1 = try XCTUnwrap(manager.managedOutputs[output1Tag])
        let output1ID = try XCTUnwrap(output1.uniqueID)
        let output1Ref = try XCTUnwrap(output1.coreMIDIOutputPortRef)
        
        wait(sec: 0.2)
        
        // add new connection
        
        let connTag = "testThruConnection"
        try manager.addThruConnection(
            outputs: [output1.endpoint],
            inputs: [input1.endpoint],
            tag: connTag,
            lifecycle: .nonPersistent,
            using: CMIDIThruConnectionCreateNonPersistent
        )
        
        XCTAssertNotNil(manager.managedThruConnections[connTag])
        XCTAssert(manager.managedThruConnections[connTag]?.coreMIDIThruConnectionRef != .init())
        
        wait(sec: 0.2)
        
        let connRef = manager.managedThruConnections[connTag]!.coreMIDIThruConnectionRef!
        let getParams = try XCTUnwrap(try getThruConnectionParameters(ref: connRef))
        
        XCTAssertEqual(getParams.numSources, 1)
        XCTAssertEqual(getParams.sources.0.endpointRef, output1Ref)
        XCTAssertEqual(getParams.sources.0.uniqueID, output1ID)
        XCTAssertEqual(getParams.numDestinations, 1)
        XCTAssertEqual(getParams.destinations.0.endpointRef, input1Ref)
        XCTAssertEqual(getParams.destinations.0.uniqueID, input1ID)
        
        manager.remove(.nonPersistentThruConnection, .withTag(connTag))
        
        XCTAssertNil(manager.managedThruConnections[connTag])
    }
}

#endif
