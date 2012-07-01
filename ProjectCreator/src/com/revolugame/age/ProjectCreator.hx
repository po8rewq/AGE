package com.revolugame.age;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import neko.Lib;
import neko.Sys;
import neko.io.File;
import neko.io.FileOutput;
import neko.FileSystem;
import neko.zip.Reader;

/**
 * ...
 * @author Adrien Fischer
 */
class ProjectCreator
{
    public function new()
    {
        // Récupération de la liste des arguments
        var args : Array<String> = Sys.args();
  		
        if( args.length <= 1 || args[0].indexOf("help") != -1 )
        {
        	Lib.println("AGE project template creation tool.\n");
        	Lib.println("haxelib run AGE [help] [-output /your/project/directory] [-name \"Your Project Name\"] [-main MainProjectClass] [-size WIDTH HEIGHT] [-fps FPS] [-bgColor COLOR]\n");
        	Lib.println("-help this screen");
			Lib.println("-output /your/project/directory");
			Lib.println("-name \"Your Project Name\"");
			Lib.println("-main MainProjectClass");
			Lib.println("-size WIDTH HEIGHT");
			Lib.println("-fps FPS");
			Lib.println("-bgColor COLOR (0xFF0000 or #FF0000)");
        }
        else
        {
        	var proj : ProjectStructure = parseCmd( args );
        	genProject( proj );
        }
    }
    
    private function parseCmd(pArgs: Array<String>):ProjectStructure
    {
    	var proj : ProjectStructure = new ProjectStructure(pArgs[pArgs.length - 1]);
    	
    	var i : Int = 0;
        var len : Int = pArgs.length;
        
        while(i < len)
        {
            if( pArgs[i] == "-name" )
            {
            	i++;
            	proj.name = pArgs[i];
            }
            else if(pArgs[i] == "-main" )
            {
            	i++;
            	proj.mainClass = pArgs[i];
            }
            else if(pArgs[i] == "-size" )
            {
            	i++;
            	proj.width = Std.parseInt( pArgs[i] );
            	i++;
            	proj.height = Std.parseInt( pArgs[i] );
            }
            else if(pArgs[i] == "-fps" )
            {
            	i++;
            	proj.fps = Std.parseInt( pArgs[i] );
            }
            else if(pArgs[i] == "-output" )
            {
            	i++;
            	if(StringTools.endsWith(pArgs[i], "\\") || StringTools.endsWith(pArgs[i], "/"))
					proj.directory = pArgs[i].substr(0, -1);
				else
            		proj.directory = pArgs[i];
            }
            else if(pArgs[i] == "-bgColor" )
            {
            	i++;
            	proj.backgroundColor = pArgs[i];
            }
            i++;
        }
        return proj;
    }
    
    private function genProject( pProject: ProjectStructure )
    {
    	var fileInput = File.read("template.zip", true);
    	var data : List<ZipEntry> = Reader.readZip(fileInput);
		fileInput.close();
		
		// Project directory
		if( !FileSystem.exists( pProject.directory ) )
			FileSystem.createDirectory( pProject.directory );
		
		for(entry in data)
		{
			var fileName = entry.fileName;
			
			// If it's a directory
			if(StringTools.endsWith(fileName, "\\") || StringTools.endsWith(fileName, "/"))
			{
				fileName = fileName.substr(0, -1);
				Lib.println("Directory: " + fileName);
				if( !FileSystem.exists( pProject.directory + "/" + fileName ) )
				{
					FileSystem.createDirectory( pProject.directory + "/" + fileName );
				}
			}
			else
			{
				var bytes:Bytes = Reader.unzip(entry);
				if(StringTools.endsWith(fileName, ".tpl"))
				{
					var text:String = new BytesInput(bytes).readString(bytes.length);					
					
					text = remplaceInTpl(text, pProject);
					
					bytes = Bytes.ofString(text);
					
					// remove the .tpl extension
					fileName = remplaceInTpl(fileName.substr(0, -4), pProject);
				}
				
				Lib.println("File output: " + fileName);
				var fout:FileOutput = File.write(pProject.directory + "/" + fileName, true);
				fout.writeBytes(bytes, 0, bytes.length);
				fout.close();
			}
		}
    }
    
    /**
     * Replace data in templates
     */
    function remplaceInTpl(pSource:String, pProject: ProjectStructure):String
	{
		pSource = StringTools.replace(pSource, "${PROJECT_NAME}", pProject.name);
		pSource = StringTools.replace(pSource, "${PROJECT_CLASS}", pProject.mainClass);
		pSource = StringTools.replace(pSource, "${PROJECT_WIDTH}", cast pProject.width);
		pSource = StringTools.replace(pSource, "${PROJECT_HEIGHT}", cast pProject.height);
		pSource = StringTools.replace(pSource, "${PROJECT_FPS}", cast pProject.fps);
		pSource = StringTools.replace(pSource, "${PROJECT_BACKGROUND}", pProject.backgroundColor);
		
		return pSource;
	}

    public static function main()
    {
        new ProjectCreator();
    }
}

class ProjectStructure implements haxe.Public
{
	var width : Int;
	var height : Int;
	var name : String;
	var directory : String;
	var mainClass : String;
	var fps : Int;
	var backgroundColor(default, setBgColor) : String;
	
	public function new(pDefaultDir: String)
	{
		width = 800;
		height = 600;
		name = 'AgeProject';
		directory = pDefaultDir;
		mainClass = 'Main';
		fps = 30;
		backgroundColor = "CECECE";
	}
	
	private function setBgColor(val:String):String
	{
		val = StringTools.replace(val, '0x', '');
		val = StringTools.replace(val, '#', '');
	
		backgroundColor = val;
		return backgroundColor;
	}
}