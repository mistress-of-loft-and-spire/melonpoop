package screen;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

/**
 * ...
 * @author voec
 */
class Sky extends Entity
{
	
	var sky:Image = new Image("gfx/sky.png");
	
	var clouds1:Image = new Image("gfx/clouds.png");
	var clouds2:Image = new Image("gfx/clouds.png");
	
	var bird1:Image = new Image("gfx/bird.png");
	var bird2:Image = new Image("gfx/bird.png");
	var bird3:Image = new Image("gfx/bird.png");
	var bird4:Image = new Image("gfx/bird.png");
	var bird5:Image = new Image("gfx/bird.png");
	var ballon:Image = new Image("gfx/ballon.png");

	public function new() 
	{
		
		super(0, 0);
		
		layer = 400;
		
		sky.scaleX = HXP.width / sky.width;
		sky.scaleY = HXP.height / sky.height;
		
		addGraphic(sky);
		
		clouds1.scrollX = clouds2.scrollX = 0.8;
		
		addGraphic(clouds1);
		addGraphic(clouds2);
		
		bird1.scrollX = bird2.scrollX = bird3.scrollX = bird4.scrollX = bird5.scrollX = ballon.scrollX = 0.9;
		
	}
	
	override public function update()
	{
		
		clouds1.x = -Math.round(MainScene.rotationAngle / 0.375);
		
		clouds2.x = clouds1.x + 960;
		
		super.update();
		
	}
	
}