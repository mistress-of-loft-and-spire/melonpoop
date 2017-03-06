package ent;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.RenderMode;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.Tweener;
import com.haxepunk.ds.Either;
import com.haxepunk.graphics.Animation;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.atlas.Atlas;
import com.haxepunk.graphics.atlas.AtlasData;
import com.haxepunk.graphics.atlas.TileAtlas;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Joystick;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import openfl.display.BitmapData;
import openfl.display.IBitmapDrawable;
import openfl.geom.Point;
import openfl.geom.Vector3D;
import persp.Entity3D;
import util.Music;

/**
 * ...
 * @author voec
 */
class Seed extends Entity3D
{
	
	var sprite:Spritemap;

	// control: 0 = keyboard / 1 = controller 1 / 2 = controller 2
	public function new(x:Float = 10, y:Float = 20, z:Float = 0, spawn:Bool = false, control:Int = 0, number:Int = 1)
	{
		
		this.control = control;
		this.number = number;
		
		if (number == 1) sprite = new Spritemap("gfx/seed.png", 20, 22)
		else sprite = new Spritemap("gfx/seed2.png", 20, 22);
		
		addGraphic(sprite);
		
		sprite.centerOrigin();
		sprite.originY = 17;
		
		sprite.add("stand",[0],5);
		sprite.add("walking",[0,1,0,2],8);
		sprite.add("walking_up",[5,6,5,7],8);
		sprite.add("fall",[4],5);
		sprite.add("fall_up",[9],5);
		sprite.play("stand");
		
		super(x, y, z, -5, true);
		
		//sprite.scaleY = 0.9 + (HXP.rand(2) / 10);
		
		setHitbox(1, 1, 0, 0);
		
		if (spawn)
		{
			MainScene.music.greet.stop();
			MainScene.music.greet.play();
        }
	}
	
	public var number:Int = 1;
	
	var angChange:Float = HXP.choose([0.5,-0.5]);
	var ang:Float = 0;
	
	public var layerZ:Int = 0;
	
	public var flyMovement:Point = new Point(0,0);
	public var fallSpeed:Float = 0.1;
	public var fall:Bool = false;
	
	var hasBubble:Bool = false;
	
	var direction:Float = 0;
	var movement:Point = new Point(0,0);
	var maxSpeed:Float = 1.2;
	var walkingSpeed:Float = 0.25;
	
	public var control:Int = 0;

