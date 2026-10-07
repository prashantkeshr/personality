# Release shrinking (R8) rules for Personality.

# WorkManager 2.7 (pulled in by ML Kit) instantiates its Room database by
# reflection; R8 otherwise strips the generated implementation and the app
# crashes at startup ("Failed to create an instance of WorkDatabase").
-keep class * extends androidx.room.RoomDatabase { <init>(); }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }

# Google ML Kit pose detection: its native engine and acceleration module
# look up these classes by name at runtime. Without these rules R8 removes
# them and every frame fails analysis in release builds only.
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_** { *; }
-keep class com.google.android.odml.** { *; }
-keep class com.google_mlkit_commons.** { *; }
-keep class com.google_mlkit_pose_detection.** { *; }
-dontwarn com.google.mlkit.**
-keep class com.google.research.xeno.** { *; }
-keep class com.google.mediapipe.** { *; }
