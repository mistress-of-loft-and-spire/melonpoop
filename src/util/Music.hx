package util;

import Std;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Sfx;
import com.haxepunk.Tweener;

/**
 * ...
 * @author voec
 */
class Music extends Entity
{
	
	public var greet:Sfx = new Sfx("sfx/greet0" + (HXP.rand(4) + 1) + ".ogg");
	
	public var seed_wa2:Sfx = new Sfx("sfx/shriek.ogg");
	public var seed_wa1:Sfx = new Sfx("sfx/waaaah.ogg");
	
	public var seed_huh:Sfx = new Sfx("sfx/huh.ogg");
	public var seed_fly:Sfx = new Sfx("sfx/fly.ogg");
	
	//music
	public var ending:Sfx = new Sfx("sfx/music/kredits.ogg");
	public var main:Sfx = new Sfx("sfx/music/tomatillo.ogg");
	
	var fadeout:String;
	
	public function new() 
	{
		
		visible = false;
		
		super();
	}

	public function play(sound:Sfx):Void
	{
		sound.play(0);
	}

	public function loop(sound:Sfx):Void
    {
		sound.loop(0);
	}

	public function fadeOut(sound:String)
    {
		fadeout = sound;
	}
	
	override public function update():Void
	{
		
		if (main.playing && main.volume < 0.8 && fadeout != "main")
		{
			main.volume += 0.01 * MainScene.elapsed;
		}
		if (ending.playing && ending.volume < 0.6 && fadeout != "ending")
		{
			ending.volume += 0.01 * MainScene.elapsed;
        }
		
		if (fadeout == "main")
		{
			if (main.volume > 0)
			{
				main.volume -= 0.005 * MainScene.elapsed;
			}
			else main.stop();
        }
        if (fadeout == "ending")
		{
			if (ending.volume > 0)
			{
			ending.volume -= 0.01 * MainScene.elapsed;
			}
			else ending.stop();
        }
		
		super.update();
	}


}