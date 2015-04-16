package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;//only needed if controling paddle with keyboard.
	import flash.media.Sound; //needed for sound
	import flash.geom.ColorTransform;
	import fl.motion.easing.Back;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

//needed for colors
	public class tank extends MovieClip
	{
		public function tank()
		{
			//variables
			var col:Number = 0;
			var shot:Number = 0;
			var bA:Array = new Array;
			var xA:Array = new Array;
			var yA:Array = new Array;
			var aArray:Array = new Array;
			var mysound:Sound = new Sound;
			var myfile:URLRequest = new URLRequest("Woosh.mp3")
			//onload
			var t:box = new box;
			t.x = 275;
			t.y = 370;
			addChild(t);
			var s:straw = new straw;
			s.x = t.x;
			s.y = t.y;
			addChild(s);
			mysound.load(myfile);
			var total:TextField = new TextField;//adds lives to screen
			total.x = 275;
			total.y = 300;
			addChild(total);
			total.text = String(bA.length + "Balls on stage");//the variable lives will be printed to screen
			var cols:TextField = new TextField;//adds lives to screen
			cols.x = 275;
			cols.y = 250;
			addChild(cols);
			cols.text = String(col);//the variable lives will be printed to screen
			var shots:TextField = new TextField;//adds lives to screen
			shots.x = 275;
			shots.y = 200;
			addChild(shots);
			shots.text = String(shot);//the variable lives will be printed to screen
			//event listeners
			addEventListener(Event.ENTER_FRAME, gameLoop);
			stage.addEventListener(MouseEvent.CLICK, shoot);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, aim);
			//functions
			function gameLoop(e:Event){
				moveBullets();
				updateStuff();
				hitBox();
			}
			function moveBullets():void{
				for(var i:Number = 0; i < bA.length; i++){
					bA[i].y += yA[i];
					bA[i].x += xA[i];
					yA[i] += .3;
					if (bA[i].y < 10 || bA[i].y > 390 ||bA[i].x < 10 || bA[i].x > 540) {
						removeChild(bA[i]);
						aArray.splice(i, 1);
						xA.splice(i, 1);
						yA.splice(i, 1);
						bA.splice(i,1);
						break;
					}
				}
			}
			function updateStuff():void{
				total.text = String(bA.length + "Balls on stage");
				cols.text = String(col + "collisons taken place");
				shots.text = String(shot + "shots taken");
			}
			function hitBox():void{
				for (var k:Number = 0; k < bA.length; k++){
					for (var j:uint = k + 1; j < bA.length; j++){
						if (k != j && bA[k].hitTestObject(bA[j])){
							yA[k] *= -1;
							yA[j] *= -1;
							//trace("gg");
							col += 1;
							break;
						}
					}
				}
			}
			function aim(e:MouseEvent):void{
				var angle = Math.atan2(mouseY - s.y, mouseX - s.x);
				angle = angle * 180/Math.PI + 90;
				s.rotation = angle;
			}
			function shoot(e:MouseEvent):void{
				mysound.play(0, 1);
				var b:ball = new ball;
				bA.push(b);
				addChild(bA[bA.length-1]);
				bA[bA.length-1].x = t.x;
				bA[bA.length-1].y = t.y;
				var angle = Math.atan2(mouseY - s.y, mouseX - s.x);
				xA.push(12*Math.cos(angle));
				yA.push(12*Math.sin(angle));
				aArray.push(angle);
				shot += 1;
				
			}
		}
	}
}