import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.BitmapText;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import ent.Dog;
import ent.Layer;
import ent.Puff;
import ent.Seed;
import ent.Snake;
import ent.Spawn;
import ent.Stem;
import haxe.xml.Fast;
import openfl.Assets;
import persp.Camera3D;
import persp.Horizon;
import ent.EmojiBubble;
import screen.Icon;
import screen.Kaleido;
import screen.Lost;
import screen.Plus;
import screen.PressA;
import screen.Sky;
import util.Music;

class MainScene extends Scene
{
	
	public static var rotationAngle:Float = HXP.rand(180);
	
	public static var seeds:Array<Seed>;
	public static var melonSlice:Array<Layer>;
	
	public static var snake:Snake;
	
	//public static var xml:Xml = Xml.parse(Assets.getText("dat/grid.xml"));
	//quick dirty string convert, because fastXML does not work on mac????
	public static var fastXml:String = "00000000000111100000000000\n00000000001111110000000000\n00000000111111111100000000\n00000001111111111110000000\n00000011111111111111000000\n0001111111111111111110000\n00011111111111111111111000\n00111111111111111111111100\n11111111111111111111111111\n11111111111111111111111111\n11111111111111111111111111\n11111111111111111111111111\n11111111111111111111111111\n01111111111111111111111110\n01111111111111111111111110\n01111111111111111111111110\n00111111111111111111111100\n00111111111111111111111100\n00111111111111111111111100\n00011111111111111111111000\n00011111111111111111111000\n00011111111111111111111000\n00001111111111111111110000\n00001111111111111111110000\n00001111111111111111110000";
	
	public static var music:Music;
	
	public static var maxLayer:Int = 0;

	override public function begin()
	{
		
		rotationAngle = 0;
		seeds = new Array<Seed>();
		melonSlice = new Array<Layer>();
		snake = null;
		
		//------- MUSIC
		
		music = new Music();
		
		add(music);
		
		music.loop(music.main);
		
		//--------
		
		add(new Camera3D(0, -285, 40));
		
		add(new Sky());
		
		
		
		maxLayer = 12;
		
		for (i in 0...maxLayer + 1)
		{
			melonSlice.push(new Layer(0, 0, i));
			add(melonSlice[i]);
		}
		
		for (i in 0...8)
		{
			add(new Stem(0, 0, i));
		}
		
		add(new PressA(HXP.halfWidth + 300, HXP.halfHeight + 200));
		//add(new Controls(HXP.halfWidth - 330, HXP.halfHeight - 150));
		
		ico1 = new Icon(HXP.halfWidth - 110, HXP.halfHeight - 50, "melon", true);
		ico2 = new Icon(HXP.halfWidth + 110, HXP.halfHeight - 50, "poop", true);
		
		add(new Kaleido());
		
		add(ico1);
		add(ico2);
		
		var deku:Sfx = new Sfx("sfx/dekuscrub.ogg");
		deku.play();
		
		intro = true;
		angleChange = 0;
		camZoom = 0;
		timer = 0;
		dogtime = false;
		
		lost = false;
		
		HXP.alarm(2, snakeAlarm, TweenType.Looping);
		
	}
	
	var intro:Bool = true;
	var camZoom:Float = 0;
	var angleChange:Float = 0;
	
	public static var lost:Bool = false;
	
	public static var meanZ:Float = 0;
	
	public static var bubble:EmojiBubble = null;
	public static var bubble2:EmojiBubble = null;
	
	var ico1:Icon;
	var ico2:Icon;
	
	public static var elapsed:Float = 0;
	var timer:Float = 0;
	
	public static var snakeColor:Int = 0x84dddd;
	
	var snakeColorArray:Array<Int> = [0x71bebe, 0x717ebe, 0xb171be, 0xbe7171, 0xbeb171, 0x97be71, 0x71be8b];
	var snakeColorIndex:Int = 0;
	
	public static var player:Int = 1;
	public static var control1:Int = 1;
	public static var control2:Int = -1;
	
