﻿<?xml version="1.0" encoding="utf-8"?>
<project version="2">
  <!-- Output SWF options -->
  <output>
    <movie outputType="Application" />
    <movie input="" />
    <movie path="${PROJECT_NAME}.nmml" />
    <movie fps="${PROJECT_FPS}" />
    <movie width="${PROJECT_WIDTH}" />
    <movie height="${PROJECT_HEIGHT}" />
    <movie version="3" />
    <movie minorVersion="0" />
    <movie platform="NME" />
    <movie background="#${PROJECT_BACKGROUND}" />
  </output>
  <!-- Other classes to be compiled into your SWF -->
  <classpaths>
    <class path="src" />
  </classpaths>
  <!-- Build options -->
  <build>
    <option directives="" />
    <option flashStrict="False" />
    <option mainClass="Test" />
    <option enabledebug="False" />
    <option additional="" />
  </build>
  <!-- haxelib libraries -->
  <haxelib>
    <library name="nme" />
    <library name="age" />
  </haxelib>
  <!-- Class files to compile (other referenced classes will automatically be included) -->
  <compileTargets>
    <compile path="src\${PROJECT_CLASS}.hx" />
  </compileTargets>
  <!-- Assets to embed into the output SWF -->
  <library>
    <!-- example: <asset path="..." id="..." update="..." glyphs="..." mode="..." place="..." sharepoint="..." /> -->
  </library>
  <!-- Paths to exclude from the Project Explorer tree -->
  <hiddenPaths>
    <!-- example: <hidden path="..." /> -->
  </hiddenPaths>
  <!-- Executed before build -->
  <preBuildCommand />
  <!-- Executed after build -->
  <postBuildCommand alwaysRun="False" />
  <!-- Other project options -->
  <options>
    <option showHiddenPaths="False" />
    <option testMovie="Custom" />
    <option testMovieCommand="flash" />
  </options>
  <!-- Plugin storage -->
  <storage />
</project>