package com.revolugame.age.display;

class Tile extends Image
{

    public function new(pIndex: Int, pWidth: Int, pHeight: Int, ?pSolid: Bool = false)
    {
        super(0, 0);
        makeGraphic(pWidth, pHeight, 0xFFFF0000);
        
       // isSolid = pSolid;
    }

}
