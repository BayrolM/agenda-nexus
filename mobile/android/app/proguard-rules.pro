# Proguard rules to prevent R8 from stripping Gson TypeTokens
# which causes "Missing type parameter" crashes in flutter_local_notifications in release mode.

-keepattributes Signature
-keepattributes *Annotation*

# Gson specific rules
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken { *; }

# flutter_local_notifications specific rules (just in case)
-keep class com.dexterous.flutterlocalnotifications.** { *; }
