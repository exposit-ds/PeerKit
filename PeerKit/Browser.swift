//
//  Browser.swift
//  CardsAgainst
//
//  Created by JP Simard on 11/3/14.
//  Copyright (c) 2014 JP Simard. All rights reserved.
//

import Foundation
import MultipeerConnectivity

let timeStarted = NSDate()

class Browser: NSObject, MCNearbyServiceBrowserDelegate {

    let mcSession: MCSession
    var contextData: NSData? = nil

    init(mcSession: MCSession) {
        self.mcSession = mcSession
        super.init()
    }

    var mcBrowser: MCNearbyServiceBrowser?

    func startBrowsing(serviceType: String, contextData: NSData? = nil) {
        self.contextData = contextData
        mcBrowser = MCNearbyServiceBrowser(peer: mcSession.myPeerID, serviceType: serviceType)
        mcBrowser?.delegate = self
        mcBrowser?.startBrowsingForPeers()
    }

    func stopBrowsing() {
        mcBrowser?.delegate = nil
        mcBrowser?.stopBrowsingForPeers()
    }

    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, toSession: mcSession, withContext: self.contextData, timeout: 30)
    }

    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // unused
    }
}
