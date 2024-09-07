<h1 align="center" id="title">Rooster</h1>

<p align="center"><img src="https://socialify.git.ci/AndroidKiran/PetPot/image?language=1&amp;name=1&amp;stargazers=1&amp;theme=Light" alt="project-image"></p>

<p id="description">Rooster is the ultimate solution for developers seeking complete control over their crash monitoring and response infrastructure. Built on the power of Firebase Crashlytics Firebase Cloud Functions and FCM Rooster empowers you to proactively address critical crashes and minimize user impact.</p>

<p align="center"><img src="https://img.shields.io/badge/platform-androidIos-yellow" al="shields">
<img src="https://img.shields.io/badge/Contributor-1-red" alt="shields">
<img src="https://img.shields.io/badge/License-Apache%20License-blue" alt="shields"></p>


<h2>🧐 Features</h2>

<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">Key Features</span></strong></p>
<ul>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Self-Hosted Firebase Functions: Take full ownership of your crash data and infrastructure by self-hosting Firebase Functions.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Real-time Crash and Velocity Tracking: Instantly detect fatal crashes and monitor crash velocity across your Android and iOS apps using Firebase Crashlytics.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">VoIP Call Notifications via FCM: On-call personnel receive immediate VoIP call notifications triggered by FCM, ensuring swift response to critical issues.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Detailed Crash Insights: Access comprehensive crash details from Firebase Crashlytics, including stack traces, device information, and user context, to quickly identify and resolve the root cause.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">On-Call User Management: Admins can easily add, remove, and manage on-call users, enabling and disabling their on-call status as needed for efficient issue resolution.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Customizable Android and iOS Apps: Generate your own branded mobile apps powered by Firebase Cloud Functions and FCM, providing a seamless crash response experience.</span></p>
    </li>
</ul>
<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">Benefits</span></strong></p>
<ul>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Enhanced Data Privacy and Security: Maintain complete control over your crash data with self-hosting.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Faster Response Times: VoIP call notifications ensure immediate attention to critical crashes.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Improved App Stability: Proactively address crashes and minimize user disruption.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Flexible Deployment: Self-host on your preferred infrastructure or leverage Firebase&apos;s scalable cloud platform.</span></p>
    </li>
</ul>
<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">Ideal for</span></strong></p>
<ul>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Mobile App Developers: Seeking a robust and customizable crash monitoring solution.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Enterprises with Strict Data Compliance Requirements: Requiring full control over sensitive crash data.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">DevOps and SRE Teams: Focused on optimizing app performance and minimizing downtime.</span></p>
    </li>
</ul>

<h2>🛠️ Installation Steps:</h2>

<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">This guide outlines the installation process on an existing Flutter project named &quot;Rooster,&quot; utilizing Firebase for crash monitoring and user management.</span></p>
<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">Prerequisites</span></strong></p>
<ul>
    <li style="list-style-type: decimal;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Existing Rooster Project: You have a Flutter project named &quot;Rooster&quot; with a working codebase.</span></p>
    </li>
    <li style="list-style-type: decimal;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Firebase CLI: Install the Firebase CLI globally using&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">npm install -g firebase-tools</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">.</span></p>
    </li>
    <li style="list-style-type: decimal;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">FlutterFire CLI: Install the FlutterFire CLI globally using&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">dart pub global activate flutterfire_cli</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">.</span></p>
    </li>
    <li style="list-style-type: decimal;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Firebase Account: Ensure you&apos;re logged into the correct Firebase account using&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">firebase login</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">.</span></p>
    </li>
</ul>
<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">Steps</span></strong></p>
<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">1. Create a New Firebase Project</span></strong></p>
<ul>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">In the Firebase console (https://console.firebase.google.com/), create a new Firebase project specifically for Rooster Pro. Let&apos;s call it &quot;Rooster-Project&quot;.</span></p>
    </li>
