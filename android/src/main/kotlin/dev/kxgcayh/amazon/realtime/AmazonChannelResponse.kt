/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

package dev.kxgcayh.amazon.realtime

import com.google.gson.Gson

class AmazonChannelResponse(val result: Boolean, private val arguments: Any?) {
    fun toFlutterCompatibleType(): Map<String, Any?> {
        return mapOf("result" to result, "arguments" to arguments)
    }
}