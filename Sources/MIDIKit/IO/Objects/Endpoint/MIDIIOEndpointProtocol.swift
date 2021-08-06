//
//  MIDIIOEndpointProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

// MARK: - Endpoint

public protocol MIDIIOEndpointProtocol: MIDIIOObjectProtocol {
    
}

extension MIDIIOEndpointProtocol {
    
    public static var objectType: MIDI.IO.ObjectType { .endpoint }
    
    /// The entity that owns the endpoint, if any. Virtual endpoints will not have an owning entity.
    public var entity: MIDI.IO.Entity? {
        
        try? MIDI.IO.getSystemEntity(for: coreMIDIObjectRef)
        
    }
    
}

extension Collection where Element : MIDIIOEndpointProtocol {
    
    /// Returns the collection as a collection of type-erased `AnyEndpoint` endpoints.
    public var asAnyEndpoints: [MIDI.IO.AnyEndpoint] {
        
        map { MIDI.IO.AnyEndpoint($0) }
        
    }
    
}