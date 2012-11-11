package com.revolugame.age.managers;

class BehaviorsManager
{
    /** Singleton */
    private static var _instance : BehaviorsManager;
    
    private var _updaters : List<Void->Void>;
    
    public static function getInstance():BehaviorsManager
    {
        if(_instance == null)
            _instance = new BehaviorsManager();
        return _instance;
    }
    
    private function new():Void
    {
        _updaters = new List();
    }
    
    public function registerUpdater(fnc: Void->Void):Void
    {
        _updaters.add(fnc);
    }
    
    public function unregisterUpdater():Void
    {
    
    }
    
    public function update():Void
    {
        for(u in _updaters)
            u();
    }
    
}
