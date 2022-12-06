# Amazon Chime SDK Flutter Demo
The Amazon Chime SDK is a set of real-time communications components that developers can use to quickly add audio calling, video calling, and screen sharing capabilities to their own applications. Developers can leverage the same communication infrastructure and services that power Amazon Chime, an online meetings service from AWS, to deliver engaging experiences in their applications. For instance, they can add video calling to a healthcare application so patients can consult remotely with doctors on health issues, or add audio calling to a company website so customers can quickly connect with sales. By using the Amazon Chime SDK, developers can eliminate the cost, complexity, and friction of creating and maintaining their own real-time communication infrastructure and services.
​
This demo shows how to integrate the [Amazon Chime SDK](https://aws.amazon.com/blogs/business-productivity/amazon-chime-sdks-ios-android/) into your Flutter application.
​
For more details about the SDK APIs, please refer to the **Getting Started** guide of the following SDK repositories:
* [amazon-chime-sdk-android](https://github.com/aws/amazon-chime-sdk-android/blob/master/guides/01_Getting_Started.md)
* [amazon-chime-sdk-ios](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/01_Getting_Started.md)
​
> *Note: Deploying the Amazon Chime SDK demo applications contained in this repository will cause your AWS Account to be billed for services, including the Amazon Chime SDK, used by the application.*
---
​
# How to Run the Flutter Demo Application​

## Prerequisites
The demo application is able run on both iOS and Android. For managing Amazon Chime SDK as dependency, CocoaPods is utilized on iOS, Maven Central repository with Gradle is utilized on Android. In order to run the demo, make sure the following are installed/prepared:

For both iOS and Android:
 - Install [Flutter SDK](https://docs.flutter.dev/get-started/install)

For running on iOS:
 - MacOS is needed
 - Install [XCode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)
 - Install [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started)
 - If running on simulator, follow this [link](https://developer.apple.com/documentation/xcode/installing-additional-simulator-runtimes) to create iOS Simulators
 - If running on physical device, Apple Developer [account](https://developer.apple.com/) is needed.

For running on Android:
 - Install [Android Studio](https://developer.android.com/studio/install)
 - Install [Gradle](https://gradle.org/install/)
 - Android physical device is needed (*currently x86 architecture/simulators are not supported*)

> *Note: The demo application is not necessarily running with the latest Amazon Chime SDK, the current SDK version can be found [here](https://github.com/aws-samples/amazon-chime-sdk-flutter-demo/blob/main/ios/Podfile#L8) for iOS and [here](https://github.com/aws-samples/amazon-chime-sdk-flutter-demo/blob/main/android/app/build.gradle#L76-L77) for Android.*

## 1. Clone the repository
Run `git clone` to download the source code

## 2. Deploy the serverless demo
Follow the instructions in [amazon-chime-sdk-js](https://github.com/aws/amazon-chime-sdk-js/tree/master/demos/serverless) to deploy the serverless demo.
> *Note: The Flutter demo doesn’t require authentication since the serverless demo does not provide the functionality, builders need to implement authentication for their own backend service.*

## 3. Update the server URLs
Update `apiUrl` and `region` in `lib/api_config.dart` with the server URL and region of the serverless demo you created. `apiUrl` format: `https://<api-id>.execute-api.<aws-region-id>.amazonaws.com/Prod/`.

## 4. Build and run

### Android
* Connect a physical Android testing device (*we currently do not support x86 architecture/simulators*) to your computer
* Run `flutter run` under the root directory to start the demo app on the device

### iOS
* Connect a physical iOS testing device or start iOS simulator
* Run `pod install` under `./ios/` directory to install Chime SDK dependencies
* Run `flutter run` under the root directory to start the demo app on the device/simulator

## 5. Cleanup
If you no longer want to keep the demo active in your AWS account and want to avoid incurring AWS charges, the demo resources can be removed. Delete the two AWS CloudFormation (https://aws.amazon.com/cloudformation/) stacks created in the prerequisites that can be found in the AWS CloudFormation console (https://console.aws.amazon.com/cloudformation/home).

​
**Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.**
