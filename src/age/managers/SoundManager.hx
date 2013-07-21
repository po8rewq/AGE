/** 
 * Author: adrien
 * Date: 21/07/13
 *
 * Copyright 2013 - RevoluGame.com
 */

package age.managers;

import age.utils.HtmlUtils;
import js.html.ArrayBuffer;
import js.html.audio.AudioBufferSourceNode;
import js.html.audio.AudioContext;
import js.html.audio.GainNode;

class SoundManager
{

    private static var _instance:SoundManager;

    public static function getInstance():SoundManager
    {
        if (_instance == null) _instance = new SoundManager();
        return _instance;
    }

    var _context : AudioContext;
//    var _volumeNode : GainNode;

    var _globalVolume : Float = 0.8;

    private function new()
    {
        var AudioContext = HtmlUtils.loadExtension("AudioContext").value;
        if(AudioContext != null)
        {
            _context = untyped __new__(AudioContext);
//            _volumeNode = _context.createGain();
//            setGlobalVolume(0.2);
        }
        else
            trace( "No audio context found" );
    }

    public function setGlobalVolume(pVal: Float)
    {
        _globalVolume = pVal;
    }

    /**
     * Create the source object after downloading it
     **/
    private function getSource(pAudioData: ArrayBuffer): AudioBufferSourceNode
    {
        if(_context == null) return null;

        // create a sound source
        var soundSource = _context.createBufferSource();

        // The Audio Context handles creating source buffers from raw binary
        var soundBuffer = _context.createBuffer(pAudioData, true/* make mono */);

        // Add the buffered data to our object
        soundSource.buffer = soundBuffer;

        //
//        var gainNode = _context.createGain();
//        soundSource.connect(gainNode,0,0);

        // Plug the cable from one thing to the other
        soundSource.connect(_context.destination, 0, 0);
//        soundSource.connect(_volumeNode, 0, 0);

// Reduce the volume.
//        gainNode.gain.value = 0.5;

        return soundSource;
    }

    /**
     * Play a sound
     **/
    public function play(pName: String, ?pPos: Int = 0, ?pLoop: Bool = false)
    {
        if(_context == null) return;

        var s : Dynamic = getSource(Assets.getSound(pName));

        // Turn on looping
        if(pLoop)
            s.loop = pLoop;

        if( Reflect.field(s, "start") )
            s.start(pPos);
        else
            s.noteOn(pPos); // -> old systems
    }

    public function stop(pName: String)
    {
        if(_context == null) return;
                               // TODO
//        var s : Dynamic = Assets.getSound(pName);
//        s.noteOff(_context.currentTime);
    }

}