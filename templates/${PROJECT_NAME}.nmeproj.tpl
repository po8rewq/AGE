<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <PropertyGroup>
    <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
    <Platform Condition=" '$(Platform)' == '' ">Flash</Platform>
    <ProductVersion>10.0.0</ProductVersion>
    <SchemaVersion>2.0</SchemaVersion>
    <ProjectGuid>{DAC8A0B8-E030-42E0-A50D-204C4DF9977C}</ProjectGuid>
    <TargetNMMLFile>${PROJECT_NAME}.nmml</TargetNMMLFile>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|Android' ">
    <DebugSymbols>true</DebugSymbols>
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|BlackBerry' ">
    <DebugSymbols>true</DebugSymbols>
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|Flash' ">
    <DebugSymbols>true</DebugSymbols>
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|HTML5' ">
    <DebugSymbols>true</DebugSymbols>
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|iOS' ">
    <DebugSymbols>true</DebugSymbols>
    <OutputPath>.</OutputPath>
    <AdditionalArguments>-simulator</AdditionalArguments>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|Linux' ">
    <DebugSymbols>true</DebugSymbols>
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|Mac' ">
    <DebugSymbols>true</DebugSymbols>
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|webOS' ">
    <DebugSymbols>true</DebugSymbols>
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|Windows' ">
    <DebugSymbols>true</DebugSymbols>
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|Android' ">
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|BlackBerry' ">
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|Flash' ">
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|HTML5' ">
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|iOS' ">
    <OutputPath>.</OutputPath>
    <AdditionalArguments>-simulator</AdditionalArguments>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|Linux' ">
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|Mac' ">
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|webOS' ">
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|Windows' ">
    <OutputPath>.</OutputPath>
  </PropertyGroup>
  <ItemGroup>
    <Compile Include="${PROJECT_NAME}.nmml" />
    <Compile Include="src\${PROJECT_CLASS}.hx" />
    <Compile Include="src\GameState.hx" />
    <Compile Include="assets\nme.svg" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="assets\" />    
    <Folder Include="src\" />
  </ItemGroup>
</Project>