	public static var dogtime:Bool = false;
	var dogtimer:Float = 0;
	
	function snakeAlarm(e:Dynamic = null):Void
	{
		snakeColorIndex += 1;
		if (snakeColorIndex > 6) snakeColorIndex = 0;
	}
	
	override public function update():Void
	{
		
		elapsed = HXP.elapsed * 60;
		
		snakeColor = HXP.colorLerp(snakeColor, snakeColorArray[snakeColorIndex], 0.04);
		
		if (intro)
		{
			angleChange += 0.02;
			
			if (Input.joystick(0).pressed() || Input.joystick(1).pressed() || Input.pressed(Key.SPACE) || Input.pressed(Key.ENTER) || Input.pressed(Key.F) || Input.pressed(Key.A))
			{
				ico1.delete();
				ico2.delete();
				
				intro = false;
				camZoom = 0.7;
				
				seeds.push(new Seed((Math.random() * 120) - 60, (Math.random() * 120) - 60,-30,false,control1));
				add(MainScene.seeds[0]);
				add(new Puff(MainScene.seeds[0].p.x, MainScene.seeds[0].p.y, MainScene.seeds[0].p.z));
				
				if (player == 2)
				{
					seeds.push(new Seed((Math.random() * 120) - 60, (Math.random() * 120) - 60,-30,false,control2,2));
					add(MainScene.seeds[1]);
					add(new Puff(MainScene.seeds[1].p.x, MainScene.seeds[1].p.y, MainScene.seeds[1].p.z));
				}
				
				for (i in 0...3 * player)
				{
					add(new Spawn((Math.random() * 180) - 90, (Math.random() * 180) - 90));
            	}
				
				snake = new Snake(150 * HXP.choose([1,-1]), 150 * HXP.choose([1,-1]));
				
				add(MainScene.snake);
				
				var whi:Sfx = new Sfx("sfx/whistle.ogg");
				whi.play(0.8);
            }
			
			super.update();
        }
        else
		{
			if (MainScene.seeds.length <= 0)
			{
				if (!(MainScene.lost))
				{
					add(new Lost());
            	}
				
				lost = true;
				
				angleChange += 0.02;
				
				checkRotate();
				
				super.update();
            }
			else
			{
				if(dogtime)
				{
					dogtimer -= HXP.elapsed;
					if (dogtimer <= 0)
					{
						add(new Dog((Math.random() * 360) - 180, (Math.random() * 360) - 180));
						dogtimer += HXP.choose([1, 2, 3]);
					}
				}
				
				//BUBBLE! -#-#-#-#-#-#-#-#-#-#-
				if (bubble == null)
				{
					if (control1 == 0)
					{
						if (Input.pressed(Key.SPACE) || Input.pressed(Key.E)) newBubble(1);
					}
					else if (control1 == 1)
					{
						if (Input.joystick(0).pressed(1) || Input.joystick(0).pressed(3) || Input.joystick(0).pressed(2)) newBubble(1);
					}
					else
					{
						if (Input.joystick(1).pressed(1) || Input.joystick(1).pressed(3) || Input.joystick(1).pressed(2)) newBubble(1);
					}
				}
				if (player == 2 && bubble2 == null)
				{
					if (control2 == 0)
					{
						if (Input.pressed(Key.SPACE) || Input.pressed(Key.E)) newBubble(2);
					}
					else if (control2 == 1)
					{
						if (Input.joystick(0).pressed(1) || Input.joystick(0).pressed(3) || Input.joystick(0).pressed(2)) newBubble(2);
					}
					else
					{
						if (Input.joystick(1).pressed(1) || Input.joystick(1).pressed(3) || Input.joystick(1).pressed(2)) newBubble(2);
					}
				}
				
				
				super.update();
				
				checkRotate();
            }
        }
		
		camZoom = HXP.clamp(camZoom, 0, 1);
		
		Camera3D.offset.y = -270 + (-450 * camZoom);
		Camera3D.offset.z = 40 + (330 * camZoom);
		
		var offsetAddX:Float = 0;
		var offsetAddY:Float = 0;
		var offsetAddZ:Float = 0;
		
		if (MainScene.seeds.length == 0)
		{
			offsetAddX = 480;
			offsetAddY = 280;
			camZoom = 0;
			meanZ= 0;
        }
        else
		{
			for (i in 0...seeds.length)
			{
				offsetAddX = offsetAddX + seeds[i].x;
				offsetAddY = offsetAddY + seeds[i].y;
				offsetAddZ = offsetAddZ + seeds[i].p.z;
            }
			offsetAddX = offsetAddX / seeds.length;
			offsetAddY = offsetAddY / seeds.length;
			offsetAddZ = offsetAddZ / seeds.length;
			
			meanZ = offsetAddZ;
        }
		
		Camera3D.camera.setTo(
		Camera3D.camera.x + ((( -960 + offsetAddX) - Camera3D.camera.x) * 0.05),
		Camera3D.camera.y + ((((Camera3D.offset.y + offsetAddY) - 280) - Camera3D.camera.y) * 0.05),
		Camera3D.camera.z + (((Camera3D.offset.z + offsetAddZ) - Camera3D.camera.z) * 0.05));
		
		angleChange *= 0.8;
		manualChange *= 0.8;
		
		angleChange = HXP.clamp(angleChange, -0.8, 0.8);
		manualChange = HXP.clamp(manualChange, -0.3, 0.3);
		
		if (Math.abs(angleChange) < 0.04) { angleChange = 0; }
		
		
		rotationAngle += angleChange;
		if(angleChange == 0) rotationAngle +=  manualChange;
		
		if (rotationAngle < 0) rotationAngle += 360;
		
		rotationAngle %= 360;
		
	}
	
