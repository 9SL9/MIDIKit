//
//  AnyEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.IO {
    
    /// Type-erased box that can contain `MIDI.IO.InputEndpoint` or `MIDI.IO.OutputEndpoint`.
    public struct AnyEndpoint: _MIDIIOEndpointProtocol {
        
        public var objectType: MIDI.IO.ObjectType
        
        public let endpointType: MIDI.IO.EndpointType
        
        // MARK: MIDIIOObjectProtocol
        
        public let name: String
        
        public let displayName: String
        
        public let uniqueID: MIDI.IO.UniqueID
        
        public let coreMIDIObjectRef: MIDI.IO.EndpointRef
        
        // MARK: Init
        
        internal init<E: _MIDIIOEndpointProtocol>(_ base: E) {
            
            switch base {
            case is MIDI.IO.InputEndpoint:
                objectType = .inputEndpoint
                endpointType = .input
                
            case is MIDI.IO.OutputEndpoint:
                objectType = .outputEndpoint
                endpointType = .output
                
            case let otherCast as Self:
                objectType = otherCast.objectType
                endpointType = otherCast.endpointType
                
            default:
                preconditionFailure("Unexpected MIDIIOEndpointProtocol type: \(base)")
                
            }
            
            self.coreMIDIObjectRef = base.coreMIDIObjectRef
            self.name = base.name
            self.displayName = base.displayName
            self.uniqueID = .init(base.uniqueID)
            
        }
        
    }
    
}

extension MIDI.IO.AnyEndpoint: Equatable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension MIDI.IO.AnyEndpoint: Hashable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension MIDI.IO.AnyEndpoint: Identifiable {
    // default implementation provided by MIDIIOObjectProtocol
}

extension MIDI.IO.AnyEndpoint: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        "AnyEndpoint(name: \(name.quoted), uniqueID: \(uniqueID))"
        
    }
    
}

// MARK: - Extensions

extension _MIDIIOEndpointProtocol {
    
    /// Returns the endpoint as a type-erased `AnyEndpoint`.
    public func asAnyEndpoint() -> MIDI.IO.AnyEndpoint {
        
        .init(self)
        
    }
    
}

extension Collection where Element : MIDIIOEndpointProtocol {
    
    /// Returns the collection as a collection of type-erased `AnyEndpoint` endpoints.
    public func asAnyEndpoints() -> [MIDI.IO.AnyEndpoint] {
        
        map { $0.asAnyEndpoint() }
        
    }
    
}
