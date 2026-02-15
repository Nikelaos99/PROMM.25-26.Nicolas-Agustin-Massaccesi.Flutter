plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.smart_pantry_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.smart_pantry_app"
        // Firestore y otras librerías modernas de Firebase necesitan minSdk 21
        minSdk = flutter.minSdkVersion 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        multiDexEnabled = true
    }

    buildTypes {
        getByName("release") {
            // Usamos la configuración de debug para probar el APK rápido
            signingConfig = signingConfigs.getByName("debug")
            
            // --- SINTAXIS CORRECTA PARA KOTLIN (.kts) ---
            applicationVariants.all {
                outputs.all {
                    val output = this as com.android.build.gradle.internal.api.BaseVariantOutputImpl
                    output.outputFileName = "Smart_Pantry_App_v${defaultConfig.versionName}.apk"
                }
            }
        }
    }
}

flutter {
    source = "../.."
}
