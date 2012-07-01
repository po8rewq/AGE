<?xml version="1.0" encoding="utf-8"?>
<project>
	
	<meta title="${PROJECT_NAME}" package="com.revolugame.${PROJECT_NAME}" version="1.0.0" company="RevoluGame.com" />
	<app file="${PROJECT_NAME}" main="${PROJECT_CLASS}" path="bin" />
	
	<window width="${PROJECT_WIDTH}" height="${PROJECT_HEIGHT}" unless="mobile" />
	<window orientation="landscape" if="mobile" /> <!-- Full screen if mobile -->
	
	<window background="0x${PROJECT_BACKGROUND}" fps="${PROJECT_FPS}" />

	<app preloader="com.revolugame.age.system.AgePreloader" />

	<source path="src" />
	
	<haxelib name="nme" />
	<haxelib name="age" />
	
	<!-- Uncomment what you need -->
	<!--assets path="assets/gfx" rename="gfx" type="image" include="*.png" /-->
	<!--assets path="assets/sfx" rename="sfx" type="sound" include="*.wav" /-->
	<!--assets path="assets/music" rename="music" type="music" include="*.mp3" /-->
	<!--assets path="assets/font" rename="font" type="font" include="*.ttf" /-->
	
	<icon path="assets/nme.svg" />
	
	<ndll name="std" />
	<ndll name="regexp" />
	<ndll name="zlib" />
	<ndll name="nme" haxelib="nme" />
		
</project>
