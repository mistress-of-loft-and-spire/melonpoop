import com.haxepunk.debug.Console.TraceCapture;
import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import openfl.Lib;

class Main extends Engine
{
	
	/*
	 * credits:
	 * 
	 *  Jupiter Hadley    Larua fnt
	 * 
	 * tweemoji   
	 * 
	 * 
	 * 
	 * 
	 */

	override public function init()
	{
#if debug
		HXP.console.enable(TraceCapture.Yes, Key.F1);
		
		trace(HXP.VERSION);
#end
		
		HXP.screen.color = 0xcaf8f2;
		
		HXP.screen.smoothing = false;
		
		HXP.stage.quality = LOW;
		
		HXP.screen.scale = 1;
		
		HXP.scene = new MainScene();
	}
	
	override public function update():Void
	{
		
		if (Input.pressed(Key.F5)) init();
		
		if (Input.pressed(Key.ESCAPE))
		{
#if (!flash && !html5)
			Lib.exit();
#end
		}
		
		super.update();
		
	}

	public static function main() { new Main(); }

}