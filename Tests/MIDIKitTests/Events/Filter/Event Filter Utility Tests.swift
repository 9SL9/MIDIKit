//
//  Event Filter Utility Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class MIDIEventFilter_Utility_Tests: XCTestCase {
    
    func testMetadata() {
        
        // isUtility
        
        let events = kEvents.Utility.oneOfEachEventType
        
        events.forEach {
            XCTAssertFalse($0.isChannelVoice)
            XCTAssertFalse($0.isSystemCommon)
            XCTAssertFalse($0.isSystemExclusive)
            XCTAssertFalse($0.isSystemRealTime)
            XCTAssertTrue($0.isUtility)
        }
        
        // isUtility(ofType:)
        
        XCTAssertTrue(
            MIDI.Event.noOp(group: 0)
                .isUtility(ofType: .noOp)
        )
        
        XCTAssertFalse(
            MIDI.Event.noOp(group: 0)
                .isUtility(ofType: .jrClock)
        )
        
        // isUtility(ofTypes:)
        
        XCTAssertTrue(
            MIDI.Event.noOp(group: 0)
                .isUtility(ofTypes: [.noOp])
        )
        
        XCTAssertTrue(
            MIDI.Event.noOp(group: 0)
                .isUtility(ofTypes: [.noOp, .jrClock])
        )
        
        XCTAssertFalse(
            MIDI.Event.noOp(group: 0)
                .isUtility(ofTypes: [.jrClock])
        )
        
        XCTAssertFalse(
            MIDI.Event.noOp(group: 0)
                .isUtility(ofTypes: [])
        )
        
    }
    
    // MARK: - only
    
    func testFilter_only() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(utility: .only)
        
        let expectedEvents = kEvents.Utility.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_onlyType() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(utility: .onlyType(.noOp))
        
        let expectedEvents = [kEvents.Utility.noOp]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_onlyTypes() {
        
        let events = kEvents.oneOfEachEventType
        
        var filteredEvents: [MIDI.Event]
        var expectedEvents: [MIDI.Event]
        
        filteredEvents = events.filter(utility: .onlyTypes([.noOp]))
        expectedEvents = [kEvents.Utility.noOp]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(utility: .onlyTypes([.noOp, .jrClock]))
        expectedEvents = [kEvents.Utility.noOp, kEvents.Utility.jrClock]
        XCTAssertEqual(filteredEvents, expectedEvents)
        
        filteredEvents = events.filter(utility: .onlyTypes([]))
        expectedEvents = []
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    // MARK: - keep
    
    func testFilter_keepType() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(utility: .keepType(.noOp))
        
        var expectedEvents: [MIDI.Event] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += [
            kEvents.Utility.noOp
        ]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_keepTypes() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(utility: .keepTypes([.noOp, .jrClock]))
        
        var expectedEvents: [MIDI.Event] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += [
            kEvents.Utility.noOp,
            kEvents.Utility.jrClock
        ]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    // MARK: - drop
    
    func testFilter_drop() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(utility: .drop)
        
        var expectedEvents: [MIDI.Event] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_dropType() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(utility: .dropType(.noOp))
        
        var expectedEvents: [MIDI.Event] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += [
            kEvents.Utility.jrClock,
            kEvents.Utility.jrTimestamp
        ]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
    func testFilter_dropTypes() {
        
        let events = kEvents.oneOfEachEventType
        
        let filteredEvents = events.filter(utility: .dropTypes([.noOp, .jrClock]))
        
        var expectedEvents: [MIDI.Event] = []
        expectedEvents += kEvents.ChanVoice.oneOfEachEventType
        expectedEvents += kEvents.SysCommon.oneOfEachEventType
        expectedEvents += kEvents.SysEx.oneOfEachEventType
        expectedEvents += kEvents.SysRealTime.oneOfEachEventType
        expectedEvents += [
            kEvents.Utility.jrTimestamp
        ]
        
        XCTAssertEqual(filteredEvents, expectedEvents)
        
    }
    
}

#endif
