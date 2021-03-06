package age.display;

import js.html.CanvasRenderingContext2D;
import age.core.IEntity;

class EntityContainer implements IEntity
{
	var _entities : Array<IEntity>;

	public var visible : Bool;
	public var x : Int;      // TODO : heritage de la position !!
	public var y : Int;
	public var width : Int;
	public var height : Int;

    public var depth : Int;

	public function new()
	{
		_entities = new Array();
		visible = true;
		x = y = width = height = depth = 0;
	}

	public function update()
	{
		for(en in _entities)
			en.update();
	}

	public function add(pEntity: IEntity)
	{
		_entities.push(pEntity);
	}

	public function remove(pEntity: IEntity)
	{
		if(pEntity != null)
		{
			_entities.remove(pEntity);
	        pEntity.destroy();
	    }
	}

	public function removeAll()
	{
		for(e in _entities)
			remove(e);
	}

	public function render(pContext: CanvasRenderingContext2D):Void
	{
		for(en in _entities)
			if(en.visible)
				en.render(pContext);
	}

	public function destroy()
	{
		for(en in _entities)
			en.destroy();
        _entities = new Array();
	}

    public function numChildren(): Int
    {                  // TODO : recursif
        return _entities.length;
    }

}