</ul>
<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">2. Configure Firebase for Android (Mostly auto created using firebase cli)</span></strong></p>
<ul>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">In the Firebase console, navigate to your &quot;Rooster-Project&quot;.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Click&nbsp;</span><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">&quot;Add app&quot;</span></strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;and select&nbsp;</span><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">Android</span></strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Provide your Android package name (e.g.,&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">com.applogics.rooster</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">).</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Download the&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">google-services.json</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;file.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Place this file in the&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">android/app</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;directory of your Rooster project.</span></p>
    </li>
</ul>
<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">3. Configure Firebase for iOS &nbsp;(Mostly auto created using firebase cli)</span></strong></p>
<ul>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">In the Firebase console, click&nbsp;</span><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">&quot;Add app&quot;</span></strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;and select&nbsp;</span><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">iOS</span></strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Provide your iOS bundle ID (e.g.,&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">com.applogics.rooster</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">).</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Download the&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">GoogleService-Info.plist</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;file.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Open your Rooster project in Xcode.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Drag and drop the&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">GoogleService-Info.plist</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;file into the&nbsp;</span><strong><span style="color: rgb(24, 128, 56);font-size: 11pt;">Runner</span></strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;folder in Xcode.</span></p>
    </li>
</ul>
<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">4. Configure FlutterFire CLI</span></strong></p>
<ul>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Open a terminal in your Rooster project directory.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Run&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">flutterfire configure</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;to link your Flutter project to the new &quot;Rooster-Project&quot;.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Select the Firebase features you need (e.g., Crashlytics, FCM, Realtime Database) for both Android and iOS.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">This will update your&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">firebase_options.dart</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;file.</span></p>
    </li>
</ul>
<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">5. Update Firebase Dependencies</span></strong></p>
<ul>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">In your&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">pubspec.yaml</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">, ensure you have the latest versions of:</span></p>
    </li>
</ul>
<ul>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">firebase_core: ^2.14.0</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">firebase_crashlytics: ^3.2.0</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">firebase_messaging: ^14.6.5</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">firebase_database: ^10.2.0</span></p>
<p></p>
</ul>
<ul>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Run&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">flutter pub get</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;to update dependencies.</span></p>
    </li>
</ul>
<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">6. Create Users Table in Realtime Database</span></strong></p>
<ul>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">In the Firebase console, navigate to&nbsp;</span><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">Realtime Database</span></strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Create a new table named &quot;users&quot;.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Add an admin user with the following structure: use&nbsp;</span><a href="mailto:admin@example.com"><u><span style="color: rgb(17, 85, 204);font-size: 11pt;">admin@example.com</span></u></a><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;to login in to android or iso app. Post add other users using add users screen.</span></p>
    </li>
</ul>

<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">{</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp; &nbsp; &nbsp; &quot;adminUser&quot;: {&nbsp;</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp; &nbsp; &nbsp; &nbsp; &quot;email&quot;: &quot;admin@example.com&quot;,</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp; &nbsp; &nbsp; &nbsp; &quot;name&quot;: &quot;Admin User&quot;,</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp; &nbsp; &nbsp; &nbsp; &quot;platform&quot;: &quot;android&quot;,</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp; &nbsp; &nbsp; &nbsp; &quot;deviceInfoRef&quot;: &quot;&quot;,</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp; &nbsp; &nbsp; &nbsp; &quot;isOnCall&quot;: true,</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp; &nbsp; &nbsp; &nbsp; &quot;isAdmin&quot;: true,</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp; &nbsp; &nbsp; &nbsp; &quot;createdAt&quot;: {&quot;.sv&quot;: &quot;timestamp&quot;},&nbsp;</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp; &nbsp; &nbsp; &nbsp; &quot;modifiedAt&quot;: {&quot;.sv&quot;: &quot;timestamp&quot;}&nbsp;</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp; &nbsp; &nbsp; }</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp; &nbsp; }</span></p>
<p></p>
<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">7. Set Up Firebase Cloud Functions</span></strong></p>
<ul>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">Initialize Firebase Functions:</span></strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;In your Rooster project directory, run&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">firebase init functions</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">Select Project:</span></strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;Choose the &quot;Rooster-Project&quot; you created earlier.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">Choose Language:</span></strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;TypeScript for your Cloud Functions.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">Install Dependencies:</span></strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;Navigate to the&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">functions</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;directory and run&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">npm install</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">Write Cloud Functions:</span></strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;Implement the necessary Cloud Functions to handle crash data processing and FCM notification triggering. Refer to the Firebase documentation for guidance.</span></p>
    </li>
