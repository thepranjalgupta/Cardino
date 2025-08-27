plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter plugin must come last
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.cardo.cardo"
    compileSdk = 36  // ✅ Stay at 34 unless you’re explicitly testing on 36+ devices

    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.cardo.cardo"
        minSdk = 24             // ✅ Recommended for ML Kit & lStar compatibility
        targetSdk = 36          // ✅ Must be at least 31 to support lStar

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            isMinifyEnabled = false       // ✅ Avoid proguard issues unless configured
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug") // Change to release signingConfig if available
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
