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
## 1. Clone the repository
Run `git clone` to download the source code

## 2. Deploy the serverless demo
Follow the instructions in [amazon-chime-sdk-js](https://github.com/aws/amazon-chime-sdk-js/tree/master/demos/serverless) to deploy the serverless demo.
> *Note: The Flutter demo doesn’t require authentication since the serverless demo does not provide the functionality, builders need to implement authentication for their own backend service.*

## 3. Update the server URLs
Update `apiUrl` and `region` in `lib/api_config.dart` with the server URL and region of the serverless demo you created.
## 4. Build and run
Run `flutter run` to start the demo under the root directory.
## 5. Cleanup
If you no longer want to keep the demo active in your AWS account and want to avoid incurring AWS charges, the demo resources can be removed. Delete the two AWS CloudFormation (https://aws.amazon.com/cloudformation/) stacks created in the prerequisites that can be found in the AWS CloudFormation console (https://console.aws.amazon.com/cloudformation/home).

​
**Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.**