</ul>
<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">8. Deploy Cloud Functions</span></strong></p>
<ul>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">Deploy to Firebase:</span></strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;In the&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">functions</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;directory, run&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">firebase deploy --only functions</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;to deploy your Cloud Functions to Firebase.</span></p>
    </li>
</ul>
<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">9. Deploy Cloud Functions Locally (for Testing)</span></strong></p>
<ul><li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">In the&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">functions</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;directory, run&nbsp;</span><span style="color: rgb(24, 128, 56);font-size: 11pt;">firebase emulators:start</span><span style="color: rgb(0, 0, 0);font-size: 11pt;">&nbsp;to start the local emulator suite.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Your Cloud Functions will now be available locally.</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Update your Rooster app to use the local emulator endpoints for testing (refer to Firebase documentation for instructions).</span></p>
    </li>
</ul>
<p><strong><span style="color: rgb(0, 0, 0);font-size: 11pt;">10. Test Cloud Functions</span></strong></p>
<ul>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Trigger crash events in your Android app (or simulate them).</span></p>
    </li>
    <li style="list-style-type: disc;color: rgb(0, 0, 0);font-size: 11pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 11pt;">Observe the logs in the emulator suite to verify that your Cloud Functions are triggered and working as expected.</span></p>
    </li>
</ul>

<h2>🍰 Contribution Guidelines:</h2>

<p><span style="color: rgb(0, 0, 0);font-size: 12pt;">Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.</span></p>
<p><span style="color: rgb(0, 0, 0);font-size: 12pt;">If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag &quot;enhancement&quot;. Don&apos;t forget to give the project a star! Thanks again!</span></p>
<ul>
    <li style="list-style-type: decimal;color: rgb(0, 0, 0);font-size: 12pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 12pt;">Fork the Project</span></p>
    </li>
    <li style="list-style-type: decimal;color: rgb(0, 0, 0);font-size: 12pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 12pt;">Create your Feature Branch (</span><span style="color: rgb(0, 0, 0);font-size: 10pt;">git checkout -b feature/AmazingFeature</span><span style="color: rgb(0, 0, 0);font-size: 12pt;">)</span></p>
    </li>
    <li style="list-style-type: decimal;color: rgb(0, 0, 0);font-size: 12pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 12pt;">Commit your Changes (</span><span style="color: rgb(0, 0, 0);font-size: 10pt;">git commit -m &apos;Add some AmazingFeature&apos;</span><span style="color: rgb(0, 0, 0);font-size: 12pt;">)</span></p>
    </li>
    <li style="list-style-type: decimal;color: rgb(0, 0, 0);font-size: 12pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 12pt;">Push to the Branch (</span><span style="color: rgb(0, 0, 0);font-size: 10pt;">git push origin feature/AmazingFeature</span><span style="color: rgb(0, 0, 0);font-size: 12pt;">)</span></p>
    </li>
    <li style="list-style-type: decimal;color: rgb(0, 0, 0);font-size: 12pt;">
        <p><span style="color: rgb(0, 0, 0);font-size: 12pt;">Open a Pull Request</span></p>
    </li>
</ul>

<h2>💻 Built with</h2>

Technologies used in the project:

* Dart
* Flutter
* Firebase cloud functions
* Firebase realtime database
* TypeScript
* Node.js

<h2>🛡️ License:</h2>
This project is licensed under the Apache License 2.0
