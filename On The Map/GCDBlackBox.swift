//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Ricardo Griffith on 15/05/2016.
//  Copyright © 2016 DeveloperPlay. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}