	override public function update():Void
	{
		
		//MOVEMENT
		
		if (control == 0 || MainScene.player == 1)
		{
		//going left and right -- X
		if (Input.check(Key.A)) movement.x -= walkingSpeed * MainScene.elapsed;
		if (Input.check(Key.D)) movement.x += walkingSpeed * MainScene.elapsed;
		
		//going up and down -- Y
		if (Input.check(Key.W)) movement.y -= walkingSpeed * MainScene.elapsed;
		if (Input.check(Key.S)) movement.y += walkingSpeed * MainScene.elapsed;
		}
		if (control == 1 )
		{
			var axisLX:Float = Input.joystick(0).getAxis(0);
			var axisLY:Float = Input.joystick(0).getAxis(1);
			
			movement.x += (walkingSpeed * axisLX) * MainScene.elapsed;
			movement.y += (walkingSpeed * axisLY) * MainScene.elapsed;
        }
		else
		{
			var axisLX:Float = Input.joystick(1).getAxis(0);
			var axisLY:Float = Input.joystick(1).getAxis(1);
			
			movement.x += (walkingSpeed * axisLX) * MainScene.elapsed;
			movement.y += (walkingSpeed * axisLY) * MainScene.elapsed;
		}
		
		movement.x += flyMovement.x * MainScene.elapsed;
		movement.y += flyMovement.y * MainScene.elapsed;
		
		layerZ = Math.floor(p.z / 5);
		
		if (Math.abs(movement.x) < 0.1) movement.x = 0;
		if (Math.abs(movement.y) < 0.1) movement.y = 0;
		
		//Zero Cutoff Margin
		if (movement.length > 0)
		{
			
			direction = HXP.angle(0, 0, movement.x, movement.y);
			
			if (direction < 170 && direction > 10) sprite.play("walking_up");
            else sprite.play("walking");
			
			if (direction > 100 && direction < 260) sprite.flipped= true;
            else if (direction > 280 || direction < 80) sprite.flipped = false;
			
			direction -= MainScene.rotationAngle;
			
			var moveX:Float = Math.cos(direction * (Math.PI / -180)) * HXP.clamp(movement.length,-(maxSpeed),maxSpeed) * MainScene.elapsed;
			var moveY:Float = Math.sin(direction * (Math.PI / -180)) * HXP.clamp(movement.length,-(maxSpeed),maxSpeed) * MainScene.elapsed;
			
			//COLLISION
			if (layerZ > 0)
			{
				if (collideWith(MainScene.melonSlice[layerZ - 1], p.x + moveX + MainScene.melonSlice[layerZ - 1].x, p.y + MainScene.melonSlice[layerZ - 1].y - 5) != null)
				{
					if (layerZ > 1 && collideWith(MainScene.melonSlice[layerZ - 2], p.x + moveX + MainScene.melonSlice[layerZ - 2].x, p.y + MainScene.melonSlice[layerZ - 2].y - 5) != null)
					{
						moveX = 0;
					}
					else if (fall == false)
					{
						p.z -= 1;
					}
            	}
				if (collideWith(MainScene.melonSlice[layerZ - 1], p.x + MainScene.melonSlice[layerZ - 1].x, p.y + moveY + MainScene.melonSlice[layerZ - 1].y - 5) != null)
				{
					if (layerZ > 1 && collideWith(MainScene.melonSlice[layerZ - 2], p.x + MainScene.melonSlice[layerZ - 2].x, p.y + moveY + MainScene.melonSlice[layerZ - 2].y - 5) != null)
					{
						moveY = 0;
					}
					else if (fall == false)
					{
						p.z -= 1;
					}
            	}
            }
			
			p.x += moveX;
			p.y += moveY;
			
        }
        else
		{
			//STANDING
			sprite.play("stand");
        }
		
		var friction:Float = 0.85;
		
		movement.x *= friction; movement.y *= friction;
		
		if (!fall)
		{
			//should i fall?
			if (layerZ >= 0 && layerZ <= MainScene.maxLayer && collideWith(MainScene.melonSlice[layerZ], p.x + MainScene.melonSlice[layerZ].x, p.y + MainScene.melonSlice[layerZ].y - 5) == null)
			{
				fall = true;
            }
        }
        else
		{
			//FALLING!
			if (direction < 170 && direction > 10) sprite.play("fall_up");
            else sprite.play("fall");
			
			if (layerZ > MainScene.maxLayer)
			{
				//FELL OUT OF WORLD
				MainScene.seeds.remove(this);
				scene.remove(this);
				
				scene.add(new Puff(p.x,p.y,p.z));
				
				if (HXP.rand(2) == 1) MainScene.music.seed_wa1.play(0.5);
            	else MainScene.music.seed_wa2.play(0.5);
            }
            else
			{
				if (layerZ >= 0 && fallSpeed >= 0 && collideWith(MainScene.melonSlice[layerZ], p.x + MainScene.melonSlice[layerZ].x, p.y + MainScene.melonSlice[layerZ].y - 5) != null)
				{
					//LANDING
					if (HXP.rand(3) == 0)
					{
					MainScene.music.seed_huh.stop();
					MainScene.music.seed_huh.play(0.3);
					}
					
					fall = false;
					fallSpeed = 0.1; //reset
					
					sprite.angle= 0;
					ang = 0;
					
					flyMovement.setTo(0, 0);
					
					p.z = layerZ * 5;
            	}
            	else
				{
					//FALL MOVEMENT
					if (layerZ > 0)
					{
						//HIT CEILING
						if (collideWith(MainScene.melonSlice[layerZ - 1], p.x + MainScene.melonSlice[layerZ - 1].x, p.y + MainScene.melonSlice[layerZ - 1].y - 5) != null)
						{
							fallSpeed = 0.5;
            			}
            		}
					
					p.z += fallSpeed * MainScene.elapsed;
					
					if (fallSpeed < 2.5) fallSpeed += 0.05 * MainScene.elapsed;
					
					flyMovement.x *= 0.96;
					flyMovement.y *= 0.96;
					
					ang += angChange * MainScene.elapsed;
					
					if (ang < 0) ang += 360;
					
					ang %= 360;
					
					sprite.angle = ang;
            	}
            }
        }
		
		//BEING EATEN
		if (p.x > MainScene.snake.p.x - 20 && p.x < MainScene.snake.p.x + 20 && p.y > MainScene.snake.p.y - 20 && p.y < MainScene.snake.p.y + 20)
		{
			if (MainScene.snake.layerZ < layerZ + 1 && MainScene.snake.layerZ > layerZ - 4)
			{
				if(number == 1) MainScene.snake.eaten1 += 1;
				else MainScene.snake.eaten2 += 1;
				
				MainScene.seeds.remove(this);
				scene.remove(this);
				
				scene.add(new Puff(p.x, p.y, p.z));
				
				if (HXP.rand(2) == 1) MainScene.music.seed_wa1.play(0.5);
            	else                  MainScene.music.seed_wa2.play(0.5);
            }
        }
		
		// JUMP
		if (control == 0 || MainScene.player == 1)
		{
			if (Input.pressed(Key.F) && !fall)
			{
				jump();
			}
		}
		if (control == 1)
		{
			if (Input.joystick(0).pressed(0) && !fall)
			{
				jump();
			}
		}
		else if (control == 2)
		{
			if (Input.joystick(1).pressed(0) && !fall)
			{
				jump();
			}
		}
		
		// TALK BUBBLE
		if (hasBubble && MainScene.bubble != null)
		{
			MainScene.bubble.p.setTo(p.x,p.y,p.z);
        }
		
		super.update();
	}

	public function addBubble(e:Dynamic = null):Void
    {
		MainScene.bubble = new EmojiBubble(p.x,p.y,p.z);
		scene.add(MainScene.bubble);
		hasBubble = true;
	}
	
	function jump(e:Dynamic = null):Void
	{
		fall = true;
		fallSpeed = -((Math.random() / 3) + 0.2);
		p.z -= 1;
	}
	
	override public function render():Void
	{
		super.render();
		sprite.scale = gfxScale;
	}
}