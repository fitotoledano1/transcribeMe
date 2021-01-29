# transcribeMe

![alt text](https://ibb.co/NF5J7P1)


Dear team at Speechify,

Thank you for your interest and for reaching out. I have really enjoyed building this little project - here are some of the priorities I had when building it:

- Clarity in the User Experience. Every part of the User Interfaces supports the mission of the application, and gives deference to the workflow that is happening.
e.g. Recording:
1. The 'Record' button title changes to 'Stop Recording'
2. The 'Record' button background color changes to .systemRed
3. The 'Play' button becomes disabled, and reduces opacity to defer to the 'Stop Recording' workflow

- Speed of development, as discussed in our call - I understand Speechify has a vibrant working environment, where iterating fast matters.
- Modularity and readabilty - for the same reason above. This project is built so anyone in the team can immediately jump in and make profound changes to the application - as it's with minimum boilerplate
- Using SwiftUI, the MVVM pattern, a reactive architecture and declarative programming
- Handling errors and loading states
- Using the Speech-to-Text API - authenticating with an API Key that is restricted to iOS Devices + the indicated API
- Consistently using Dynamic Type so users with special Accessibility needs can also use the application

Additionally, I've added a nice-looking App Icon, and also uploaded it to TestFlight (currently Waiting for Review for External Testing)

Some things that I would have liked to add, had I not prioritized to keep this project under 24h:
- An animated, Apple Music UI-like for audio playback (where the lyrics animate utilizing the full screen according to the timestamp of the song - in this case, for every word in the transcription)
- Adding a sound and haptic feedback to the record/stop recording workflow
- Making one of the two POST request with URLSession for demonstration purposes, but ended up using Alamofire for speed and simplicity sake
- Adding more documentation to the ViewModel

I have several videos of this workflow, and would love to share them and answer any questions that anyone in the team might have - feel free to reach out anytime at fito.toledano@gmail.com


Best,
Fito Toledano
