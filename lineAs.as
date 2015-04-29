package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.geom.ColorTransform;
	import fl.motion.easing.Back;
	import flash.events.MouseEvent;
	import fl.motion.Color;
	import fl.motion.easing.Linear;
	import flash.geom.ColorTransform;
	
	public class lineAs extends MovieClip
	{
		public function lineAs()
		{//no sounds or animation, everythings else should be 100%
			//variables
			var speed:Number = 0;//speed, needed for x/yArray calculations
			var rotat:Number = 0;//variable used to keep math calculations
			var shot:Number = 0;//amount of shot taken
			var killed:Number = 0;//asts destroid
			var spawnRate:Number = 40;//24 frames in a second, draws new one every ~1.9s base speed
			var fNum:Number = 0;//counter
			var lives:Number = 3;
			var dir:String = "stop";
			var mDown:Boolean = false;//if mouse button is held down
			//arrays
			var astA:Array = new Array();//stores astroids
			var bArray:Array = new Array();//stores the bulletss
			var xArray:Array = new Array();//stores x and y speeds respectivly
			var yArray:Array = new Array();
			//load stuff
			var l:line= new line();//defines line
			var s:start= new start();//defines start
			addChild(s);
			s.x = -50;
			var g:gun = new gun();//defines and places the gun
			addChild(g);
			g.x = 275;
			g.y = 395;
			//textboxes
			var lvlTxt:TextField = new TextField();//displays spawnRate
			lvlTxt.x = 50;
			lvlTxt.y = 50;
			lvlTxt.text = String("This is nothin");
			var lTf:TextFormat = new TextFormat
			addChild(lvlTxt);
			var lenTxt:TextField = new TextField();//length of the line drawn
			lenTxt.x = 50;
			lenTxt.y = 50;
			lenTxt.text = String(Math.floor(l.length));
			var accTxt:TextField = new TextField();//accuracy %
			accTxt.x = 100;
			accTxt.y = 100;
			accTxt.text = String(Math.floor(killed / shot * 100) + "%");
			addChild(accTxt);
			var livesTxt:TextField = new TextField();//lives left
			livesTxt.x = 100;
			livesTxt.y = 300;
			livesTxt.text = String(lives + "lives left");
			addChild(livesTxt);
			var killsTxt:TextField = new TextField();//total asts destoid
			killsTxt.x = 100;
			killsTxt.y = 270;
			killsTxt.text = String(killed);
			addChild(killsTxt);
			//listeners
			addEventListener(Event.ENTER_FRAME, main);
			function main(e:Event):void
			{
				makeAst();//makes the astroids
				moveBullets();//moves bullets & ast-bul hitboxes
				moveAst();//moves asts down, removes when offstage
				bulBounce();//makes bullets bounce off eachother
				moveGun();//left or right
				textRefresher();
				if (lives <= 0) gameOver();
			}
			stage.addEventListener(MouseEvent.MOUSE_DOWN, dFun);
			function dFun(e:MouseEvent):void
			{
				mDown = true;
				s.x = mouseX;
				s.y = mouseY;
				l.x = mouseX;
				l.y = mouseY;
			}
			stage.addEventListener(MouseEvent.MOUSE_UP, uFun);
			function uFun(e:MouseEvent):void
			{
				mDown = false;
				s.x = -600;
				s.y = -600;
				//make bullets, add to array
				var b:bullet = new bullet();
				bArray.push(b);
				addChild(bArray[bArray.length -1]);
				bArray[bArray.length - 1].x = g.x;
				bArray[bArray.length - 1].y = g.y;
				bArray[bArray.length - 1].rotation = g.rotation;
				//math for the angles
				var tempAngle:Number = (g.rotation-90)*Math.PI/180;
				xArray.push(Math.cos(tempAngle)*speed/12 );
				yArray.push(Math.sin(tempAngle)*speed/12 );
				shot++;//amount of shots taken
				g.rotation = 0;
				removeChild(l);//hides line and accompany text
				removeChild(lenTxt);
			}
			stage.addEventListener(KeyboardEvent.KEY_DOWN, downkey);
			function downkey(e:KeyboardEvent):void {//when certain keycode is down, change dir to match the direction.
				if (e.keyCode==37) dir="left"; //'<'
				if (e.keyCode==39) dir="right";//'>'
				/*if (e.keyCode==81) spawnRate = 8; dev tools
				if (e.keyCode==38) trace(fNum);*/
			}
			stage.addEventListener(KeyboardEvent.KEY_UP, upkey);
			function upkey(e:KeyboardEvent):void {
				if (e.keyCode == 37 || e.keyCode == 39) dir="stop";//when you're not holding any keys, stay in place
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE, drawLine);
			function drawLine(e:MouseEvent):void
			{
				if (mDown==true)//when mouse is down
				{
					var dx:Number = s.x - mouseX;
					var dy:Number = s.y - mouseY;
					var dist:Number = Math.sqrt(dx*dx + dy*dy);
					speed = dist;
					l.scaleY = dist / 100;
					if (l.x != mouseX && l.y != mouseY){//when mouse moves off of original click point
						addChild(l);
						addChild(lenTxt);
					}
					var angle:Number = Math.atan2(dy,dx);
					l.rotation = angle * 180 / Math.PI - 90;
					g.rotation = angle * 180 / Math.PI + 90;
				}
			}
			//functions
			function makeAst():void{
				fNum++;
					if (fNum >= spawnRate){//runs this every few frames, depending on spawnRate
						fNum = 0;
						var a:ast = new ast();//makes an ast and adds it to the array
						a.rotation = Math.random() * 360;
						astA.push(a);
						addChild(astA[astA.length - 1]);
						astA[astA.length - 1].x = Math.random() * 550;
					}
			}
			function moveBullets():void
			{
				for (var i:Number =0; i<bArray.length; i++)
				{
					bArray[i].x +=  xArray[i];//moves bullets at proper angles
					bArray[i].y +=  yArray[i];
					yArray[i] +=  .3;//gravity
					rotat = Math.atan2(yArray[i], xArray[i]) * 180;//rotates bullet in air
					bArray[i].rotation = rotat / Math.PI + 90;
					//offstage code
					if (bArray[i].x > 550 || bArray[i].x < 0 || bArray[i].y > 450){
						removeChild(bArray[i]);
						bArray.splice(i, 1);
						xArray.splice(i, 1);
						yArray.splice(i, 1);
					}
					else{//if bullet isn't going offstage, check if it's colliding w/ ast
						for (var j:Number = 0; j < astA.length; j++){
							if (bArray[i].hitTestObject(astA[j])){//removes all the arrays, when they colide
								if (Math.random() < .3) spawnRate--;//1 in 3 hits will speed it up
								removeChild(bArray[i]);
								bArray.splice(i, 1);
								xArray.splice(i, 1);
								yArray.splice(i, 1);
								removeChild(astA[j]);
								astA.splice(j, 1);
								killed ++;//+1 to total killed
							}
						}
					}
				}
			}
			function moveAst():void{//
				for (var i:Number = 0; i < astA.length;i++){
					astA[i].y += 5;//moves asts down
					if (astA[i].y > 420){//removes once offstage
						removeChild(astA[i]);
						astA.splice(i, 1)
						lives--;
					}
				}
			}
			function bulBounce():void{//makes bullets bounce off eachother
				for (var k:Number = 0; k < bArray.length; k++){
					for (var j:uint = k + 1; j < bArray.length; j++){
						if (k != j && bArray[k].hitTestObject(bArray[j])){
							var temp:Number = xArray[k];
							xArray[k] = xArray[j];//swaps the momentum of bullets
							xArray[j] = xArray[k];
							temp = yArray[k];
							yArray[k] = yArray[j];
							yArray[j] = yArray[k];
							yArray[j] = temp;
							break;
						}
					}
				}
			}
			function moveGun():void{//take a whild guess at what this does
				if (dir == "left") g.x -= 5;
				if (dir == "right")g.x += 5;
			}
			function textRefresher():void{//constantly refreshes the text and changes based on some variables
				if (spawnRate < 30){//changes spawnrate text based of difficulty
					lTf.color = 0x00FF00;
					lvlTxt.setTextFormat(lTf);
					lvlTxt.text = String("Low Activity");
				}
				else if (spawnRate < 20){
					lTf.color = 0xFFFF33;
					lvlTxt.setTextFormat(lTf);
					lvlTxt.text = String("Medium Activity");
				}
				if (spawnRate < 10){
					lTf.color = 0xCC000;
					lvlTxt.setTextFormat(lTf);
					lvlTxt.text = String("High Activity");
				}
				lenTxt.text = String(l.height);
				accTxt.text = String(Math.floor(killed / shot * 100) + "%");
				livesTxt.text = String(lives + "lives left");
				killsTxt.text = String(killed);
				if (mDown == true){//when mouse is down, place text above
					lenTxt.x = l.x - 25;
					lenTxt.y = l.y - 25;
				}
			}
			function gameOver():void{//adds a gameover overlay
				var end:overSceen = new overSceen();
				end.x = 275;
				end.y = 200;
				addChild(end);
			}
		}
	}
}