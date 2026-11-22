Hello! This is a prototype of Kolapsa, a godot plugin that helps small gamedevs make a map for their games. This plugin is still under development and have bugs. Your feedback will help us improve this plugin.

About the assets:
The assets were originally filipino-themed. Thanks to combined feedbacks of testers and other game developers, kolapsa now also accept other assets and organize them using the same WFC algorithm. However, our demo assets are inspired from filipino-themed streets.

Instructions:

(1) Download as zip

(2) Extract

(3) Drag ONLY the addons folder inside kolapsa to your chosen godot project

(4) Got project settings -> plugin -> check wfc city gen

(5) Start your usual scene, create a 3D node.

(6) At the bottom, a new dock named city generator would appear

(7) Click your Node 3D then click +Add city generator

(8) Place assets in Ground, Middle, and Roof by clicking add asset and choosing from the asset folder.

(9) If you want the middle buildings to appear organized,  you can assign A, B, C, D in the dropdown section.

(10) Tweak your settings to your liking and click generate.


Gridsize - the size of your map (ex: 9x9 map)
Max Floors- Maximum height of your buildings

PHYSICS
On the physics section, you can choose whether you'd want the buildings to be static or rigid. You can add collisions and choose to merge the ground tiles to move them easier depending on your game.


RUN PROJECT
You can run the project as a DEVELOPER - checks the wfc frame by frame. Up/down arrow button on your keyboard to adjust how many frames per step. Left/right keyboard button to check the step by step process.

You can also run the project as a GAME - Walk around the map. You need to add your usual player character in the scene to be able to move around.


