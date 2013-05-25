package age.utils;

/**
 * helps to convert a 3d position to a 2d position
 */
 
typedef Point2D = 
{
    var x: Float;
    var y: Float;
}

typedef Point3D = 
{
    > Point2D,
    var z : Float;
}

class Simple3D
{
    public static inline var fl: Float = 420;
    
    public function new()
    {
        
    }
    
    public static inline function scale( z: Float )
    {
        return 1-(-z)/fl;
    }
    
    public static inline function twoD( p: Point3D ): Point2D
    {
        var s = scale( p.z );
        return { x: p.x/s, y: p.y/s };
    }
    
    public static inline function rgbTwoD( rgb: Array<Float>, offSet: Point2D ): Point2D
    {
        var s = scale( rgb[2] );
        return { x: rgb[0]/s + offSet.x, y: rgb[1]/s + offSet.y };
    }
    
}
