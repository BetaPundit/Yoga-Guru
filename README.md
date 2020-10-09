# Yoga Guru

<img src="https://github.com/adityaas26/Yoga-Guru/blob/master/screenshots/HomePage.png" alt="Home" height="350"/><img src="https://github.com/adityaas26/Yoga-Guru/blob/master/screenshots/BeginnerPage.png" alt="Beginner" height="350"/><img src="https://github.com/adityaas26/Yoga-Guru/blob/master/screenshots/IntermediatePage.png" alt="Intermediate" height="350"/><img src="https://github.com/adityaas26/Yoga-Guru/blob/master/screenshots/AdvancePage.png" alt="Advance" height="350"/>

<img src="https://github.com/adityaas26/Yoga-Guru/blob/master/screenshots/ProfilePage.png" alt="Profile" height="350"/><img src="https://github.com/adityaas26/Yoga-Guru/blob/master/screenshots/UpdateProfilePage.png" alt="Update Profile" height="350"/><img src="https://github.com/adityaas26/Yoga-Guru/blob/master/screenshots/Inference.png" alt="Inference" height="350"/>

**Yoga Guru** is your personalized yoga trainer app based on Flutter. It uses posenet, a pre-trained deep learning model, to estimate body poses in real time and predict yoga asanas.

## Getting Started

### Step 1: Clone the project repository
Open terminal and type

```sh
git clone https://github.com/adityaas26/Yoga-Guru.git
```

### Step 2: Run the app
Connect your device or start the emulator and run the following code

```sh
# change directories
cd Yoga-Guru

# gets all the dependencies
flutter get pub

# run the app
flutter run
```

## Project Structure

The project structure is quite primitive right now. 

<img src="https://github.com/adityaas26/Yoga-Guru/blob/master/screenshots/yoga-guru-project-struct.jpg" alt="project structure" height="650"/>

Let's look at the lib folder

<img src="https://github.com/adityaas26/Yoga-Guru/blob/master/screenshots/yoga-guru-project-struct-cropped.jpg" alt="project structure" height="400"/>

Don't worry, we'll take a brief look at all the files in a minute! Let's start with **main.dart**

### 1. main.dart
**main.dart** loads data from shared preferences and the camera module. It also defines routes for **home**, **login** and **register** pages. If the user is already logged in, it sets the initial route to **home.dart** else **login.dart**.

### 2. login.dart
**login.dart** defines a *Login* class, which is a stateful widget. It contains the textfields required to login into the app. The Login button calls the *_login()* method which routes to **home.dart**. Also contains a button to send the user to **register.dart**.

### 3. register.dart
**register.dart** defines a *Register* class, which is a stateful widget. It contains the textfields required to login into the app. The Login button calls the *_register()* method which routes to **home.dart**. Also contains a button to send the user to **login.dart**.

<img src="https://github.com/adityaas26/Yoga-Guru/blob/master/screenshots/HomePage.png" alt="Home" align="right" height="300"/>

### 4. home.dart
**home.dart** defines a *Home* class, which is a stateless widget. It contains buttons which routes the user to **poses.dart** according to the button they press. Each button (beginner, intermediate, advance) call a method *_onPoseSelect()*. 

This *_onPoseSelect()* method is quite important as the arguments given to this function decides which list of poses needs to be shown on the poses page.

<br /><br /><br />

<img src="https://github.com/adityaas26/Yoga-Guru/blob/master/screenshots/BeginnerPage.png" alt="Beginner" align="left" height="300"/>

### 5. poses.dart
**poses.dart** defines a *Poses* class, which is a stateless widget. It shows a list of available poses as [swipable cards](https://pub.dev/packages/flutter_swiper). The code of the custom cards can be found in **yoga_card.dart** file. Each card is clickable and calls the *_onSelect()* method which directs the user to the InferencePage (**inference.dart**).

<br /><br /><br /><br /><br />

<img src="https://github.com/adityaas26/Yoga-Guru/blob/master/screenshots/Inference.png" alt="Inference" align="right" height="300"/>

### 6. inference.dart
**inference.dart** defines a *InferencePage* class, which is a stateful widget. It is the class which loads the posenet model. It initializes the Camera object with the camera instance and *_setRecognitions()* callback function. The *_setRecognitions()* method is responsibe for saving the predicted output of the PoseNet model into a List (*_recognitions*). This list of predicted values (*_recognitions*) is then passed to **BndBox's** constructor.

You can read more about the implementation [here](https://github.com/shaqian/flutter_tflite#posenet).

<br /><br />

### 7. camera.dart
**camera.dart** defines a *Camera* class, which is a stateful widget. It contains code related to camera initialization and calls *Tflite.runPoseNetOnFrame()* method by passing in the current *CameraImage* as an argument. The output (predictions) of this method is given as an argument to the *_setRecognitions()* method, which was passed to Camera() as callback.

### 8. bndbox.dart
**bndbox.dart** defines a *BndBox* class, which is a stateless widget. It takes the List of predictions (*_recognitions*) and plot keypoints on the screen. It also prints the accuracy of the model in %.

<img src="https://github.com/adityaas26/Yoga-Guru/blob/master/screenshots/ProfilePage.png" alt="Profile" align="right" height="300"/>

### 9. profile.dart
**profile.dart** defines a *Profile* class, which is a stateful widget. It contains the code for viewing and updating the user's profile data.

<br /><br /><br /><br /><br /><br />




## Support

<a href="https://www.buymeacoffee.com/iBZjXRz" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>


Reach out to me at any of the following platforms:
- Portfolio Website: [adityasharma.live](https://adityasharma.live)
- Email: [adityaas26@gmail.com](mailto:adityaas26@gmail.com)
- Twitter: [@BetaPundit](https://twitter.com/BetaPundit)
- LinkedIn: [aditya-sharma26](https://www.linkedin.com/in/aditya-sharma26/)

## Resources to help you start
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
