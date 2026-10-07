# Release shrinking (R8) rules for Personality.

# WorkManager 2.7 (pulled in by ML Kit) instantiates its Room database by
# reflection; R8 otherwise strips the generated implementation and the app
# crashes at startup ("Failed to create an instance of WorkDatabase").
-keep class * extends androidx.room.RoomDatabase { <init>(); }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
