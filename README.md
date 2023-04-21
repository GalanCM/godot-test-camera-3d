# Godot TestCamera3D

This addon is designed to help developers test 3D scenes in isolation, allowing them to run scenes without manually adding cameras or lights to the scene.

When a scene with a root node derived from Node3D is opened in the editor, the addon will check to see if the scene has an active camera. If not, it will add a camera to the scene, set up an `Environment`, and add lights (if needed).

## Status

TestCamera3D is currently alpha-quality software. It _should_ work without issue, but the camera might not get placed ideally, and implementation details are still a work in progress. Since it only runs in the editor, it should be safe to use in production, but unexpected behaviors are possible.

## Using TestCamera3D

Simply install and enable the plugin, and then run any scene with a Node3D-derived root and no camera. You can tell when the TestCamera is active by the presence of the overlay. Controls for the camera are displayed in the bottom left.

## Changing Controls

Like game and engine controls, TestsCamera3D controls can be edited in the **Input Map** tab under **Project Settings**, and are prefixed with 'testcamera\_'.

## Other Settings

Other settings are available in the **General** tab of **Project Settings**, under **Test Camera 3D**.

- **Starting Angle:** Controls the angle the camera starts at when running a scene. Pick the one that best suits your game.
