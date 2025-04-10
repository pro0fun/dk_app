buildscript {
    repositories {
        google()  // Ensure this is here
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:7.1.2")  // Ensure this is the correct version
        classpath("com.google.gms:google-services:4.3.15")  // Add this line for Google services
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
