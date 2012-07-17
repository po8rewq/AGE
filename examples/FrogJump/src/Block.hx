package ;

import com.revolugame.age.display.Entity;

class Block extends Entity
{

    public function new(pX: Int, pY: Int, pWidth : Int, pHeight: Int)
    {
        super(pX, pY);
        makeGraphic( pWidth, pHeight, 0xFFFF0000 );
        solid = true;
    }

}
