import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.BitmapText;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import ent.Layer;
import ent.Seed;
import ent.Snake;
import ent.Stem;
import persp.Camera3D;
import persp.Horizon;
import ent.EmojiBubble;
import screen.Lost;
import screen.Sky;

class MainScene extends Scene
{
	
	public static var rotationAngle:Float = 20;
	public static var seed:Seed;
	public static var score:Int = 0;

	override public function begin()
	{
		
		rotationAngle = 20;
		seed = null;
		score = 0;
		
		//-------- KEY MAPPING
		
		Input.define("yes", [Key.SPACE, Key.ENTER, Key.NUMPAD_ENTER, Key.F, Key.E]);
		Input.define("no", [Key.ESCAPE]);
			
		Input.define("up", [Key.W]);
		Input.define("down", [Key.S]);
		Input.define("left", [Key.A]);
		Input.define("right", [Key.D]);
		
		//--------
		
		add(new Camera3D(0, 0, 320));
		
		add(new Sky());
		
		for (i in 0...50)
		{
			add(new Layer(0, 0, i));
		}
		
		for (i in 0...8)
		{
			add(new Stem(0, 0, i));
		}
		
		seed = new Seed();
		add(seed);
		
		//add(new Snake());
		
		add(new Lost());
		
	}
	
	override public function update():Void
	{
		
		if (Input.check(Key.LEFT))
		{
			rotationAngle -= 1;
		}
		if (Input.check(Key.RIGHT))
		{
			rotationAngle  += 1;
		}
		
		//normalize rotation angle
		
		if (rotationAngle < 0)
		{
			rotationAngle += 360;
		}
		
		rotationAngle = rotationAngle % 360;
		
		super.update();
		
	}

}