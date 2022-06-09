//
//  MIDIIOEndpointProtocol Comparison.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Equatable default implementation

// (conforming types to MIDIIOObjectProtocol just need to conform to Equatable and this implementation will be used)

extension MIDIIOEndpointProtocol {
    
    static public func == (lhs: Self, rhs: Self) -> Bool {
        
        lhs.uniqueID.coreMIDIUniqueID == rhs.uniqueID.coreMIDIUniqueID
        
    }
    
}

// MARK: - Hashable default implementation

// (conforming types to MIDIIOObjectProtocol just need to conform to Hashable and this implementation will be used)

extension MIDIIOEndpointProtocol {
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.uniqueID.coreMIDIUniqueID)
        
    }
    
}

// MARK: - Identifiable default implementation

// (conforming types to MIDIIOObjectProtocol just need to conform to Identifiable and this implementation will be used)

extension MIDIIOEndpointProtocol {
    
    public typealias ID = MIDI.IO.CoreMIDIUniqueID
    
    public var id: ID { uniqueID.coreMIDIUniqueID }
    
}
