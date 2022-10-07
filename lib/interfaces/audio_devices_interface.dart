/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

class AudioDevicesInterface {
  void initialAudioSelection() {
    // Gets initial selected audio device
  }

  void listAudioDevices() async {
    // Gets a list of available audio devices.
  }

  void updateCurrentDevice(String device) async {
    // Updates the current audio device to the chosen audio device.
  }
}
