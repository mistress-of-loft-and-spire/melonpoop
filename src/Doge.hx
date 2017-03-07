package;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import screen.Sky;

/**
 * ...
 * @author voec
 */
class Doge extends Scene
{
	
	var dog:Spritemap = new Spritemap("gfx/dog.png", 50, 50);

	override public function begin()
	{
		
		add(new Sky());
		
		dog.centerOrigin();
		
		addGraphic(dog, -100, HXP.halfWidth, HXP.halfHeight-70);
		
		dog.scale = 3;
		
	}
	
	override public function update():Void
	{
		dog.angle += 0.5;
		
		super.update();
	}
	
}