	var manualChange:Float = 0;
	
	function checkRotate(e:Dynamic = null):Void
	{
		
		if (control1 == 0 || control2 == 0)
		{
			if (Input.check(Key.LEFT)) angleChange += 0.2;
			if (Input.check(Key.A)) manualChange += 0.05;
			if (Input.check(Key.RIGHT)) angleChange -= 0.2;
			if (Input.check(Key.D)) manualChange -= 0.05;
			
			if (Input.check(Key.UP)) camZoom += 0.01;
			if (Input.check(Key.DOWN)) camZoom -= 0.01;
		}
		if (control1 == 1 || control2 == 1)
		{
			if (Input.joystick(0).check(4)) angleChange += 0.2;
			if (Input.joystick(0).check(5)) angleChange -= 0.2;
			
			var axisRX:Float = Input.joystick(0).getAxis(3);
			var axisRY:Float = Input.joystick(0).getAxis(4);
			
			var axisLX:Float = Input.joystick(0).getAxis(0);
			
			angleChange += 0.2 * axisRX;
			manualChange -= 0.05 * axisLX;
			camZoom = camZoom - (0.01 * axisRY);
		}
		if (control1 == 2 || control2 == 2)
		{
			if (Input.joystick(1).check(4)) angleChange += 0.2;
			if (Input.joystick(1).check(5)) angleChange -= 0.2;
			
			var axisRX2:Float = Input.joystick(1).getAxis(3);
			var axisRY2:Float = Input.joystick(1).getAxis(4);
			
			var axisLX2:Float = Input.joystick(1).getAxis(0);
			
			angleChange += 0.2 * axisRX2;
			manualChange -= 0.05 * axisLX2;
			camZoom = camZoom - (0.02 * axisRY2);
		}
		
		
	}
	
	function newBubble(num:Int = 1):Void
	{
		var arr:Array<Int> = new Array<Int>();
		for (i in 0...seeds.length)
		{
			if (seeds[i].number == num) arr.push(i);
		}
		
		if(arr.length != 0) seeds[arr[HXP.rand(arr.length - 1)]].addBubble();
		
	}

}