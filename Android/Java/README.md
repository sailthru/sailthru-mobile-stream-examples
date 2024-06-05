# Marigold Message Stream Example
This repo contains a sample project with a custom message stream based on Android's Material Design concepts.
The point of these examples is to be copied into your own project and modified to suit the
look and feel of the application.

## Requirements

* Android Studio 1.3 or higher.
* Supports Devices running Android 4.0+.

## Dependencies

### Android Libraries

[**Card View**](http://developer.android.com/tools/support-library/features.html#v7-cardview)

[**Recycler View**](http://developer.android.com/tools/support-library/features.html#v7-recyclerview)

[**Design Support Library**](http://developer.android.com/tools/support-library/features.html#design)

[**Android Data Binding**](https://developer.android.com/tools/data-binding/guide.html)

### Third Party Libraries

[**Android SwipeableRecyclerView**](https://github.com/brnunes/SwipeableRecyclerView) by Bruno R. Nunes is used to implement a swipe to dismiss UI on Messages.

[**Picasso**](https://github.com/square/picasso) by Square for asynchronous loading of Message images.

### Importing Modules Into Your Application

In your Android Studio project open up the project structure window (`File > Project Structure`) and add a new module. Choose `Import Gradle Project` and provide the path to the native stream module from Marigold Native Streams repository that you want to use. This will copy it into your project and also adds the `MarigoldUtils` module that the Stream uses.

Once you have finished importing the Stream and MarigoldUtil modules, add the stream module as a dependency to your application module.

The native streams use Android's [Data Binding Library](https://developer.android.com/tools/data-binding/guide.html) to more effectively manage the stream layout. This requires a little extra setup but makes for much more manageable code.

To set up your application to use data binding, you must be using gradle 1.5.0 or higher.

    #!groovy
    dependencies {
       classpath "com.android.tools.build:gradle:1.5.0"
    }

Make sure jcenter is in the repositories list for your projects in the top-level `build.gradle` file.

    #!groovy
    allprojects {
       repositories {
           google()
           mavenCentral()
       }
    }

In your application's `build.gradle` enable data binding.

    #!groovy
    android {
        ....
        dataBinding {
            enabled = true
        }
    }

Because the native stream uses a [ToolBar](https://developer.android.com/reference/android/widget/Toolbar.html), the activity needs to be defined without an ActionBar. If you don't have a `NoActionBar` theme defined in your `styles.xml` already, you can define it as below.

    #!xml
    <style name="AppTheme.NoActionBar">
        <item name="windowActionBar">false</item>
        <item name="windowNoTitle">true</item>
    </style>

Once you've defined the theme, apply it to the Message Stream Activity in your manifest.
    
    #!xml
    <activity android:name="com.marigold.stream.standard.TileStreamActivity"
            android:theme="@style/AppTheme.NoActionBar"/>

That's the setup done for the Marigold Stream Module, now it can be called like any other activity in your application.

    #!java
    public void foo(View v) {
      Intent i = new Intent(this, TileStreamActivity.class);
      startActivity(i);
    }