/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
import Foundation

class MethodChannelResponse {
    let result: Bool
    let arguments: Any?

    init(result res: Bool, arguments args: Any?) {
        self.result = res
        self.arguments = args
    }

    func toFlutterCompatibleType() -> [String: Any?] {
        return ["result": result, "arguments": arguments]
    }
}
