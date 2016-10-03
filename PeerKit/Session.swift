//
//  Session.swift
//  CardsAgainst
//
//  Created by JP Simard on 11/3/14.
//  Copyright (c) 2014 JP Simard. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public protocol SessionDelegate {
    func connecting(_ myPeerID: MCPeerID, toPeer peer: MCPeerID)
    func connected(_ myPeerID: MCPeerID, toPeer peer: MCPeerID)
    func disconnected(_ myPeerID: MCPeerID, fromPeer peer: MCPeerID)
    func receivedData(_ myPeerID: MCPeerID, data: Data, fromPeer peer: MCPeerID)
    func finishReceivingResource(_ myPeerID: MCPeerID, resourceName: String, fromPeer peer: MCPeerID, atURL localURL: URL)
}

open class Session: NSObject, MCSessionDelegate {
    open fileprivate(set) var myPeerID: MCPeerID
    var delegate: SessionDelegate?
    open fileprivate(set) var mcSession: MCSession

    public init(displayName: String, delegate: SessionDelegate? = nil) {
        myPeerID = MCPeerID(displayName: displayName)
        self.delegate = delegate
        mcSession = MCSession(peer: myPeerID)
        super.init()
        mcSession.delegate = self
    }

    open func disconnect() {
        self.delegate = nil
        mcSession.delegate = nil
        mcSession.disconnect()
    }

    // MARK: MCSessionDelegate

    open func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            case .connecting:
                delegate?.connecting(myPeerID, toPeer: peerID)
            case .connected:
                delegate?.connected(myPeerID, toPeer: peerID)
            case .notConnected:
                delegate?.disconnected(myPeerID, fromPeer: peerID)
        }
    }

    open func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        delegate?.receivedData(myPeerID, data: data, fromPeer: peerID)
    }

    open func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // unused
    }

    open func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // unused
    }

    open func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        if (error == nil) {
            delegate?.finishReceivingResource(myPeerID, resourceName: resourceName, fromPeer: peerID, atURL: localURL)
        }
    }
}
