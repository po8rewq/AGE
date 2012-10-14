package ;

import com.revolugame.age.display.QuadTreeEntity;
import com.revolugame.age.enums.CollisionsEnum;

class Block extends QuadTreeEntity
{

    public function new(pX: Int, pY: Int, pWidth : Int, pHeight: Int)
    {
        super(pX, pY);
        makeGraphic( pWidth, pHeight, 0xFFFF0000 );
        
        solid = true;
        //_collisions.type = CollisionsEnum.UP;
                
        // trace( (_collisions.type & CollisionsEnum.UP) != 0 );        
    }
    
    public override function update():Void
    {    	
    	super.update();
    }

}
