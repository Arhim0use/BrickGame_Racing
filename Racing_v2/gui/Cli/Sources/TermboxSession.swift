//
//  TermboxManager.swift
//  AP2_BrickGame3_Swift
//
//  Created by Chingisbek Anvardinov on 31.10.2024.
//

import Foundation

import Termbox

struct TermboxSession {
    private static var _isInitialazed = false
    
    static var isInitialazed: Bool { get { _isInitialazed } }
    
    static func initialaze() {
        guard !_isInitialazed else {
            return
        }
        do {
            try Termbox.initialize()
            _isInitialazed = true
        } catch {
            _isInitialazed = false
        }
    }
    
    static func shutdown() {
        guard _isInitialazed else {
            return
        }
        
        Termbox.shutdown()
        _isInitialazed = false
    }
    
    static func peekEvent(timeOut: Int) -> UInt32? {
        guard _isInitialazed else {
            return nil
        }
    
        return getRawValue(event: Termbox.peekEvent(timoutInMilliseconds: Int32(timeOut)))
    }
    
    static private func getRawValue(event: Event?) -> UInt32? {
        
        guard let event = event else {
            return nil
        }
        
        if case .character(_ , let value) = event  {
            return value.value
        }
        
        guard case .key(_, let keyEvent) = event else {
            return nil
        }
        
        var rawValue: UInt32?
        
        switch keyEvent {
        case .arrowUp:
            rawValue = 0xffff-18
        case .arrowDown:
            rawValue = 0xffff-19
        case .arrowLeft:
            rawValue = 0xffff-20
        case .arrowRight:
            rawValue = 0xffff-21
        case .space:
            rawValue = 0x20
        default:
            break
        }

        return rawValue
    }
}
