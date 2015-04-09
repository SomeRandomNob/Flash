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

//needed for colors
	public class shootingAs extends MovieClip
	{
		public function shootingAs()
		{
			//variables
			var dir:String = "stop";
			var bA:Array = new Array;
			var fire:Boolean = false;
			var drop:Boolean = false;
			var num:Number = 0;
			var wsh:Sound = new woosh();
			var music:Sound = new backS();
			var aliens:Array = new Array  ;
			var spd:Number = 3;
			var sc:Number = 0;
			//onload
			var bx:box = new box;
			bx.x = 225;
			bx.y = 380;
			bx.rotation = 90;
			addChild(bx);
			music.play(0, 172);
			loadAl();
			var t:TextField = new TextField  ;//adds lives to screen
			t.x = 275;
			t.y = 300;
			var tf:TextFormat = new TextFormat;
			t.text = String(lives);//the variable lives will be printed to screen
			tf.color = 0xFF00FF;
			t.setTextFormat(tf);
			addChild(t);
			//event listeners
			addEventListener(Event.ENTER_FRAME,gameLoop);
			function gameLoop(e:Event)
			{
				moveShit();
				shootBullet();
				ballControl();
				moveAliens();
				hitBox();
			}
			stage.addEventListener(KeyboardEvent.KEY_DOWN, downkey);
			function downkey(e:KeyboardEvent):void {//when certain keycode is down, change dir to match the direction.
				if (e.keyCode==37) dir = "left"; //'<'
				if (e.keyCode==39) dir = "right";//'>'
				if (e.keyCode==32) fire = true;
				if (e.keyCode==81) trace(drop);
			}
			stage.addEventListener(KeyboardEvent.KEY_UP, upkey);
			function upkey(e:KeyboardEvent):void {
				if (e.keyCode == 37 || e.keyCode == 39) dir="stop";//when you're not holding any keys, stay in place
			}
			//functions
			function hitBox():void{
				for (var k:Number = 0; k < aliens.length; k++){
					for (var j:Number = 0; j < bA.length; j++){
						if (bA[j].hitTestObject(aliens[k])){
							removeChild(aliens[k]);
							aliens.splice(k, 1);
							removeChild(bA[j]);
							bA.splice(j, 1);
						}
					}
				}
			}
			function moveAliens():void {
				drop = false;
				for (var u:Number=0; u<aliens.length; u++) {
					if (aliens[u].x > 550 || aliens[u].x <0) {
						drop = true;
					}
				}
				if (drop) {
					spd *= -1;
					for (var v:Number=0; v<aliens.length; v++) {
						aliens[v].y += 15;
					}
				}
			}
			function moveShit(){
				if (dir == "left"  && bx.x >= 30)   bx.x -= 3;
				if (dir == "right" && bx.x <= 520)  bx.x += 3;
				for (var g:Number = 0; g < aliens.length; g++){
					aliens[g].x += spd;
				}
				for (var h:Number = 0; h < bA.length; h++){
					bA[h].y -= 5;
				}
			}
			function ballControl(){
				for (var i:Number = 0; i < bA.length; i++){
					if (bA[i].y < 12) {
						removeChild(bA[i]);
						bA.splice(i,1);
					}
				}
			}
			function shootBullet(){
				if (fire == true){
					var b:ball = new ball;
					bA.push(b);
					addChild(bA[bA.length-1]);
					wsh.play();
					bA[bA.length-1].x = bx.x;
					bA[bA.length-1].y = bx.y;
					fire = false;
					
					}
			}
			function loadAl():void{
				for (var i:Number = 0; i < 6; i++)
				{
					for (var j:Number = 0; j < 10; j++)
					{
						if (i < 2){
						var a:alien = new alien;
						aliens.push(a);
						}
						else if(i < 4){
						var a2:alien2 = new alien2;
						aliens.push(a2);
						}
						else {
						var a3:alien3 = new alien3;
						aliens.push(a3);
						}
						addChild(aliens[num2]);
						aliens[num2].x = j * 30+ 15;
						aliens[num2].y = i * 30 + 15;
						num2++;
					}
				}
			}
		}
	}
}