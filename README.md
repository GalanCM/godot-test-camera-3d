# Godot TestCamera3D

This addon is designed to help developers test 3D scenes in isolation, allowing them to run scenes from the editor without manually adding cameras or lights to the scene.

When a scene containing any VisualInstance3D-derived nodes and no active camera is opened in the editor, the addon will add a camera to the scene, set up an `Environment`, and add lights (if needed).

## Status

TestCamera3D is currently in testing. All of the core features are implemented, and it should work in most situations, but user feedback is needed before it can be considered stable. Since it only runs in the editor, it should be safe to use in production — but unexpected behaviors are possible.

## Using TestCamera3D

Simply install and enable the plugin, and then run any 3D scene without a camera. You can tell when the TestCamera is active by the presence of an overlay. Controls for the camera are displayed in the bottom left.

## Changing Controls

Like game and engine controls, TestsCamera3D controls can be edited in the **Input Map** tab under **Project Settings**, and are prefixed with 'testcamera\_'.

**Note:** Control settings will not show up in the settings dialog until the project is reloaded.

## Other Settings

Other settings are available in the **General** tab of **Project Settings**, under **Test Camera 3D**.

- **Starting Angle:** Controls the angle the camera starts at when running a scene. Pick the one that best suits your game.

**Note:** The Settings dialog will need to be closed and re-opened for the plugin settings to show up.
