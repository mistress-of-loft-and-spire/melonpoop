package screen;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Joystick.XBOX_GAMEPAD;

/**
 * ...
 * @author voec
 */
class Kaleido extends Entity
{
	
	var sky:Image = new Image("gfx/kaleido.png");

	public function new() 
	{
		
		super(0, 0);
		
		layer = -200;
		
		sky.scaleX = HXP.width / sky.width;
		sky.scaleY = HXP.width / sky.width;
		
		sky.centerOrigin();
		
		sky.x = HXP.halfWidth;
		sky.y = HXP.halfHeight;
		
		sky.scale = 4;
		
		addGraphic(sky);
		
	}
	
	override public function update():Void
	{
		
		sky.scale -= 0.1 * MainScene.elapsed;
		
		if (sky.scale <= 0) scene.remove(this);
		
		super.update();
		
	}
	
}