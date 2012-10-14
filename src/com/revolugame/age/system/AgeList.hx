package com.revolugame.age.system;

import com.revolugame.age.display.QuadTreeEntity;

/**
 * A miniature linked list class
 */
class AgeList
{
    public var root : AgeListNode;
    private var _current : AgeListNode;
    public var numChildren(default, null) : Int;
    
    public function new(?pRoot:AgeListNode=null)
    {
        numChildren = 0;
        root = pRoot;
        _current = null;
    }
    
    /**
     * Add and return the node
     */
    public function add(?pObj: QuadTreeEntity = null):AgeListNode
    {
        if(root == null)
	    {
	        root = CachedListNode.get(pObj);
	        _current = root;
	    }
	    else
	    {
	        _current.next = CachedListNode.get(pObj);
	        _current = _current.next; 
	    }
        numChildren++;
        return _current;
    }
    
    public function remove():Bool
    {
        // TODO
        return false;
    }
    
    public function clear(?pRecycle:Bool = true)
    {
        var node : AgeListNode = root;
        while(node != null)
        {
            if(pRecycle)
                CachedListNode.recycle(node);
            else
                node.destroy();
            node = node.next;
        }
        root = null;
        _current = null;
        numChildren = 0;
    }
    
}
 
class AgeListNode
{
    /** Stores a reference to the next link in the list */
    public var next : AgeListNode;
    
    /** Stores a reference to the object */
    public var object : QuadTreeEntity;

    public function new(?pObj: QuadTreeEntity = null)
    {
        object = pObj;
        next = null;
    }
    
    public function destroy()
    {
//        if(object != null) object.destroy();
        object = null;
//        if(next != null) next.destroy();
        next = null;
    }

}

class CachedListNode
{
    static var _list : List<AgeListNode>;
    static var _init : Bool = false;

    private static function init():Void
	{
		if(!_init)
		{
			_list = new List();
			_init = true;
		}
	}

    public static function get(?pObj: QuadTreeEntity = null):AgeListNode
    {
        init();        
        
        var node : AgeListNode;
        if(_list.length > 0)
        {
            node = _list.pop();
            node.object = pObj;
        }
        else
            node = new AgeListNode(pObj);
        return node;
    }
    
    public static function recycle(pVal: AgeListNode):Void
    {
        init();
        
        pVal.destroy();
        _list.add(pVal);
    }
    
    public static function clear():Void
    {
        for(v in _list)
            v.destroy();
        _list = new List();
    }

}
