/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
 
package com.amazonaws.services.chime.flutterdemo

enum class MethodCall(val call: String) {
    manageAudioPermissions("manageAudioPermissions"),
    manageVideoPermissions("manageVideoPermissions"),
    initialAudioSelection("initialAudioSelection"),
    join("join"),
    stop("stop"),
    leave("leave"),
    drop("drop"),
    mute("mute"),
    unmute("unmute"),
    startLocalVideo("startLocalVideo"),
    stopLocalVideo("stopLocalVideo"),
    videoTileAdd("videoTileAdd"),
    videoTileRemove("videoTileRemove"),
    listAudioDevices("listAudioDevices"),
    updateAudioDevice("updateAudioDevice"),
    audioSessionDidStop("audioSessionDidStop")
}
