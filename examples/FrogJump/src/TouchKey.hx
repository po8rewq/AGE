package ;

import com.revolugame.age.display.Image;

class TouchKey extends Image
{
    
    public function new(pX: Int, pY: Int)
    {
        super(pX, pY);
        makeGraphic( 50, 50, 0xFF000000 );
    }
    
}
