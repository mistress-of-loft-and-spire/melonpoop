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
class Sky extends Entity
{
	
	var sky:Image = new Image("gfx/sky.png");
	
	var clouds1:Image = new Image("gfx/clouds.png");
	var clouds2:Image = new Image("gfx/clouds.png");
	
	var bird:Image = new Image("gfx/bird.png");
	var ballon:Image = new Image("gfx/ballon.png");
	
	var isSetup:Bool;

	public function new(isSetup:Bool = false) 
	{
		
		this.isSetup = isSetup;
		
		super(0, 0);
		
		layer = 400;
		
		sky.scaleX = HXP.width / sky.width;
		sky.scaleY = HXP.height / sky.height;
		
		if (!isSetup) addGraphic(sky);
		
		clouds1.scrollX = clouds2.scrollX = 0.8;
		
		addGraphic(clouds1);
		addGraphic(clouds2);
		
		if (isSetup)
		{
			clouds1.alpha = 0.04;
			clouds2.alpha = 0.04;
		}
		
		addGraphic(bird);
		
		bird.y = 30;
		
		bird.scrollX = ballon.scrollX = 0.9;
		
	}
	
	override public function update():Void
	{
		if (!isSetup)
		{
			if (Input.joystick(0).pressed(XBOX_GAMEPAD.START_BUTTON))
			{
				sky.color = HXP.choose([0xfce4eb, 0xfce4f9, 0xeae4fc, 0xe4f3fc, 0xe4fcf3, 0xeafce4, 0xfcf7e4, 0xffffff]);
			}
			
			clouds1.x = -Math.round(MainScene.rotationAngle / 0.375);
			
			clouds2.x = clouds1.x + 960;
		}
		else
		{
			clouds1.x -= 0.2;
			if(clouds1.x <= -960) clouds1.x = 0;
			
			clouds2.x = clouds1.x + 960;
		}
		
		bird.x -= 1;
		if(bird.x <= -960) bird.x = 960;
		
		super.update();
		
	}
	
}